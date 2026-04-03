import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase implements SongRepository {
  static const String _baseHost =
      '';

  final Uri songsUri = Uri.https(_baseHost, '/songs.json');

  Uri _songUri(String songId) => Uri.https(_baseHost, '/songs/$songId.json');

  List<Song>? _cachedSongs; 

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    // 1- Return cache if available
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);
    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);
      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      // 2- Store in memory
      _cachedSongs = result;
      return result;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final response = await http.get(_songUri(id));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json_ = json.decode(response.body);
      return SongDto.fromJson(id, json_);
    }
    return null;
  }

  @override
  Future<Song> likeSong(String songId, int currentLikes) async {
    final int newLikes = currentLikes + 1;

    final response = await http.patch(
      _songUri(songId),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'likes': newLikes}),
    );

    if (response.statusCode == 200) {
      final Song? updatedSong = await fetchSongById(songId);
      if (updatedSong == null) throw Exception('Song not found after like');
      // 3- Update cache with new likes count
      if (_cachedSongs != null) {
        _cachedSongs = _cachedSongs!
            .map((s) => s.id == songId ? updatedSong : s)
            .toList();
      }
      return updatedSong;
    } else {
      throw Exception('Failed to like song: ${response.statusCode}');
    }
  }
}