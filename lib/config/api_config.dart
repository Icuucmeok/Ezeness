class ApiConfig {
  //static const String baseURL = 'https://dev.ezeness.com/api/V1';

  static const String baseURL = 'https://api.ezeness.com/api/V1';

  static const String appConfig = '/config';

  static const String login = '/auth/login';
  static const String socialLogin = '/auth/social-login';
  static const String sendCode = '/auth/send_code';
  static const String verifyCode = '/auth/verify_code';
  static const String signup = '/auth/signup';
  static const String userNameSuggestion = '/suggestions';
  static const String validateSignUpInfo = '/auth/validation-signup';
  static const String logout = '/auth/logout';
  static const String checkCode = '/auth/check_code';

  static const String myProfile = '/auth/my_profile';
  static const String editProfile = '/auth/edit_profile';
  static const String getUsers = '/user';

  static const String upgradeUserNamePlan = '/plan';
  static const String upgradeUserNameMySuggestion = '/plan/my_suggestion';
  static const String upgradeUserNameSubscribe = '/plan/subscribe';
  static const String upgradeUserNameEditUserName = '/plan/edit_subscribe';

  static const String upgradeStorePlan = '/store_type';
  static const String editStorePlan = '/store/edit_store_type';
  static const String upgradeToStorePlan = '/store/upgrad_to_store';
  static const String editStoreInfo = '/store/edit';

  static const String categories = '/category';
  static const String category = '/category';
  static const String bannerPlans = '/banner-plans';
  static const String postPlans = '/post-plans';

  static const String discover = '/post-discover';

  static const String post = '/post';
  static const String addPost = '/post';
  static const String uploadPostMedia = '/post';
  static const String updatePost = '/post';
  static const String postLikeUnlike = '/post';
  static const String postFavouriteUnFavourite = '/post';
  static const String myFavourite = '/favourite';
  static const String deletePost = '/post';
  static const String postLiftUpUnLiftUp = '/liftup/sync';
  static const String validatePost = '/post/validate';
  static const String postLiftUpUsers= '/liftup';

  static const String userPost = '/post-user';
    static const String myPost = '/profile/my-posts';

  static const String hashtag = '/hashtag';

  static const String getComments = '/comment';
  static const String addComment = '/comment';
  static const String deleteComment = '/comment';
  static const String likeUnLikeComment = '/comment-like';

  static const String increaseViews = '/post-seen';

  static const String getReviews = '/review';
  static const String addReview = '/review';
  static const String deleteReviews = '/review';

  static const String getInvitation = '/invitation';
  static const String getProInvitation = '/pro-invitations';
  static const String addInvite = '/invitation';
  static const String addProInvite = '/pro-invitations';
  static const String deleteInvite = '/invitation/';
  static const String toggleProInvitationStatus =
      '/pro-invitations/update-status/';
  static const String getInvitationCredit = '/invitation-all';
  static const String sendInvitation = '/invitation/get';

  static const String explore = '/post-explore';
  static const String postForYou = '/post-foryou';
  static const String postTrending = '/post-trending';
  static const String postLiftUp = '/post-liftup';
  static const String postBestSeller = '/post-bestSeller';
  static const String exploreUsers = '/user-connects';


  static const String userFollowUnFollow = '/follow';
  static const String userFavouriteUnFavourite = '/user';
  static const String followers = '/user';
  static const String userSubscribeUnSubscribeNotification = '/subscribe';

  static const String blockUnBlockUser = '/block';
  static const String getBlockUsers = '/block';

  static const String createPayment = '/payment';

  static const String search = '/search';

  static const String notifications = '/notification';
  static const String notificationsByType = '/notification/type';
  static const String seenNotifications = '/notification/seen';

  static const String sendResetPasswordCode = '/password/reset';
  static const String checkResetPasswordCode = '/password/check';
  static const String resetPassword = '/password/set';
  static const String createChangePassword = '/password/set-password';

  static const String deleteAccount = '/auth/delete';

  static const String reportPost = '/report';
  static const String playList = '/playlist';
  static const String playListPost = '/playlist';

  static const String calculateCoin = '/wallet/calculate';
  static const String convertCoin = '/wallet/charge-coin';

  static const String addBannerBoost = '/banner';
  static const String addPostBoost = '/boost-post';
}
