import 'package:flutter/material.dart';
import '../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.imageUrl.toString()),
          ),
          title: Text(song.title),
          subtitle: Text('${song.duration.inMinutes} min'),
        ),
      ),
    );
  }
}