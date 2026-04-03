import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static const String _baseHost =
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app';

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
}