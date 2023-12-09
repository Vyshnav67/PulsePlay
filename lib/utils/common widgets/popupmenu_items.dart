import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/view/songs/widgets/playlist_bottomsheet.dart';
import 'package:music_player/utils/common%20widgets/song_details.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../constants/constants.dart';

class MusicLIstPopUpMenu extends StatelessWidget {
  final String uri;
  final MusicPlayerController controller;
  final SongModel song;
  const MusicLIstPopUpMenu(
      {super.key,
      required this.uri,
      required this.controller,
      required this.song});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Constants.bottomBarIconColor,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () {
              Navigator.pop(context);
              controller.addToFavorite(song, context);
            },
            child: const Text("Add to favorite"),
          ),
          PopupMenuItem(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return PlaylistBottomSheet(song: song);
                },
              );
            },
            child: const Text("Add to playlist"),
          ),
          PopupMenuItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Details'),
                  content: SongDetails(song: song),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ok'))
                  ],
                ),
              );
            },
            child: const Text("Details"),
          ),
        ];
      },
    );
  }
}
