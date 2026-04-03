import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/songs/song.dart';
import '../../../../model/comment/comment.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/comment/comment_tile.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/artists_view_model.dart';

class ArtistContent extends StatefulWidget {
  const ArtistContent({super.key});

  @override
  State<ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<ArtistContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ArtistViewModel vm = context.watch<ArtistViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Artist header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(vm.artist.imageUrl.toString()),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.artist.name, style: AppTextStyles.heading),
                      Text(vm.artist.genre,
                          style: AppTextStyles.label
                              .copyWith(color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),
              Text('Songs', style: AppTextStyles.title),
              SizedBox(height: 8),
              _buildSongs(vm),

              SizedBox(height: 24),
              Text('Comments', style: AppTextStyles.title),
              SizedBox(height: 8),
              Expanded(child: _buildComments(vm)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                if (_commentController.text.trim().isEmpty) return;
                await vm.addComment(_commentController.text);
                _commentController.clear();
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongs(ArtistViewModel vm) {
    switch (vm.songsValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Failed to load songs',
            style: TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final List<Song> songs = vm.songsValue.data!;
        if (songs.isEmpty) {
          return Text('No songs yet.',
              style: AppTextStyles.label.copyWith(color: AppColors.textLight));
        }
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) => SongTile(song: songs[index]),
          ),
        );
    }
  }

  Widget _buildComments(ArtistViewModel vm) {
    switch (vm.commentsValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
            child: Text('Failed to load comments',
                style: TextStyle(color: Colors.red)));
      case AsyncValueState.success:
        final List<Comment> comments = vm.commentsValue.data!;
        if (comments.isEmpty) {
          return Center(
              child: Text('No comments yet.',
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textLight)));
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) =>
              CommentTile(comment: comments[index]),
        );
    }
  }
}