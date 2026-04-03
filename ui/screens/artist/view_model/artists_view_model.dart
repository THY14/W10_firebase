import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistViewModel({required this.artistRepository, required this.artist}) {
    fetchData();
  }

  Future<void> fetchData() async {
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final songs = await artistRepository.fetchSongsByArtist(artist.id);
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }

    try {
      final comments = await artistRepository.fetchComments(artist.id);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;
    try {
      final Comment newComment =
          await artistRepository.postComment(artist.id, text);
      final List<Comment> current = commentsValue.data ?? [];
      commentsValue = AsyncValue.success([...current, newComment]);
      notifyListeners();
    } catch (e) {
      debugPrint('Error posting comment: $e');
    }
  }
}