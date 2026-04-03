import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});
  Future<Artist?> fetchArtistById(String id);
  Future<List<Song>> fetchSongsByArtist(String artistId);     
  Future<List<Comment>> fetchComments(String artistId);       
  Future<Comment> postComment(String artistId, String text);  
}