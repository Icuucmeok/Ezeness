import 'package:ezeness/data/data_providers/api_client.dart';
import 'package:ezeness/data/models/cart/cart_model.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/repositories/Notification_repository.dart';
import 'package:ezeness/data/repositories/app_config_repository.dart';
import 'package:ezeness/data/repositories/boost_repository.dart';
import 'package:ezeness/data/repositories/category_repository.dart';
import 'package:ezeness/data/repositories/following_repository.dart';
import 'package:ezeness/data/repositories/gold_coin_repository.dart';
import 'package:ezeness/data/repositories/invite_user_repository.dart';
import 'package:ezeness/data/repositories/payment_repository.dart';
import 'package:ezeness/data/repositories/playlist_repository.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
import 'package:ezeness/data/repositories/search_repository.dart';
import 'package:ezeness/logic/cubit/add_banner_boost/add_banner_boost_cubit.dart';
import 'package:ezeness/logic/cubit/add_post_boost/add_post_boost_cubit.dart';
import 'package:ezeness/logic/cubit/banner_plans/banner_plans_cubit.dart';
import 'package:ezeness/logic/cubit/calculate_coin/calculate_coin_cubit.dart';
import 'package:ezeness/logic/cubit/category/category_cubit.dart';
import 'package:ezeness/logic/cubit/convert_coin/convert_coin_cubit.dart';
import 'package:ezeness/logic/cubit/followers/followers_cubit.dart';
import 'package:ezeness/logic/cubit/invite_user/invite_user_cubit.dart';
import 'package:ezeness/logic/cubit/liftup_post/liftup_post_cubit.dart';
import 'package:ezeness/logic/cubit/notification_by_type/notification_by_type_cubit.dart';
import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/play_list/cubit/play_list_cubit.dart';
import 'package:ezeness/logic/cubit/playlist_post/playlist_post_cubit.dart';
import 'package:ezeness/logic/cubit/post/post_cubit.dart';
import 'package:ezeness/logic/cubit/post_plans/post_plans_cubit.dart';
import 'package:ezeness/logic/cubit/pro_invitation/pro_invitations_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/logic/cubit/reviews/reviews_cubit.dart';
import 'package:ezeness/logic/cubit/search/search_cubit.dart';
import 'package:ezeness/logic/cubit/user_reviews/user_reviews_cubit.dart';
import 'package:ezeness/presentation/screens/activity/activity_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/banner/banner_boost_payment_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/banner/banner_boost_terms_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/banner/banner_plans_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/post/post_boost_payment_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/post/post_boost_terms_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/post/post_plans_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/select_post_to_add_boost_screen.dart';
import 'package:ezeness/presentation/screens/auth/auth_screen.dart';
import 'package:ezeness/presentation/screens/auth/reset_password/reset_password_screen.dart';
import 'package:ezeness/presentation/screens/auth/sign_in_screen.dart';
import 'package:ezeness/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:ezeness/presentation/screens/category/category_screen.dart';
import 'package:ezeness/presentation/screens/category/select_category_screen.dart';
import 'package:ezeness/presentation/screens/checkout_screen.dart';
import 'package:ezeness/presentation/screens/discover/discover_screen.dart';
import 'package:ezeness/presentation/screens/explore/explore_screen.dart';
import 'package:ezeness/presentation/screens/explore/explore_section_post_screen.dart';
import 'package:ezeness/presentation/screens/explore/explore_users_screen.dart';
import 'package:ezeness/presentation/screens/filter_screen.dart';
import 'package:ezeness/presentation/screens/get_user_location_screen.dart';
import 'package:ezeness/presentation/screens/home/home_screen.dart';
import 'package:ezeness/presentation/screens/onboarding_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/calculate_convert_coin_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_buy_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_coins_dashboard_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_coins_details_screen.dart';
import 'package:ezeness/presentation/screens/panel/notification_by_type_screen.dart';
import 'package:ezeness/presentation/screens/panel/panel_screen.dart';
import 'package:ezeness/presentation/screens/panel/setting_screen.dart';
import 'package:ezeness/presentation/screens/post/hashtag_post_screen.dart';
import 'package:ezeness/presentation/screens/post/post_details_screen.dart';
import 'package:ezeness/presentation/screens/post/post_list_view_screen.dart';
import 'package:ezeness/presentation/screens/post/post_view_screen.dart';
import 'package:ezeness/presentation/screens/profile/about/about_screen.dart';
import 'package:ezeness/presentation/screens/profile/about/privacy_policy_screen.dart';
import 'package:ezeness/presentation/screens/profile/about/term_of_use_screen.dart';
import 'package:ezeness/presentation/screens/profile/bookmark_screen.dart';
import 'package:ezeness/presentation/screens/profile/edit_profile_screen/edit_bio_screen.dart';
import 'package:ezeness/presentation/screens/profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:ezeness/presentation/screens/profile/edit_profile_screen/edit_username_screen.dart';
import 'package:ezeness/presentation/screens/profile/followers/followers_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/invite_users_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/pro/add_pro_invite_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/pro/pro_invites_list_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/special/add_special_invite_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/special/special_invites_list_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/stander/add_stander_invite_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/stander/stander_invites_list_screen.dart';
import 'package:ezeness/presentation/screens/profile/invite_users/view_invite_screen.dart';
import 'package:ezeness/presentation/screens/profile/menu_screen.dart';
import 'package:ezeness/presentation/screens/profile/panel/new_panel_screen.dart';
import 'package:ezeness/presentation/screens/profile/privacy_security/create_change_password_screen.dart';
import 'package:ezeness/presentation/screens/profile/privacy_security/privacy_security_screen.dart';
import 'package:ezeness/presentation/screens/profile/profile/profile_screen.dart';
import 'package:ezeness/presentation/screens/profile/store_upgrade/store_upgrade_screen.dart';
import 'package:ezeness/presentation/screens/profile/user_reviews_screen.dart';
import 'package:ezeness/presentation/screens/profile/username_upgrade/username_upgrade_screen.dart';
import 'package:ezeness/presentation/screens/search_screen.dart';
import 'package:ezeness/presentation/screens/select_app_country_screen.dart';
import 'package:ezeness/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/post_list_view_load_more_body.dart';
import '../../data/repositories/explore_repository.dart';
import '../../data/repositories/upgrade_store_repository.dart';
import '../../data/repositories/upgrade_username_repository.dart';
import '../../logic/cubit/block_user/block_user_cubit.dart';
import '../../logic/cubit/blocked_users/blocked_users_cubit.dart';
import '../../logic/cubit/bookmark_post/bookmark_post_cubit.dart';
import '../../logic/cubit/bookmark_user/bookmark_user_cubit.dart';
import '../../logic/cubit/category_post/category_post_cubit.dart';
import '../../logic/cubit/comment/comment_cubit.dart';
import '../../logic/cubit/delete_post/delete_post_cubit.dart';
import '../../logic/cubit/explore_post/explore_post_cubit.dart';
import '../../logic/cubit/explore_users/explore_users_cubit.dart';
import '../../logic/cubit/like_post/like_post_cubit.dart';
import '../../logic/cubit/my_post/my_post_cubit.dart';
import '../../logic/cubit/post_comment/post_comment_cubit.dart';
import '../../logic/cubit/report/report_cubit.dart';
import '../../logic/cubit/subscribe_user_notification/subscribe_user_notification_cubit.dart';
import '../../logic/cubit/upgrade_store/upgrade_store_cubit.dart';
import '../../logic/cubit/upgrade_username/upgrade_username_cubit.dart';
import '../../logic/cubit/user_post/user_post_cubit.dart';
import '../screens/ads_boost/banner/banner_boost_preview_screen.dart';
import '../screens/panel/shopping_cart_screen.dart';
import '../screens/panel/wallet_screen/wallet_screen.dart';
import '../screens/playlist/playlist_screen.dart';
import '../screens/profile/add_edit_post/add_edit_post_screen.dart';
import '../screens/profile/blocked_user_screen.dart';
import '../utils/slide_route_transition.dart';

