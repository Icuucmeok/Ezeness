import 'dart:async';
import 'dart:developer';
import 'dart:io' show File, Platform;

import 'package:ezeness/data/models/app_url.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
import 'package:ezeness/logic/cubit/comment/comment_cubit.dart';
import 'package:ezeness/logic/cubit/discover_post/discover_post_cubit.dart';
import 'package:ezeness/logic/cubit/explore_shop_post/explore_shop_post_cubit.dart';
import 'package:ezeness/logic/cubit/explore_social_post/explore_social_post_cubit.dart';
import 'package:ezeness/logic/cubit/like_post/like_post_cubit.dart';
import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/logic/cubit/post_comment/post_comment_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/logic/cubit/report/report_cubit.dart';
import 'package:ezeness/presentation/screens/discover/discover_screen.dart';
import 'package:ezeness/presentation/screens/explore/explore_screen.dart';
import 'package:ezeness/presentation/screens/activity/activity_screen.dart';
import 'package:ezeness/presentation/screens/profile/panel/new_panel_screen.dart';
import 'package:ezeness/presentation/screens/profile/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';
import 'package:upgrader/upgrader.dart';

import '../../../data/data_providers/api_client.dart';
import '../../../data/repositories/explore_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/playlist_repository.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/block_user/block_user_cubit.dart';
import '../../../logic/cubit/bookmark_post/bookmark_post_cubit.dart';
import '../../../logic/cubit/bookmark_user/bookmark_user_cubit.dart';
import '../../../logic/cubit/delete_post/delete_post_cubit.dart';
import '../../../logic/cubit/explore/explore_cubit.dart';
import '../../../logic/cubit/explore_home/explore_home_cubit.dart';
import '../../../logic/cubit/explore_kids/explore_kids_cubit.dart';
import '../../../logic/cubit/explore_post/explore_post_cubit.dart';
import '../../../logic/cubit/explore_shop/explore_shop_cubit.dart';
import '../../../logic/cubit/explore_social/explore_social_cubit.dart';
import '../../../logic/cubit/liftup_post/liftup_post_cubit.dart';
import '../../../logic/cubit/my_favourite/my_favourite_cubit.dart';
import '../../../logic/cubit/my_post/my_post_cubit.dart';
import '../../../logic/cubit/payment/payment_cubit.dart';
import '../../../logic/cubit/play_list/cubit/play_list_cubit.dart';
import '../../../logic/cubit/post/post_cubit.dart';
import '../../../logic/cubit/seen_notification/seen_notification_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../logic/cubit/subscribe_user_notification/subscribe_user_notification_cubit.dart';
import '../../../logic/cubit/user_post/user_post_cubit.dart';
import '../../../res/app_res.dart';
import '../../router/app_router.dart';
import '../../services/fcm_service.dart';
import '../../services/upload_notification.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/helpers.dart';
import '../post/post_view_screen.dart';
import '../profile/add_edit_post/add_edit_post_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = 'home_screen';
  final AppRouter appRouter;
  final ApiClient apiClient;

  const HomeScreen(this.apiClient, this.appRouter, {Key? key})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  late List<Widget> pages;
  List<GlobalKey<NavigatorState>> _navigatorKeys = [];
  StreamSubscription<Uri?>? _sub;
  StreamSubscription? _intentSub;
  Uri? _lastHandledUri;
  bool _isHandlingSharedMedia = false;
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    FcmService.fcmSetup(context);
    isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();

    // Handle deep links when app is in background
    initUniLinks(context);

    // Handle shared media when app is in background or closed
    handleSharedMedia(isLoggedIn);

    // Navigator keys for different pages
    AppRouter.navigatorKeysBottomNav = [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ];
    _navigatorKeys = AppRouter.navigatorKeysBottomNav;

    // Initialize pages with respective Blocs
    pages = initializePages();

    // Set initial selected tab
    selectedTab = 0;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _intentSub?.cancel();
    super.dispose();
  }

  Future<void> initUniLinks(BuildContext context) async {
    try {
      Uri? initialLink = await getInitialUri();
      if (initialLink != null) {
        handleDeepLink(context, initialLink);
      }
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          handleDeepLink(context, uri);
        }
      }, onError: (err) {});
    } on PlatformException {
      print('Platform exception during uni links initialization');
    }
  }

  void handleDeepLink(BuildContext context, Uri uri) {
    if (mounted && _canNavigate(uri)) {
      _lastHandledUri = uri;
      AppUrl appUrl = AppUrl.parseUrl(uri.toString());
      if (appUrl.type == "post") {
        Navigator.of(AppRouter.mainContext).pushNamed(
          PostViewScreen.routName,
          arguments: {"post": Post(id: appUrl.id)},
        );
      } else if (appUrl.type == "user") {
        Navigator.of(AppRouter.mainContext).pushNamed(
          ProfileScreen.routName,
          arguments: {"isOther": true, "user": User(id: appUrl.id)},
        );
      }
    }
  }

  bool _canNavigate(Uri uri) {
    // Ensure that the same URI is not handled multiple times
    return uri != _lastHandledUri;
  }

  void handleSharedMedia(bool isLoggedIn) {
    _intentSub =
        ReceiveSharingIntent.instance.getMediaStream().listen((value) async {
      await handleSharedMediaNavigation(value, isLoggedIn);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((value) async {
      await handleSharedMediaNavigation(value, isLoggedIn);

      ReceiveSharingIntent.instance.reset();
    });
  }

  Future<void> handleSharedMediaNavigation(
      List<SharedMediaFile> value, bool isLoggedIn) async {
    if (mounted && !_isHandlingSharedMedia) {
      _isHandlingSharedMedia = true;
      if (value.isNotEmpty) {
        if (value.first.type == SharedMediaType.image ||
            value.first.type == SharedMediaType.video) {
          if (isLoggedIn) {
            await Navigator.of(AppRouter.mainContext).pushNamed(
              AddEditPostScreen.routName,
              arguments: {
                "sharedFiles": value.map((e) => File(e.path)).toList(),
              },
            );
          } else {
            Helpers.onGustTapButton();
          }
        }
      }
      _isHandlingSharedMedia = false;
    }
  }

  List<Widget> initializePages() {
    return [
      buildDiscoverNavigator(),
      buildExploreNavigator(),
      buildProfileNavigator(),
      if (widget.apiClient.isKids != 1)
        buildActivityNavigator()
      else
        SizedBox(),
      // if (widget.apiClient.isKids != 1)
      buildPanelNavigator(),
    ];
  }

  MultiBlocProvider buildDiscoverNavigator() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DiscoverPostCubit>(
          create: (_) => DiscoverPostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<LikePostCubit>(
          create: (_) => LikePostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<BookmarkPostCubit>(
          create: (_) => BookmarkPostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<CommentCubit>(
          create: (_) => CommentCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<PostCommentCubit>(
          create: (_) => PostCommentCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<SubscribeUserNotificationCubit>(
          create: (_) => SubscribeUserNotificationCubit(
              ProfileRepository(widget.apiClient)),
        ),
        BlocProvider<PlayListCubit>(
          create: (_) => PlayListCubit(PlayListRepository(widget.apiClient)),
        ),
        BlocProvider<BlockUserCubit>(
          create: (_) => BlockUserCubit(ProfileRepository(widget.apiClient)),
        ),
        BlocProvider<DeletePostCubit>(
          create: (_) => DeletePostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<ReportCubit>(
          create: (_) => ReportCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<PostCubit>(
          create: (_) => PostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<LiftUpPostCubit>(
          create: (_) => LiftUpPostCubit(PostRepository(widget.apiClient)),
        ),
      ],
      child: Navigator(
        key: _navigatorKeys[0],
        initialRoute: DiscoverScreen.routName,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }

  MultiBlocProvider buildExploreNavigator() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExplorePostCubit>(
          create: (_) => ExplorePostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreCubit>(
          create: (_) => ExploreCubit(ExploreRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreHomeCubit>(
          create: (_) => ExploreHomeCubit(ExploreRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreShopCubit>(
          create: (_) => ExploreShopCubit(ExploreRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreSocialCubit>(
          create: (_) =>
              ExploreSocialCubit(ExploreRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreKidsCubit>(
          create: (_) => ExploreKidsCubit(ExploreRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreShopPostCubit>(
          create: (_) => ExploreShopPostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<ExploreSocialPostCubit>(
          create: (_) =>
              ExploreSocialPostCubit(PostRepository(widget.apiClient)),
        ),
      ],
      child: Navigator(
        key: _navigatorKeys[1],
        initialRoute: ExploreScreen.routName,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }

  MultiBlocProvider buildProfileNavigator() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepository(widget.apiClient)),
        ),
        BlocProvider<MyPostCubit>(
          create: (_) => MyPostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<UserPostCubit>(
          create: (_) => UserPostCubit(PostRepository(widget.apiClient)),
        ),
        BlocProvider<MyFavouriteCubit>(
          create: (_) => MyFavouriteCubit(ProfileRepository(widget.apiClient)),
        ),
        BlocProvider<BookmarkUserCubit>(
          create: (_) => BookmarkUserCubit(ProfileRepository(widget.apiClient)),
        ),
        BlocProvider<SubscribeUserNotificationCubit>(
          create: (_) => SubscribeUserNotificationCubit(
              ProfileRepository(widget.apiClient)),
        ),
        BlocProvider<BlockUserCubit>(
          create: (_) => BlockUserCubit(ProfileRepository(widget.apiClient)),
        ),
      ],
      child: Navigator(
        key: _navigatorKeys[2],
        initialRoute: ProfileScreen.routName,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }

  Widget buildActivityNavigator() {
    return Navigator(
      key: _navigatorKeys[3],
      initialRoute: ActivityScreen.routName,
      onGenerateRoute: widget.appRouter.generateRoute,
    );
  }

  MultiBlocProvider buildPanelNavigator() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PaymentCubit>(
          create: (_) => PaymentCubit(PaymentRepository(widget.apiClient)),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepository(widget.apiClient)),
        ),
      ],
      child: Navigator(
        key: _navigatorKeys[4],
        initialRoute: NewPanelScreen.routName, // PanelScreen.routName,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setStatusBarStyle();
  }

  void _setStatusBarStyle() {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    log("change overlay");
    // Manually setting the system overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isLightTheme ? Colors.white : AppColors.blackColor,
        statusBarIconBrightness:
            isLightTheme ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isLightTheme ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    AppRouter.mainContext = context;
    return UpgradeAlert(
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      showIgnore: false,
      child: WillPopScope(
      onWillPop: () async {
        onWillPop();
        return Future.value(false); 
      },
        child: SafeArea(
          child: Scaffold(
            body: BlocConsumer<AddEditPostCubit, AddEditPostState>(
                listener: (context, state) {
              if (state is AddEditPostLoading) {
                UploadNotification.cancelNotification(0);
                UploadNotification.showUploadNotification(
                    0, 'Uploading', 'Post uploading in progress...', true);
              }
              if (state is AddPostDone) {
                UploadNotification.cancelNotification(0);
                AppSnackBar(
                        message: S.current.addedSuccessfully, context: context)
                    .showSuccessSnackBar();
              }
              if (state is EditPostDone) {
                UploadNotification.cancelNotification(0);
                AppSnackBar(
                        message: S.current.editSuccessfully, context: context)
                    .showSuccessSnackBar();
              }
              if (state is AddEditPostFailure) {
                UploadNotification.cancelNotification(0);
                UploadNotification.showUploadNotification(
                    0, 'Failed', 'Failed to publish post', false);
                ErrorHandler(exception: state.exception)
                    .showErrorSnackBar(context: context);
              }
            }, builder: (context, state) {
              return IndexedStack(index: selectedTab, children: pages);
            }),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              child: SizedBox(
                height: Platform.isAndroid ? 50 : null,
                child: Theme(
                  data: selectedTab == 0 || user.isDarkBottomNavigation
                      ? Styles.darkTheme
                      : Theme.of(context),
                  child: BottomNavigationBar(
                    backgroundColor:
                        selectedTab == 0 || user.isDarkBottomNavigation
                            ? Colors.black
                            : null,
                    type: BottomNavigationBarType.fixed,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedFontSize: 0,
                    unselectedFontSize: 0,
                    selectedItemColor: AppColors.primaryColor,
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(
                          IconlyLight.play,
                          size: 28,
                        ),
                        activeIcon: Icon(
                          IconlyLight.play,
                          size: 28,
                        ),
                        label: "Discover",
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(
                          IconlyBroken.search,
                          size: 28,
                        ),
                        activeIcon: Icon(
                          IconlyBroken.search,
                          size: 28,
                        ),
                        label: "Explore",
                      ),
                      BottomNavigationBarItem(
                        icon: _buildLogoIcon(),
                        activeIcon: _buildLogoIcon(),
                        label: "Profile",
                      ),
                      if (widget.apiClient.isKids != 1)
                        BottomNavigationBarItem(
                          icon: _buildActivityIcon(),
                          activeIcon: _buildActivityIcon(),
                          label: "Activities",
                        ),
                      if (widget.apiClient.isKids == 1)
                        BottomNavigationBarItem(
                          label: "kids",
                          icon: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 18),
                              Text(S.current.kids,
                                  style: TextStyle(
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: widget.apiClient.isKids == 1
                                          ? AppColors.green
                                          : AppColors.greyDark)),
                              const SizedBox(width: 5),
                              Icon(
                                IconlyBold.shield_fail,
                                size: 18,
                                color: widget.apiClient.isKids == 1
                                    ? AppColors.green
                                    : AppColors.greyDark,
                              ),
                            ],
                          ),
                        ),
                      // if (widget.apiClient.isKids != 1)
                      const BottomNavigationBarItem(
                        icon: Icon(
                          IconlyLight.more_square,
                          size: 28,
                        ),
                        activeIcon: Icon(
                          IconlyLight.more_square,
                          size: 28,
                        ),
                        label: "Panel",
                      ),
                    ],
                    currentIndex: selectedTab,
                    onTap: (value) {
                      if (widget.apiClient.isKids == 1 && value == 3) return;
                      int previousSelectedTap = selectedTab;
                      setState(() {
                        selectedTab = value;
                      });
                      if (selectedTab == 0 && previousSelectedTap == 0) {
                        context.read<AppConfigCubit>().discoverScreenGoUp();
                      }
                      if (selectedTab == 1 && previousSelectedTap == 1) {
                        context.read<AppConfigCubit>().exploreScreenGoUp();
                      }
                      if (selectedTab == 2 && previousSelectedTap == 2) {
                        context.read<AppConfigCubit>().panelScreenOnTapLogo();
                      }
                      if (previousSelectedTap == 3 && isLoggedIn) {
                        context
                            .read<NotificationCubit>()
                            .zeroTotalUnSeenNumber();
                        context
                            .read<SeenNotificationCubit>()
                            .setNotificationSeen(null);
                        context
                            .read<NotificationCubit>()
                            .getNotificationsLists();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onWillPop() async {
    final canPop =
        AppRouter.navigatorKeysBottomNav[selectedTab].currentState!.canPop();

    if (canPop) {
      AppRouter.popInSubNavigator(selectedTab);
    } else if (selectedTab != 0) {
      setState(() {
        selectedTab = 0;
      });
    } else {
      return SystemNavigator.pop();
    }

    return false;
  }

  _buildLogoIcon() {
    User user = context.read<AppConfigCubit>().getUser();
    return Image.asset(
      selectedTab == 0 ||
              user.isDarkBottomNavigation ||
              Theme.of(context).brightness == Brightness.dark
          ? Assets.assetsImagesCircleLogoDark
          : Assets.assetsImagesCircleLogo,
      width: Helpers.isTab(context) ? 50 : 30.w,
      height: Helpers.isTab(context) ? 50 : 30.h,
    );
  }

  _buildActivityIcon() {
    int totalUnSeenNumber =
        BlocProvider.of<NotificationCubit>(context, listen: true)
            .totalUnSeenNumber;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          IconlyLight.activity,
          size: 28,
        ),
        if (totalUnSeenNumber != 0)
          Positioned(
            top: -2,
            right: -2,
            child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: FittedBox(
                    child: Text(
                        totalUnSeenNumber > 99
                            ? "+99"
                            : totalUnSeenNumber.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white, fontSize: 10)))),
          ),
      ],
    );
  }
}
