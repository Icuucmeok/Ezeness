import 'package:ezeness/data/models/playlist/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/post/post.dart';
import '../../data/models/user/user.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../logic/cubit/play_list/cubit/play_list_cubit.dart';
import '../utils/app_dialog.dart';
import 'common/common.dart';

class PlayListWidget extends StatefulWidget {
  final Post post;
  final PlayListCubit playListCubit;
  const PlayListWidget(
      {required this.playListCubit, required this.post, Key? key})
      : super(key: key);

  @override
  State<PlayListWidget> createState() => _PlayListWidgetState();
}

class _PlayListWidgetState extends State<PlayListWidget> {
  @override
  Widget build(BuildContext context) {
    final User user = context.read<AppConfigCubit>().getUser();
    return BlocConsumer<PlayListCubit, PlayListState>(
        bloc: widget.playListCubit,
        listener: (context, state) {
          if (state is PlaylistAdded) {
            user.playlist.add(state.response);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Save Post to...',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white, fontSize: 16),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        AppDialog.showNewPlaylistDialog(
                            context, widget.playListCubit);
                      },
                      icon: const Icon(Icons.add, color: Colors.blue),
                      label: Text(
                        'New playlist',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                Expanded(
                  child: ListView.builder(
                    itemCount: user.playlist.length,
                    itemBuilder: (BuildContext context, int i) {
                      return _buildListItem(user.playlist[i]);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildListItem(Playlist playlist) {
    return ListTile(
      leading: AppCheckBox(
        value: widget.post.postPlaylist!.any((e) => e.id == playlist.id),
        onChange: () {
          widget.playListCubit.addRemovePostPlayList(
              postId: widget.post.id!, playlistId: playlist.id!);
        },
      ),
      title: Text(
        playlist.name.toString(),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