class AppRouter {
  late final ApiClient apiClient;
  late final AppConfigRepository appConfigRepository;

  AppRouter({required this.apiClient, required this.appConfigRepository});

  static late List<GlobalKey<NavigatorState>> navigatorKeysBottomNav;
  static void popInSubNavigator(int selectedTab) {
    if (navigatorKeysBottomNav[selectedTab].currentState!.canPop()) {
      navigatorKeysBottomNav[selectedTab].currentState!.pop();
    }
  }

  static late BuildContext mainContext;
  Route generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '/';

    final routeArguments = settings.arguments;

    switch (routeName) {
      case '/':
        return _buildInitialRoute(routeArguments);
      case HomeScreen.routName:
        return _buildHomeScreenRoute(routeArguments);
      case SplashScreen.routName:
        return _buildSplashScreenRoute(routeArguments);
      case AuthScreen.routName:
        return _buildAuthScreenRoute(routeArguments);
      case OnboardingScreen.routName:
        return _buildOnboardingScreenRoute(routeArguments);
      case DiscoverScreen.routName:
        return _buildDiscoverScreenRoute(routeArguments);
      case ExploreScreen.routName:
        return _buildExploreScreenRoute(routeArguments);
      case PanelScreen.routName:
        return _buildPanelScreenRoute(routeArguments);
      case NewPanelScreen.routName:
        return _buildNewPanelScreenRoute(routeArguments);
      case ProfileScreen.routName:
        return _buildProfileScreenRoute(routeArguments);
      case NotificationByTypeScreen.routName:
        return _buildNotificationScreenRoute(routeArguments);
      case SignUpScreen.routName:
        return _buildSignUpScreenRoute(routeArguments);
      case SignInScreen.routName:
        return _buildSignInScreenRoute(routeArguments);
      case AddEditPostScreen.routName:
        return _buildAddEditPostScreenRoute(routeArguments);
      case StoreUpgradeScreen.routName:
        return _buildStoreUpgradeScreenRoute(routeArguments);
      case UserNameUpgradeScreen.routName:
        return _buildUserNameUpgradeScreenRoute(routeArguments);
      case PostDetailsScreen.routName:
        return _buildPostDetailsScreenRoute(routeArguments);
      case PostViewScreen.routName:
        return _buildPostViewScreenRoute(routeArguments);
      case PostListViewScreen.routName:
        return _buildPostListViewScreenRoute(routeArguments);
      case CategoryScreen.routName:
        return _buildCategoryScreenRoute(routeArguments);
      case ShoppingCartScreen.routName:
        return _buildShoppingCartScreenRoute(routeArguments);
      case WalletScreen.routName:
        return _buildWalletScreenRoute(routeArguments);
      case EditProfileScreen.routName:
        return _buildEditProfileScreenRoute(routeArguments);
      case FollowersScreen.routName:
        return _buildFollowersScreenRoute(routeArguments);
      case CheckoutScreen.routName:
        return _buildCheckoutScreenRoute(routeArguments);
      case SearchScreen.routName:
        return _buildSearchScreenRoute(routeArguments);
      case UserReviewsScreen.routName:
        return _buildUserReviewsScreenRoute(routeArguments);
      case ResetPasswordScreen.routName:
        return _buildResetPasswordScreenRoute(routeArguments);
      case BlockedUserScreen.routName:
        return _buildBlockedUserScreenRoute(routeArguments);
      case HashtagPostScreen.routName:
        return _buildHashtagPostScreenRoute(routeArguments);
      case PrivacyPolicyScreen.routName:
        return _buildPrivacyPolicyScreenRoute(routeArguments);
      case TermOfUseScreen.routName:
        return _buildTermOfUseScreenRoute(routeArguments);
      case AboutScreen.routName:
        return _buildAboutScreenRoute(routeArguments);
      case BookmarkScreen.routName:
        return _buildBookmarkScreenRoute(routeArguments);
      case MenuScreen.routName:
        return _buildMenuScreenRoute(routeArguments);
      case PlaylistScreen.routName:
        return _buildPlaylistScreenRoute(routeArguments);
      case GoldCoinsDashboardScreen.routName:
        return _buildGoldCoinsDashboardScreen(routeArguments);

      case GoldCoinsDetailsScreen.routName:
        return _buildGoldCoinsDetailsScreen(routeArguments);

      case CalculateConvertCoinScreen.routName:
        return _buildCalculateCoinScreen(routeArguments);

      case CoinsConversionScreen.routName:
        return _buildCoinsConversionScree(routeArguments);

      case BuyCoinsScreen.routName:
        return _buildBuyGoldScreen(routeArguments);
      case SettingScreen.routName:
        return _buildSettingScreenRoute(routeArguments);
      case SelectCategoryScreen.routName:
        return _buildSelectCategoryScreenRoute(routeArguments);

      case SelectPostToAddBoostScreen.routName:
        return _buildSelectPostToAddBoostScreenRoute(routeArguments);

      case BannerPlansScreen.routName:
        return _buildBannerPlansScreenRoute(routeArguments);

      case PostPlansScreen.routName:
        return _buildPostPlansScreenRoute(routeArguments);

      case BannerBoostPreviewScreen.routName:
        return _buildBannerBoostPreviewScreenRoute(routeArguments);

      case BannerBoostTermsScreen.routName:
        return _buildBannerBoostTermsScreenRoute(routeArguments);

      case PostBoostTermsScreen.routName:
        return _buildPostBoostTermsScreenRoute(routeArguments);

      case BannerBoostPaymentScreen.routName:
        return _buildBannerBoostPaymentScreenRoute(routeArguments);

      case PostBoostPaymentScreen.routName:
        return _buildPostBoostPaymentScreenRoute(routeArguments);

      case InviteUsersScreen.routName:
        return _buildInviteUsersScreenRoute(routeArguments);

      case ProInvitesListScreen.routName:
        return _buildProInvitesListScreenRoute(routeArguments);
      case AddProInviteScreen.routName:
        return _buildAddProInviteScreenRoute(routeArguments);

      case ViewInviteScreen.routName:
        return _buildViewProInviteScreenRoute(routeArguments);

      case SpecialInvitesListScreen.routName:
        return _buildSpecialInvitesListScreenRoute(routeArguments);

      case AddSpecialInviteScreen.routName:
        return _buildAddSpecialInviteScreenRoute(routeArguments);

      case StanderInvitesListScreen.routName:
        return _buildStanderInvitesListScreenRoute(routeArguments);

      case AddStanderInviteScreen.routName:
        return _buildAddStanderInviteScreenRoute(routeArguments);

      case ActivityScreen.routName:
        return _buildActivityScreenScreenRoute(routeArguments);
      case FilterScreen.routName:
        return _buildFilterScreenScreenRoute(routeArguments);
      case ExploreSectionPostScreen.routName:
        return _buildExploreSectionPostScreenRoute(routeArguments);
      case ExploreUsersScreen.routName:
        return _buildExploreUsersScreenRoute(routeArguments);
      case GetUserLocationScreen.routName:
        return _buildGetUserLocationScreenRoute(routeArguments);
      case SelectAppCountryScreen.routName:
        return _buildSelectAppCountryScreenRoute(routeArguments);

      case EditBioScreen.routName:
        return _buildEditBioScreenScreenRoute(routeArguments);

      case EditUsernameScreen.routName:
        return _buildEditUsernameScreenRoute(routeArguments);

      case PrivacySecurityScreen.routName:
        return _buildPrivacySecurityScreenRoute(routeArguments);

      case CreateChangePasswordScreen.routName:
        return _buildCreateChangePasswordScreenRoute(routeArguments);

      default:
        return _buildInitialRoute(routeArguments);
    }
  }

  Route _buildInitialRoute(args) => _buildSplashScreenRoute(args);
  Route _buildHomeScreenRoute(args) => SlideRouteTransition(
        HomeScreen(
          apiClient,
          this,
        ),
      );
  Route _buildSplashScreenRoute(args) => SlideRouteTransition(SplashScreen());
  Route _buildSignUpScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>(
                create: (_) => ProfileCubit(ProfileRepository(apiClient)),
              ),
            ],
            child:
                SignUpScreen(initialUser: args == null ? null : args["user"])),
      );
  Route _buildSignInScreenRoute(args) => SlideRouteTransition(
        const SignInScreen(),
      );
  Route _buildAuthScreenRoute(args) => SlideRouteTransition(
        const AuthScreen(),
      );
  Route _buildResetPasswordScreenRoute(args) => SlideRouteTransition(
        const ResetPasswordScreen(),
      );
  Route _buildExploreScreenRoute(args) => SlideRouteTransition(
        const ExploreScreen(),
      );
  Route _buildDiscoverScreenRoute(args) => SlideRouteTransition(
        const DiscoverScreen(),
      );
  Route _buildOnboardingScreenRoute(args) => SlideRouteTransition(
        const OnboardingScreen(),
      );
  Route _buildPanelScreenRoute(args) => SlideRouteTransition(
        const PanelScreen(),
      );
  Route _buildNewPanelScreenRoute(args) => SlideRouteTransition(
        NewPanelScreen(),
      );
  Route _buildNotificationScreenRoute(args) => SlideRouteTransition(
        BlocProvider(
          create: (context) =>
              NotificationByTypeCubit(NotificationRepository(apiClient)),
          child: NotificationByTypeScreen(
            withBack: args['withBack'],
            type: args['type'],
          ),
        ),
      );
  Route _buildAddEditPostScreenRoute(args) {
    print("posts ${args == null ? null : args["post"]}");
    print("shared files ${args == null ? null : args["sharedFiles"]}");
    return SlideRouteTransition(
      MultiBlocProvider(
          providers: [
            BlocProvider<CategoryCubit>(
              create: (_) => CategoryCubit(CategoryRepository(apiClient)),
            ),
            BlocProvider<PostCubit>(
              create: (_) => PostCubit(PostRepository(apiClient)),
            ),
            BlocProvider<ProfileCubit>(
              create: (_) => ProfileCubit(ProfileRepository(apiClient)),
            ),
          ],
          child: AddEditPostScreen(
              post: args == null ? null : args["post"],
              sharedFiles: args == null ? null : args["sharedFiles"])),
    );
  }

  Route _buildStoreUpgradeScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<UpgradeStoreCubit>(
            create: (_) => UpgradeStoreCubit(UpgradeStoreRepository(apiClient)),
          ),
          BlocProvider<PaymentCubit>(
            create: (_) => PaymentCubit(PaymentRepository(apiClient)),
          ),
        ], child: StoreUpgradeScreen(args: args)),
      );
  Route _buildUserNameUpgradeScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<UpgradeUserNameCubit>(
            create: (_) =>
                UpgradeUserNameCubit(UpgradeUserNameRepository(apiClient)),
          ),
          BlocProvider<PaymentCubit>(
            create: (_) => PaymentCubit(PaymentRepository(apiClient)),
          ),
        ], child: UserNameUpgradeScreen(args: args)),
      );
  Route _buildPlaylistScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<PlaylistPostCubit>(
            create: (_) => PlaylistPostCubit(PostRepository(apiClient)),
          ),
        ], child: PlaylistScreen(args: args)),
      );
  Route _buildProfileScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
            providers: [
              BlocProvider<MyPostCubit>(
                create: (_) => MyPostCubit(PostRepository(apiClient)),
              ),
              BlocProvider<UserPostCubit>(
                create: (_) => UserPostCubit(PostRepository(apiClient)),
              ),
              BlocProvider<ProfileCubit>(
                create: (_) => ProfileCubit(ProfileRepository(apiClient)),
              ),
              BlocProvider<BookmarkUserCubit>(
                create: (_) => BookmarkUserCubit(ProfileRepository(apiClient)),
              ),
              BlocProvider<SubscribeUserNotificationCubit>(
                create: (_) => SubscribeUserNotificationCubit(
                    ProfileRepository(apiClient)),
              ),
              BlocProvider<BlockUserCubit>(
                create: (_) => BlockUserCubit(ProfileRepository(apiClient)),
              ),
            ],
            child: ProfileScreen(
                isOther: args != null ? args["isOther"] as bool : false,
                user: args != null ? args["user"] as User? : null)),
      );

  Route _buildPostDetailsScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<BookmarkPostCubit>(
            create: (_) => BookmarkPostCubit(PostRepository(apiClient)),
          ),
          BlocProvider<CommentCubit>(
            create: (_) => CommentCubit(PostRepository(apiClient)),
          ),
          BlocProvider<PostCommentCubit>(
            create: (_) => PostCommentCubit(PostRepository(apiClient)),
          ),
          BlocProvider<SubscribeUserNotificationCubit>(
            create: (_) =>
                SubscribeUserNotificationCubit(ProfileRepository(apiClient)),
          ),
          BlocProvider<BlockUserCubit>(
            create: (_) => BlockUserCubit(ProfileRepository(apiClient)),
          ),
          BlocProvider<DeletePostCubit>(
            create: (_) => DeletePostCubit(PostRepository(apiClient)),
          ),
          BlocProvider<ReportCubit>(
            create: (_) => ReportCubit(PostRepository(apiClient)),
          ),
          BlocProvider<PostCubit>(
            create: (_) => PostCubit(PostRepository(apiClient)),
          ),
        ], child: PostDetailsScreen(post: args["post"] as Post)),
      );

  Route _buildPostViewScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<PostCubit>(
            create: (_) => PostCubit(PostRepository(apiClient)),
          ),
          BlocProvider<LikePostCubit>(
            create: (_) => LikePostCubit(PostRepository(apiClient)),
          ),
          BlocProvider<BookmarkPostCubit>(
            create: (_) => BookmarkPostCubit(PostRepository(apiClient)),
          ),
          BlocProvider<CommentCubit>(
            create: (_) => CommentCubit(PostRepository(apiClient)),
          ),
          BlocProvider<PostCommentCubit>(
            create: (_) => PostCommentCubit(PostRepository(apiClient)),
          ),
          BlocProvider<SubscribeUserNotificationCubit>(
            create: (_) =>
                SubscribeUserNotificationCubit(ProfileRepository(apiClient)),
          ),
          BlocProvider<BlockUserCubit>(
            create: (_) => BlockUserCubit(ProfileRepository(apiClient)),
          ),
          BlocProvider<DeletePostCubit>(
            create: (_) => DeletePostCubit(PostRepository(apiClient)),
          ),
          BlocProvider<ReportCubit>(
            create: (_) => ReportCubit(PostRepository(apiClient)),
          ),
          BlocProvider<PlayListCubit>(
            create: (_) => PlayListCubit(PlayListRepository(apiClient)),
          ),
          BlocProvider<LiftUpPostCubit>(
            create: (_) => LiftUpPostCubit(PostRepository(apiClient)),
          ),
        ], child: PostViewScreen(post: args["post"] as Post)),
      );
  Route _buildPostListViewScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
            providers: [
              BlocProvider<PostCubit>(
                create: (_) => PostCubit(PostRepository(apiClient)),
              ),
              BlocProvider<LikePostCubit>(
                create: (_) => LikePostCubit(PostRepository(apiClient)),
              ),
              BlocProvider<BookmarkPostCubit>(
                create: (_) => BookmarkPostCubit(PostRepository(apiClient)),
              ),
              BlocProvider<CommentCubit>(
                create: (_) => CommentCubit(PostRepository(apiClient)),
              ),
              BlocProvider<PostCommentCubit>(
                create: (_) => PostCommentCubit(PostRepository(apiClient)),
              ),
              BlocProvider<SubscribeUserNotificationCubit>(
                create: (_) => SubscribeUserNotificationCubit(
                    ProfileRepository(apiClient)),
              ),
              BlocProvider<BlockUserCubit>(
                create: (_) => BlockUserCubit(ProfileRepository(apiClient)),
              ),
              BlocProvider<DeletePostCubit>(
                create: (_) => DeletePostCubit(PostRepository(apiClient)),
              ),
              BlocProvider<PlayListCubit>(
                create: (_) => PlayListCubit(PlayListRepository(apiClient)),
              ),
              BlocProvider<ReportCubit>(
                create: (_) => ReportCubit(PostRepository(apiClient)),
              ),
              BlocProvider<LiftUpPostCubit>(
                create: (_) => LiftUpPostCubit(PostRepository(apiClient)),
              ),
            ],
            child: PostListViewScreen(
                postList: args["postList"] as List<Post>,
                index: args["index"] as int,
                postListViewLoadMoreBody: args["postListViewLoadMoreBody"]
                    as PostListViewLoadMoreBody?)),
      );
  Route _buildCategoryScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<CategoryCubit>(
            create: (_) => CategoryCubit(CategoryRepository(apiClient)),
          ),
          BlocProvider<CategoryPostCubit>(
            create: (_) => CategoryPostCubit(PostRepository(apiClient)),
          ),
        ], child: CategoryScreen(args: args)),
      );
  Route _buildSelectCategoryScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<CategoryCubit>(
            create: (_) => CategoryCubit(CategoryRepository(apiClient)),
          ),
        ], child: SelectCategoryScreen(args: args)),
      );
  Route _buildShoppingCartScreenRoute(args) => SlideRouteTransition(
        ShoppingCartScreen(args: args),
      );
  Route _buildWalletScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<PaymentCubit>(
            create: (_) => PaymentCubit(PaymentRepository(apiClient)),
          ),
          BlocProvider<ProfileCubit>(
            create: (_) => ProfileCubit(ProfileRepository(apiClient)),
          ),
        ], child: WalletScreen(args: args)),
      );
  Route _buildEditProfileScreenRoute(args) => SlideRouteTransition(
        const EditProfileScreen(),
      );
  Route _buildFollowersScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<FollowersCubit>(
            create: (_) => FollowersCubit(FollowingRepository(apiClient)),
          ),
        ], child: FollowersScreen(user: args["user"] as User)),
      );

  Route _buildCheckoutScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
            providers: [
              BlocProvider<PaymentCubit>(
                create: (_) => PaymentCubit(PaymentRepository(apiClient)),
              ),
            ],
            child:
                CheckoutScreen(cartList: args["cartList"] as List<CartModel>)),
      );

  Route _buildSearchScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<SearchCubit>(
            create: (_) => SearchCubit(SearchRepository(apiClient)),
          ),
        ], child: const SearchScreen()),
      );
  Route _buildUserReviewsScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<UserReviewsCubit>(
            create: (_) => UserReviewsCubit(ProfileRepository(apiClient)),
          ),
          BlocProvider<ReviewsCubit>(
            create: (_) => ReviewsCubit(ProfileRepository(apiClient)),
          ),
        ], child: UserReviewsScreen(user: args["user"] as User)),
      );
  Route _buildBlockedUserScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<BlockUserCubit>(
            create: (_) => BlockUserCubit(ProfileRepository(apiClient)),
          ),
          BlocProvider<BlockedUsersCubit>(
            create: (_) => BlockedUsersCubit(ProfileRepository(apiClient)),
          ),
        ], child: const BlockedUserScreen()),
      );

  Route _buildHashtagPostScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<PostCubit>(
            create: (_) => PostCubit(PostRepository(apiClient)),
          ),
        ], child: HashtagPostScreen(hashtag: args["hashtag"] as PostHashtag)),
      );
  Route _buildAboutScreenRoute(args) => SlideRouteTransition(
        const AboutScreen(),
      );
  Route _buildPrivacyPolicyScreenRoute(args) => SlideRouteTransition(
        const PrivacyPolicyScreen(),
      );
  Route _buildTermOfUseScreenRoute(args) => SlideRouteTransition(
        const TermOfUseScreen(),
      );
  Route _buildBookmarkScreenRoute(args) => SlideRouteTransition(
        const BookmarkScreen(),
      );
  Route _buildMenuScreenRoute(args) => SlideRouteTransition(
        const MenuScreen(),
      );

  Route _buildGoldCoinsDashboardScreen(args) =>
      SlideRouteTransition(const GoldCoinsDashboardScreen());

  Route _buildGoldCoinsDetailsScreen(args) =>
      SlideRouteTransition(const GoldCoinsDetailsScreen());

  Route _buildCalculateCoinScreen(args) =>
      SlideRouteTransition(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CalculateCoinCubit(
                GoldCoinRepository(apiClient, isTesting: true)),
          ),
          BlocProvider(
            create: (_) => ConvertCoinCubit(
                GoldCoinRepository(apiClient, isTesting: true)),
          ),
          BlocProvider(
            create: (_) =>
                ProfileCubit(ProfileRepository(apiClient, isTesting: true)),
          ),
        ],
        child: const CalculateConvertCoinScreen(),
      ));
  Route _buildCoinsConversionScree(args) =>
      SlideRouteTransition(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CalculateCoinCubit(
                GoldCoinRepository(apiClient, isTesting: true)),
          ),
          BlocProvider(
            create: (_) => ConvertCoinCubit(
                GoldCoinRepository(apiClient, isTesting: true)),
          ),
          BlocProvider(
            create: (_) =>
                ProfileCubit(ProfileRepository(apiClient, isTesting: true)),
          ),
        ],
        child: const CoinsConversionScreen(),
      ));
  Route _buildBuyGoldScreen(args) => SlideRouteTransition(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CalculateCoinCubit(
                GoldCoinRepository(apiClient, isTesting: true)),
          ),
          BlocProvider(
            create: (_) => ConvertCoinCubit(
                GoldCoinRepository(apiClient, isTesting: true)),
          ),
          BlocProvider(
            create: (_) =>
                ProfileCubit(ProfileRepository(apiClient, isTesting: true)),
          ),
        ],
        child: const BuyCoinsScreen(),
      ));

  Route _buildSettingScreenRoute(args) =>
      SlideRouteTransition(const SettingScreen());

  // Route _buildBoostPostScreenRoute(args) =>
  //     SlideRouteTransition(const _BoostPostScreen());

  Route _buildSelectPostToAddBoostScreenRoute(args) => SlideRouteTransition(
        BlocProvider<MyPostCubit>(
          create: (_) => MyPostCubit(PostRepository(apiClient)),
          child: SelectPostToAddBoostScreen(isBanner: args['isBanner'] as bool),
        ),
      );

  Route _buildBannerPlansScreenRoute(args) => SlideRouteTransition(
        BlocProvider(
          create: (context) => BannerPlansCubit(BoostRepository(apiClient)),
          child: BannerPlansScreen(
            post: args['post'],
          ),
        ),
      );

  Route _buildPostPlansScreenRoute(args) => SlideRouteTransition(
        BlocProvider(
          create: (context) => PostPlansCubit(BoostRepository(apiClient)),
          child: PostPlansScreen(
            post: args['post'],
          ),
        ),
      );

  Route _buildBannerBoostPreviewScreenRoute(args) => SlideRouteTransition(
        BannerBoostPreviewScreen(
          post: args['post'],
          plan: args['plan'],
        ),
      );

  Route _buildBannerBoostTermsScreenRoute(args) => SlideRouteTransition(
        BannerBoostTermsScreen(
          post: args['post'],
          plan: args['plan'],
          bannerFile: args['file'],
        ),
      );

  Route _buildPostBoostTermsScreenRoute(args) => SlideRouteTransition(
        PostBoostTermsScreen(
          post: args['post'],
          plan: args['plan'],
        ),
      );

  Route _buildBannerBoostPaymentScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AddBannerBoostCubit(BoostRepository(apiClient)),
            ),
            BlocProvider(
              create: (context) => PaymentCubit(PaymentRepository(apiClient)),
            ),
            BlocProvider(
              create: (_) => ProfileCubit(ProfileRepository(apiClient)),
            ),
          ],
          child: BannerBoostPaymentScreen(
            post: args['post'],
            plan: args['plan'],
            bannerFile: args['file'],
          ),
        ),
      );

  Route _buildPostBoostPaymentScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AddPostBoostCubit(BoostRepository(apiClient)),
            ),
            BlocProvider(
              create: (context) => PaymentCubit(PaymentRepository(apiClient)),
            ),
            BlocProvider(
              create: (_) => ProfileCubit(ProfileRepository(apiClient)),
            ),
          ],
          child: PostBoostPaymentScreen(
            post: args['post'],
            plan: args['plan'],
          ),
        ),
      );

  Route _buildInviteUsersScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider<InviteUserCubit>(
              create: (_) => InviteUserCubit(InviteUserRepository(apiClient)),
            ),
          ],
          child: const InviteUsersScreen(),
        ),
      );

  Route _buildProInvitesListScreenRoute(args) => SlideRouteTransition(
        BlocProvider(
          create: (context) =>
              ProInvitationsCubit(InviteUserRepository(apiClient)),
          child: const ProInvitesListScreen(),
        ),
      );

  Route _buildAddProInviteScreenRoute(args) => SlideRouteTransition(
        AddProInviteScreen(
          proInvitationsCubit: args['cubit'],
        ),
      );

  Route _buildViewProInviteScreenRoute(args) => SlideRouteTransition(
        ViewInviteScreen(
          inviteUser: args['invite'],
        ),
      );

  Route _buildSpecialInvitesListScreenRoute(args) => SlideRouteTransition(
        BlocProvider(
          create: (context) => InviteUserCubit(InviteUserRepository(apiClient)),
          child: const SpecialInvitesListScreen(),
        ),
      );

  Route _buildAddSpecialInviteScreenRoute(args) => SlideRouteTransition(
        AddSpecialInviteScreen(
          inviteUserCubit: args['cubit'],
        ),
      );

  Route _buildStanderInvitesListScreenRoute(args) => SlideRouteTransition(
        BlocProvider(
          create: (context) => InviteUserCubit(InviteUserRepository(apiClient)),
          child: const StanderInvitesListScreen(),
        ),
      );

  Route _buildAddStanderInviteScreenRoute(args) => SlideRouteTransition(
        AddStanderInviteScreen(
          inviteUserCubit: args['cubit'],
        ),
      );
  Route _buildActivityScreenScreenRoute(args) => SlideRouteTransition(
        ActivityScreen(),
      );

  Route _buildFilterScreenScreenRoute(args) => SlideRouteTransition(
        FilterScreen(),
      );
  Route _buildExploreSectionPostScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider<ExplorePostCubit>(
              create: (_) => ExplorePostCubit(PostRepository(apiClient)),
            ),
          ],
          child: ExploreSectionPostScreen(
              sectionKey: args['sectionKey'], tabType: args['tabType']),
        ),
      );

  Route _buildExploreUsersScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider<ExploreUsersCubit>(
              create: (_) => ExploreUsersCubit(ExploreRepository(apiClient)),
            ),
          ],
          child: const ExploreUsersScreen(),
        ),
      );

  Route _buildGetUserLocationScreenRoute(args) =>
      SlideRouteTransition(GetUserLocationScreen(
        isFilterLocation: args == null ? false : args["isFilterLocation"],
      ));

  Route _buildSelectAppCountryScreenRoute(args) =>
      SlideRouteTransition(const SelectAppCountryScreen());

  Route _buildEditBioScreenScreenRoute(args) =>
      SlideRouteTransition(EditBioScreen(
        controller: args['controller'],
      ));
  Route _buildPrivacySecurityScreenRoute(args) =>
      SlideRouteTransition(PrivacySecurityScreen());

  Route _buildCreateChangePasswordScreenRoute(args) =>
      SlideRouteTransition(MultiBlocProvider(providers: [
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepository(apiClient)),
        ),
      ], child: CreateChangePasswordScreen()));

  Route _buildEditUsernameScreenRoute(args) => SlideRouteTransition(
        MultiBlocProvider(providers: [
          BlocProvider<UpgradeUserNameCubit>(
            create: (_) =>
                UpgradeUserNameCubit(UpgradeUserNameRepository(apiClient)),
          ),
        ], child: EditUsernameScreen(controller: args['controller'])),
      );
}
