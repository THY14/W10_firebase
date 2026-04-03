import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';
import '../../../model/songs/song.dart';
import '../../../model/comment/comment.dart';
import '../../dtos/comment_dto.dart';
import '../../dtos/song_dto.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static const String _baseHost =
      '';

  final Uri artistsUri = Uri.https(_baseHost, '/artists.json');

  Uri _artistUri(String artistId) =>
      Uri.https(_baseHost, '/artists/$artistId.json');

  List<Artist>? _cachedArtists; 

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1- Return cache 
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in artistJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
      // 2- Store in memory
      _cachedArtists = result;
      return result;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final response = await http.get(_artistUri(id));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json_ = json.decode(response.body);
      return ArtistDto.fromJson(id, json_);
    }
    return null;
    
  }
  @override
  Future<List<Song>> fetchSongsByArtist(String artistId) async {
    final response = await http.get(songsUri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> allSongs = json.decode(response.body);
      return allSongs.entries
          .where((e) => e.value['artistId'] == artistId)
          .map((e) => SongDto.fromJson(e.key, e.value))
          .toList();
    }
    throw Exception('Failed to load songs for artist');
  }

  @override
  Future<List<Comment>> fetchComments(String artistId) async {
    final Uri commentsUri = Uri.https(_baseHost, '/comments.json');
    final response = await http.get(commentsUri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body == null) return [];
      final Map<String, dynamic> allComments = body;
      return allComments.entries
          .where((e) => e.value['artistId'] == artistId)
          .map((e) => CommentDto.fromJson(e.key, e.value))
          .toList();
    }
    throw Exception('Failed to load comments');
  }

  @override
  Future<Comment> postComment(String artistId, String text) async {
    final Uri commentsUri = Uri.https(_baseHost, '/comments.json');
    final response = await http.post(
      commentsUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(CommentDto.toJson(artistId, text)),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      final String newId = result['name']; 
      return Comment(id: newId, text: text, artistId: artistId);
    }
    throw Exception('Failed to post comment');
  }


}