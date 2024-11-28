import 'package:country_code_picker/country_code_picker.dart';
import 'package:device_preview/device_preview.dart';
import 'package:ezeness/data/data_providers/api_client.dart';
import 'package:ezeness/data/repositories/Notification_repository.dart';
import 'package:ezeness/data/repositories/app_config_repository.dart';
import 'package:ezeness/data/repositories/auth_repository.dart';
import 'package:ezeness/data/repositories/cart_repository.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/cart/cart_cubit.dart';
import 'package:ezeness/logic/cubit/hashtag/hashtag_cubit.dart';
import 'package:ezeness/logic/cubit/hashtag_mentions_text_field/hashtag_mentions_text_field_cubit.dart';
import 'package:ezeness/logic/cubit/mention/mention_cubit.dart';
import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/auth/auth_screen.dart';
import 'package:ezeness/presentation/services/fcm_service.dart';
import 'package:ezeness/presentation/services/upload_notification.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ezeness/config/api_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'data/models/user/user.dart';
import 'data/repositories/following_repository.dart';
import 'logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import 'logic/cubit/follow_user/follow_user_cubit.dart';
import 'logic/cubit/loadMore/load_more_cubit.dart';
import 'logic/cubit/seen_notification/seen_notification_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Constants.stripePublishableKey;
  Stripe.merchantIdentifier = Constants.stripeMerchantIdentifierKey;
  await UploadNotification.initNotifications();
  // HttpOverrides.global =  MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final AppConfigRepository appConfigRepository = AppConfigRepository();
  await appConfigRepository.initializeApp();
  ApiClient apiClient = ApiClient(
      baseURL: ApiConfig.baseURL,
      languageCode: appConfigRepository.locale.languageCode,
      appConfigRepository: appConfigRepository);
  await apiClient.loadLoginResponse();
  await Firebase.initializeApp();
  FcmService(apiClient);

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => App(
  //       appConfigRepository: appConfigRepository,
  //       apiClient: apiClient,
  //     ), // Wrap your app
  //   ),
  // );

  runApp(
    App(
      appConfigRepository: appConfigRepository,
      apiClient: apiClient,
    ), // Wrap your app
  );
}

class App extends StatelessWidget {
  final AppConfigRepository appConfigRepository;
  final ApiClient apiClient;

  late final AppRouter router;

  App({Key? key, required this.apiClient, required this.appConfigRepository})
      : super(key: key) {
    router = AppRouter(
        apiClient: apiClient, appConfigRepository: appConfigRepository);
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppConfigCubit(appConfigRepository),
        ),
        BlocProvider(
          create: (_) => SessionControllerCubit(AuthRepository(apiClient)),
        ),
        BlocProvider(
          create: (_) => CartCubit(CartRepository(apiClient)),
        ),
        BlocProvider(
          create: (_) => NotificationCubit(NotificationRepository(apiClient)),
        ),
        BlocProvider(
          create: (_) => LoadMoreCubit(apiClient),
        ),
        BlocProvider(
          create: (_) => AddEditPostCubit(PostRepository(apiClient)),
        ),
        BlocProvider(
          create: (_) => HashtagMentionsTextFieldCubit(),
        ),
        BlocProvider(
          create: (_) => MentionCubit(ProfileRepository(apiClient)),
        ),
        BlocProvider(
          create: (_) => HashtagCubit(PostRepository(apiClient)),
        ),
        BlocProvider<SeenNotificationCubit>(
          create: (_) =>
              SeenNotificationCubit(NotificationRepository(apiClient)),
        ),
        BlocProvider<FollowUserCubit>(
          create: (_) => FollowUserCubit(FollowingRepository(apiClient)),
        ),
      ],
      child: Builder(
        builder: (ctx) {
          ctx.select<AppConfigCubit, String>((bloc) => bloc.state.languageCode);
          ctx.select<AppConfigCubit, User>((bloc) => bloc.state.user);
          User user = ctx.read<AppConfigCubit>().getUser();
          apiClient.setLanguageCode(appConfigRepository.locale.languageCode);
          AppColors.setColor(user.getUserThemeMode(context) == ThemeMode.dark);
          Styles.setFontFamily(appConfigRepository.locale.languageCode);
          return BlocBuilder<SessionControllerCubit, SessionControllerState>(
            buildWhen: (previous, current) =>
                current is SessionControllerSignedOut ||
                current is SessionControllerGoToSigInScreen,
            builder: (context, state) {
              return ScreenUtilInit(
                designSize: _getDesignSize(context),
                minTextAdapt: true,
                splitScreenMode: true,
                // Use builder only if you need to use library outside ScreenUtilInit context
                builder: (_, child) {
                  return MaterialApp(
                    title: 'Ezeness',
                    key: state.globalKey ?? GlobalKey(),
                    builder: DevicePreview.appBuilder,
                    theme: Styles.lightTheme,
                    darkTheme: Styles.darkTheme,
                    themeMode: user.getUserThemeMode(context),
                    debugShowCheckedModeBanner: false,
                    locale: appConfigRepository.locale,
                    localizationsDelegates: const [
                      S.delegate,
                      CountryLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    onGenerateRoute: router.generateRoute,
                    initialRoute: state is SessionControllerGoToSigInScreen
                        ? AuthScreen.routName
                        : "/",
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Size _getDesignSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 600) {
      return const Size(768, 1024);
    } else {
      return const Size(360, 690);
    }
  }
}
