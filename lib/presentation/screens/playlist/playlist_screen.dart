import 'package:ezeness/data/models/playlist/playlist.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/logic/cubit/playlist_post/playlist_post_cubit.dart';
import 'package:ezeness/presentation/widgets/playlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/utils/error_handler.dart';
import '../../widgets/common/common.dart';
import '../../widgets/post_grid_view.dart';

class PlaylistScreen extends StatefulWidget {
  static const String routName = 'playlist_screen';
  final args;
  const PlaylistScreen({this.args, Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late PlaylistPostCubit _playlistPostCubit;

  Playlist? selectedPlaylist;
  late List<Playlist> playlistList;
  @override
  void initState() {
    _playlistPostCubit = context.read<PlaylistPostCubit>();
    if (widget.args != null) {
      if (widget.args["selectedPlaylist"] != null) {
        selectedPlaylist = widget.args["selectedPlaylist"] as Playlist;
      }
      if (widget.args["playlistList"] != null) {
        playlistList = widget.args["playlistList"] as List<Playlist>;
      }
    }
    if (selectedPlaylist == null) selectedPlaylist = playlistList.first;
    _playlistPostCubit.getPostsByPlaylistId(selectedPlaylist!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: selectedPlaylist == null
            ? SizedBox()
            : Text(selectedPlaylist!.name.toString(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      letterSpacing: 0.2,
                      height: 1.2.h,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0.sp,
                    )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        alignment: Alignment.topCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: .275.sw,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...playlistList
                          .map((e) => Padding(
                                padding:
                                    EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                child: PlaylistWidget(
                                    onTap: () {
                                      selectedPlaylist = e;
                                      setState(() {});
                                      _playlistPostCubit.getPostsByPlaylistId(
                                          selectedPlaylist!.id!);
                                    },
                                    playlist: e,
                                    isSelected: selectedPlaylist != null &&
                                        selectedPlaylist!.id == e.id),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PlaylistPostCubit, PlaylistPostState>(
                  bloc: _playlistPostCubit,
                  builder: (context, state) {
                    if (state is PlaylistPostListLoading) {
                      return const CenteredCircularProgressIndicator();
                    }
                    if (state is PlaylistPostListFailure) {
                      return ErrorHandler(exception: state.exception)
                          .buildErrorWidget(
                              context: context,
                              retryCallback: () => _playlistPostCubit
                                  .getPostsByPlaylistId(selectedPlaylist!.id!));
                    }
                    if (state is PlaylistPostListLoaded) {
                      List<Post> list = state.response.postList!;
                      return PostGridView(list,
                          onPostTapShowInList: true,
                          isScroll: true,
                          minSpacing: 3);
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
