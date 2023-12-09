import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/constants.dart';
import '../../nowPlaying/ui/now_playing.dart';

class FloatingMiniPlayer extends StatelessWidget {
  const FloatingMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController =
        Provider.of<MusicPlayerController>(context);
    if (musicPlayerController.currentlyPlaying == null) {
      var recentSongdb = recentsBox.get(Constants.recentsBoxName);
      String? lastPlayedPlaylist = prefs.getString(Constants.lastPlaylist);
      if (recentSongdb == null ||
          recentSongdb.songs.isEmpty ||
          lastPlayedPlaylist == null) {
        return Container();
      } else {
        int? lastPosition = prefs.getInt(Constants.LASTPOSITIONKEY);
        int lastIndex = prefs.getInt(Constants.lastPlayedIndex)!;
        return FutureBuilder(
            future: musicPlayerController.searchSongs(),
            builder: (context, snapshot) {
              List<SongModel> playlist = [];
              if (lastPlayedPlaylist == Constants.allSongs) {
                playlist = MusicPlayerController.allSongs;
              } else if (lastPlayedPlaylist == Constants.recentsBoxName) {
                playlist = recentsBox.get(Constants.recentsBoxName)!.songs;
              } else {
                playlist = favoriteBox.get(Constants.favoritesBoxName)!.songs;
              }
              SongModel lastPlayed = recentSongdb.songs.first;
              return SizedBox(
                // height: MediaQuery.sizeOf(context).height / 10,
                child: Center(
                  child: ListTile(
                    leading: QueryArtworkWidget(
                        nullArtworkWidget: const SizedBox(
                          height: 52,
                          width: 52,
                          child: Card(
                              child: Center(
                            child: Icon(
                              Icons.music_note_rounded,
                              size: 30,
                            ),
                          )),
                        ),
                        id: lastPlayed.id,
                        type: ArtworkType.AUDIO),
                    title: Text(
                      lastPlayed.title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: Constants.musicListTextStyle,
                    ),
                    subtitle: Text(
                      lastPlayed.artist! == "<unknown>"
                          ? "Unknown Artist"
                          : lastPlayed.artist!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Constants.musicListTextStyle,
                    ),
                    trailing: Consumer<MusicPlayerController>(
                        builder: (context, provider, child) {
                      return IconButton(
                          onPressed: () {
                            if (!musicPlayerController.audioPlayer.playing) {
                              if (lastPosition != null) {
                                musicPlayerController.playLastSong(
                                    songmodel: lastPlayed,
                                    index: lastIndex,
                                    listofSongs: playlist,
                                    lastPlaylist: lastPlayedPlaylist);
                              } else {
                                musicPlayerController.playSong(
                                    songmodel: lastPlayed,
                                    index: lastIndex,
                                    listofSongs: playlist,
                                    lastPlaylist: lastPlayedPlaylist);
                              }
                            } else {
                              musicPlayerController.toggleSong();
                            }
                          },
                          icon: Icon(
                            musicPlayerController.audioPlayer.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Constants.bottomBarIconColor,
                          ));
                    }),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlaying(
                                index: lastIndex,
                                songModel: lastPlayed,
                                listofSongs: playlist,
                                playlistName: lastPlayedPlaylist,
                                lastPos:
                                    Duration(milliseconds: lastPosition ?? 0)),
                          ));
                    },
                  ),
                ),
              );
            });
      }
    } else {
      String lastPlayedPlaylist = prefs.getString(Constants.lastPlaylist)!;
      List<SongModel> playlist = [];
      if (lastPlayedPlaylist == Constants.allSongs) {
        playlist = MusicPlayerController.allSongs;
      } else if (lastPlayedPlaylist == Constants.recentsBoxName) {
        playlist = recentsBox.get(Constants.recentsBoxName)!.songs;
      } else {
        playlist = favoriteBox.get(Constants.favoritesBoxName)!.songs;
      }
      return SizedBox(
        // height: MediaQuery.sizeOf(context).height / 10,
        child: Center(
          child: ListTile(
            leading: QueryArtworkWidget(
                nullArtworkWidget: const SizedBox(
                  height: 52,
                  width: 52,
                  child: Card(
                      child: Center(
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 30,
                    ),
                  )),
                ),
                id: musicPlayerController.currentlyPlaying!.id,
                type: ArtworkType.AUDIO),
            title: Text(
              musicPlayerController.currentlyPlaying!.title,
              style: Constants.musicListTextStyle,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            subtitle: Text(
              musicPlayerController.currentlyPlaying!.artist! == "<unknown>"
                  ? "Unknown Artist"
                  : musicPlayerController.currentlyPlaying!.artist!,
              style: Constants.musicListTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: () {
                  musicPlayerController.toggleSong();
                },
                icon: Icon(
                  musicPlayerController.audioPlayer.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Constants.bottomBarIconColor,
                )),
            onTap: () {
              String playlistName = prefs.getString(Constants.lastPlaylist)!;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlaying(
                      index: musicPlayerController.currentlyPlayingIndex,
                      songModel: musicPlayerController.currentlyPlaying!,
                      listofSongs: playlist,
                      playlistName: playlistName,
                      play: false,
                    ),
                  ));
            },
          ),
        ),
      );
    }
  }
}
