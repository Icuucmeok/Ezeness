import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ezeness/data/models/currency_model.dart';
import 'package:ezeness/data/models/post/add_post_body.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';
import 'package:ezeness/logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import 'package:ezeness/logic/cubit/loadMore/load_more_cubit.dart';
import 'package:ezeness/logic/cubit/post/post_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/presentation/screens/category/select_category_screen.dart';
import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/widgets/category_widget.dart';
import 'package:ezeness/presentation/widgets/edit_post_media_widget.dart';
import 'package:ezeness/presentation/widgets/mention_hashtag_text_field.dart';
import 'package:ezeness/presentation/widgets/post_horizontal_widget.dart';
import 'package:ezeness/presentation/widgets/post_widget.dart';
import 'package:ezeness/presentation/widgets/profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertagger/fluttertagger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/media_library.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../data/models/app_file.dart';
import '../../../../data/models/category/category.dart';
import '../../../../data/models/day_time.dart';
import '../../../../data/models/pagination_page.dart';
import '../../../../data/models/pick_location_model.dart';
import '../../../../data/models/post/post.dart';
import '../../../../data/models/post/post_list.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../router/app_router.dart';
import '../../../utils/helpers.dart';
import '../../../utils/text_input_formatter.dart';
import '../../../utils/text_input_validator.dart';
import '../../../widgets/common/common.dart';

class AddEditPostScreen extends StatefulWidget {
  final Post? post;
  final List<File>? sharedFiles;
  static const String routName = 'add_post_screen';
  const AddEditPostScreen({this.post, this.sharedFiles, Key? key})
      : super(key: key);

  @override
  State<AddEditPostScreen> createState() => _AddEditPostScreenState();
}

class _AddEditPostScreenState extends State<AddEditPostScreen> {
  PageController _pageController = PageController();
  final _postDetailsKeyForm = GlobalKey<FormState>();
  final _vipKeyForm = GlobalKey<FormState>();
  final _postDetails2KeyForm = GlobalKey<FormState>();
  final searchDeBouncer = DeBouncer();
  FlutterTaggerController captionController = FlutterTaggerController();
  TextEditingController priceController = TextEditingController();
  TextEditingController priceWithDiscountController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactNumberCountryCodeController =
      TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();
  TextEditingController isDeliveryController = TextEditingController();
  TextEditingController deliveryRangeController = TextEditingController();
  TextEditingController deliveryPriceController = TextEditingController();
  TextEditingController isVipController = TextEditingController();
  TextEditingController vipStockController = TextEditingController();
  List<MediaFile> mediaList = [];
  int postType = Constants.postUpKey;
  Category? category;
  Category? subCategory;
  Category? childCategory;

  List<Post> postTaggedPosts = [];
  List<User> postTaggedProfiles = [];

  List<CategoryOption> categoryOptionList = [];

  int stokeType = Constants.stockTypeAllTime;
  List<DayTime> scheduleStockTiming = List.from(AppData().dayList);
  bool locationError = false;
  GlobalKey<FormState> categoryFormKey = GlobalKey<FormState>();
  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  previousPage() async {
    if (_pageController.page?.toInt() == 0) {
      AppDialog.showConfirmationDialog(
        context: context,
        onConfirm: () {
          Navigator.pop(context);
        },
        message: S.current.youWillLosePostInfoThatYouEntered,
      );
    } else {
      await _pageController.animateToPage(
        _pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
  }

  checkLocationError() {
    if (pickLocation == null) {
      locationError = true;
    } else {
      locationError = false;
    }
    setState(() {});
  }

  late User user;
  late PostCubit _postCubit;
  late ProfileCubit _profileCubit;
  late AddEditPostCubit _addEditPostCubit;
  late LoadMoreCubit _loadMoreCubit;
  bool isBookUpShopUp = false;
  bool isCallUp = false;
  bool isEdit = false;
  PickLocationModel? pickLocation;
  CurrencyModel? currency;

  final NumberFormat formatter = NumberFormat("#,###,###,###.##");
  String _formatNumber(String input) {
    log(input);
    if (input.isEmpty) return '';
    if (input.contains('.')) {
      final beforeComma = num.parse(input.split('.').first);
      final afterComma =
          input.split('.').last; // Keep the decimal part as a String
      return "${formatter.format(beforeComma)}.$afterComma";
    } else {
      // Convert the input to a number before formatting
      final number = num.parse(input);
      return formatter.format(number);
    }
  }

  String get priceValue => priceController.text.replaceAll(",", '');

  List<AppFile> uploadFiles = [];
  late AddPostBody uploadBody;
  late Post tempPost;
  @override
  void initState() {
    _postCubit = context.read<PostCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _addEditPostCubit = context.read<AddEditPostCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    if (widget.post != null) {
      isEdit = true;
      _postCubit.getPost(widget.post!.id!);
    }
    user = context.read<AppConfigCubit>().getUser();
    if (user.contactNumber != null && contactNumberController.text.isEmpty) {
      contactNumberController.text = user.contactNumber!;
      contactNumberCountryCodeController.text = user.contactNumberCode!;
    }
    if (user.store != null) {
      //FIRST VERSION EDITS
      // isBookUpShopUp=user.store!.storePlan!.id==Constants.planSKey || user.store!.storePlan!.id==Constants.plan24Key;
      isCallUp = user.store != null;
    }
    if (pickLocation == null && user.lat != null) {
      pickLocation = PickLocationModel(
          lat: double.parse(user.lat!),
          lng: double.parse(user.lng!),
          location: user.address!);
    }
    super.initState();
  }

  bool isKidsChecked = false;
  bool isIslamicChecked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        previousPage();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<PostCubit, PostState>(
              bloc: _postCubit,
              listener: (context, state) {
                if (state is PostLoaded) {
                  tempPost = state.response;
                  isEdit = true;
                  _pageController = PageController(initialPage: 1);
                  if (tempPost.description != null) {
                    captionController.text = tempPost.description!;
                  }
                  postType = tempPost.postType!;
                  if (tempPost.additionalInfo != null) {
                    additionalInfoController.text = tempPost.additionalInfo!;
                  }
                  if (tempPost.discount != null && tempPost.discount != 0) {
                    discountController.text = tempPost.discount!.toString();
                    priceWithDiscountController.text =
                        tempPost.sellPrice.toString();
                  }
                  if (tempPost.contactNumber != null) {
                    contactNumberController.text = tempPost.contactNumber!;
                    contactNumberCountryCodeController.text =
                        tempPost.contactNumberCode!;
                  }
                  if (tempPost.price != null) {
                    priceController.text =
                        _formatNumber(tempPost.price!.toString());
                    currency = CurrencyModel(currency: tempPost.priceCurrency!);
                    stockController.text = tempPost.stockCount!.toString();
                    stokeType = tempPost.stockType!;
                  }
                  if (tempPost.vipStockCount != null) {
                    vipStockController.text = tempPost.vipStockCount.toString();
                  }
                  if (tempPost.postTaggedPosts != null) {
                    postTaggedPosts = tempPost.postTaggedPosts!;
                  }
                  if (tempPost.postTaggedProfiles != null) {
                    postTaggedProfiles = tempPost.postTaggedProfiles!;
                  }
                  if (tempPost.childCategory != null) {
                    childCategory = tempPost.childCategory!;
                    if (tempPost.subCategory != null)
                      subCategory = tempPost.subCategory!;
                    if (tempPost.category != null)
                      category = tempPost.category!;
                  }
                  if (tempPost.postCategoryOption != null) {
                    categoryOptionList = tempPost.postCategoryOption!;
                  }
                  if (tempPost.deliveryCharge != null &&
                      tempPost.deliveryCharge != 0) {
                    isDeliveryController.text = "true";
                    deliveryRangeController.text =
                        tempPost.deliveryRange.toString();
                    deliveryPriceController.text =
                        tempPost.deliveryCharge.toString();
                  }
                  if (tempPost.shifts != null) {
                    scheduleStockTiming = tempPost.shifts!;
                  }
                  if (tempPost.lat != null) {
                    pickLocation = PickLocationModel(
                      lat: double.parse(tempPost.lat!),
                      lng: double.parse(tempPost.lng!),
                      location: tempPost.address ?? "",
                    );
                  }
                  isVipController.text = tempPost.isVip == 1 ? "true" : "false";
                  isKidsChecked = tempPost.isKids == 1;
                  isIslamicChecked = tempPost.isIslam == 1;
                }
              },
              builder: (context, state) {
                if (state is PostLoading) {
                  return const CenteredCircularProgressIndicator();
                }
                if (state is PostFailure) {
                  return ErrorHandler(exception: state.exception)
                      .buildErrorWidget(
                          context: context,
                          retryCallback: () =>
                              _postCubit.getPost(widget.post!.id!));
                }
                return BlocListener<AddEditPostCubit, AddEditPostState>(
                  bloc: _addEditPostCubit,
                  listener: (context, state) {
                    if (state is ValidatePostDone) {
                      if (isEdit) {
                        _addEditPostCubit.updatePost(
                          body: uploadBody,
                          files: uploadFiles,
                          postId: widget.post!.id!,
                        );
                      } else {
                        _addEditPostCubit.addPost(
                          body: uploadBody,
                          files: uploadFiles,
                        );
                      }
                      Navigator.pop(context);
                    }
                    if (state is ValidatePostFailure) {
                      ErrorHandler(exception: state.exception)
                          .showErrorSnackBar(context: context);
                    }
                  },
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      // Media Lib
                      _buildMediaPage(context),
                      _buildPostDetailsPage(context),
                      _buildPostAdditionalInfoPage(context),
                      _buildProductDetailsPage(context),
                      _buildVipDetailsPage(context),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildMediaPage(BuildContext context) {
    return MediaLibrary(
      onPicked: (selectedList) {
        mediaList = selectedList!;
        nextPage();
        setState(() {});
      },
      backWidget: Text(S.current.back),
      nextWidget: Text(S.current.next),
      maxAssets: 10,
      editedImagesLength:
          isEdit ? tempPost.postMediaList!.length : widget.sharedFiles?.length,
      sharedFiles: widget.sharedFiles ?? [],
      nextButtonOnEdit: () {
        nextPage();
        if (isEdit) setState(() {});
      },
    );
  }

  Widget _buildPostDetailsPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Form(
                key: _postDetailsKeyForm,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 5.h),

                      // Media Selected
                      _buildSelectedMedia(context),
                      SizedBox(height: 5),

                      //caption
                      MentionHashtagTextField(
                        withButtons: true,
                        isUnderLineStyle: true,
                        controller: captionController,
                        label: "",
                        hintText: S.current.addCaptionAndHashtags,
                        validator: (val) =>
                            val == null ? S.current.requiredField : null,
                        minLine: 1,
                        maxLine: 10,
                        onChanged: () {
                          setState(() {});
                        },
                      ),

                      SizedBox(height: 20),

                      // Tag up posts
                      _buildTagUpPosts(context),
                      SizedBox(height: 20),

                      // Tag up Profiles
                      _buildTagUpProfile(context),
                      SizedBox(height: 20),

                      _buildPickUpLocation(
                        context,
                        onChange: (location) {
                          setState(() {
                            pickLocation = location;
                          });
                        },
                        isError: locationError,
                      ),
                      SizedBox(height: 20),
                      EditTextField(
                        controller: contactNumberController,
                        label: S.current.contactNumber,
                        isNumber: true,
                        maxLength: 12,
                        hintText: "XXX XXX XXXX",
                        withCountryCodePicker: true,
                        validator: (text) {
                          return TextInputValidator(minLength: 7, validators: [
                            InputValidator.minLength,
                            if (postType == Constants.callUpKey)
                              InputValidator.requiredField
                          ]).validate(text);
                        },
                        countryCodeController:
                            contactNumberCountryCodeController,
                      ),
                      SizedBox(height: 20),
                      _buildKidsContent(context),

                      SizedBox(height: 20),
                      _buildIslamicContent(context),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                postType = Constants.postUpKey;
                              });
                              addEditPostFunction();
                            },
                            child: Text(S.current.social.toUpperCase())),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: captionController.text.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      postType = Constants.callUpKey;
                                    });
                                    if (!_postDetailsKeyForm.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    nextPage();
                                  },
                            child: Text(S.current.callUp.toUpperCase())),
                      ),
                      Expanded(child: SizedBox()),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedMedia(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Media Selected",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              GestureDetector(
                onTap: previousPage,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    shape: BoxShape.circle,
                    boxShadow: [Helpers.boxShadow(context)],
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: AppColors.blackColor,
                      radius: 11,
                      child: Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              if (isEdit)
                ...tempPost.postMediaList!
                    .map((e) => EditPostMediaWidget(postMedia: e))
                    .toList(),
              ...mediaList
                  .map((e) => EditPostMediaWidget(mediaFile: e))
                  .toList(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTagUpPosts(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.liftUpPost,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              // add icon
              GestureDetector(
                onTap: () {
                  _postCubit.initial();
                  TextEditingController searchController =
                      TextEditingController();
                  PaginationPage tagUpPostPage = PaginationPage(currentPage: 2);
                  AppModalBottomSheet.showMainModalBottomSheet(
                    context: context,
                    isExpandable: true,
                    onScrollEnd: () {
                      if (_loadMoreCubit.state is! LoadMoreLoading) {
                        _loadMoreCubit.loadMoreSearchTagUpPost(tagUpPostPage,
                            withLiftUp: 0,
                            search: searchController.text,
                            isKids: isKidsChecked ? 1 : 0,
                            withIsKids: isKidsChecked);
                      }
                    },
                    scrollableContent: BlocBuilder<PostCubit, PostState>(
                        bloc: _postCubit,
                        builder: (context, state) {
                          if (state is PostListLoading) {
                            return const CenteredCircularProgressIndicator();
                          }
                          if (state is PostListLoaded) {
                            List<Post> list = state.response.postList!;
                            tagUpPostPage = PaginationPage(currentPage: 2);
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter bottomSheetSetState) {
                              return Column(
                                children: [
                                  ...list.map((e) {
                                    bool isExist = postTaggedPosts
                                            .firstWhereOrNull((element) =>
                                                e.id == element.id) !=
                                        null;
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child:
                                                PostHorizontalWidget(post: e),
                                          ),
                                          if (isExist)
                                            IconButton(
                                                onPressed: () {
                                                  postTaggedPosts.removeWhere(
                                                      (element) =>
                                                          e.id == element.id);
                                                  setState(() {});
                                                  bottomSheetSetState(() {});
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red)),
                                          if (!isExist)
                                            IconButton(
                                                onPressed: () {
                                                  postTaggedPosts.add(e);
                                                  setState(() {});
                                                  bottomSheetSetState(() {});
                                                },
                                                icon: Icon(Icons.add,
                                                    color: Colors.green)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                      bloc: _loadMoreCubit,
                                      listener: (context, state) {
                                        if (state is LoadMoreFailure) {
                                          ErrorHandler(
                                                  exception: state.exception)
                                              .handleError(context);
                                        }
                                        if (state
                                            is LoadMoreSearchTagUpPostLoaded) {
                                          PostList temp = state.list;
                                          if (temp.postList!.isNotEmpty) {
                                            tagUpPostPage.currentPage++;
                                            bottomSheetSetState(() {
                                              list.addAll(temp.postList!);
                                            });
                                          }
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is LoadMoreLoading) {
                                          return const CenteredCircularProgressIndicator();
                                        }
                                        return Container();
                                      }),
                                  const SizedBox(height: 5),
                                ],
                              );
                            });
                          }
                          if (state is PostListFailure) {
                            return ErrorHandler(exception: state.exception)
                                .buildErrorWidget(
                                    context: context,
                                    retryCallback: () {
                                      if (int.tryParse(
                                              searchController.text.trim()) !=
                                          null) {
                                        _postCubit.getPosts(
                                            withLiftUp: 0,
                                            postId: int.parse(
                                                searchController.text),
                                            isKids: isKidsChecked ? 1 : 0,
                                            withIsKids: isKidsChecked);
                                      } else {
                                        _postCubit.getPosts(
                                            withLiftUp: 0,
                                            search: searchController.text,
                                            isKids: isKidsChecked ? 1 : 0,
                                            withIsKids: isKidsChecked);
                                      }
                                    });
                          }
                          return Container();
                        }),
                    fixesContent: Container(
                      margin: EdgeInsets.all(20.w),
                      child: SearchEditTextField(
                        controller: searchController,
                        label: S.current.search,
                        onChange: (_) {
                          if (int.tryParse(searchController.text.trim()) !=
                              null) {
                            _postCubit.getPosts(
                                withLiftUp: 0,
                                postId: int.parse(searchController.text),
                                isKids: isKidsChecked ? 1 : 0,
                                withIsKids: isKidsChecked);
                          } else {
                            if (searchController.text.length >= 2) {
                              searchDeBouncer.run(1, () {
                                if (searchController.text.length >= 2)
                                  _postCubit.getPosts(
                                      withLiftUp: 0,
                                      search: searchController.text,
                                      isKids: isKidsChecked ? 1 : 0,
                                      withIsKids: isKidsChecked);
                              });
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    shape: BoxShape.circle,
                    boxShadow: [Helpers.boxShadow(context)],
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: AppColors.blackColor,
                      radius: 11,
                      child: Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Tag up selected post
          if (postTaggedPosts.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    postTaggedPosts.length,
                    (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: Helpers.getPostWidgetWidth(context),
                          child: PostWidget(
                              post: postTaggedPosts[index],
                              withDetails: false,
                              onTapRemove: () {
                                setState(() {
                                  postTaggedPosts.removeAt(index);
                                });
                              }),
                        )).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagUpProfile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.liftUpProfile,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  TextEditingController searchController =
                      TextEditingController();
                  PaginationPage tagUpProfilePage =
                      PaginationPage(currentPage: 2);
                  AppModalBottomSheet.showMainModalBottomSheet(
                    isExpandable: true,
                    context: context,
                    onScrollEnd: () {
                      if (_loadMoreCubit.state is! LoadMoreLoading) {
                        _loadMoreCubit.loadMoreSearchTagUpProfile(
                          tagUpProfilePage,
                          search: searchController.text,
                        );
                      }
                    },
                    fixesContent: Container(
                      margin: EdgeInsets.all(20.w),
                      child: SearchEditTextField(
                        controller: searchController,
                        label: S.current.search,
                        onChange: (_) {
                          if (searchController.text.length >= 2) {
                            searchDeBouncer.run(1, () {
                              if (searchController.text.length >= 2)
                                _profileCubit.getUsers(
                                    search: searchController.text);
                            });
                          }
                        },
                      ),
                    ),
                    scrollableContent: BlocBuilder<ProfileCubit, ProfileState>(
                        bloc: _profileCubit,
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return const CenteredCircularProgressIndicator();
                          }
                          if (state is ProfileListLoaded) {
                            tagUpProfilePage = PaginationPage(currentPage: 2);
                            List<User> list = state.response.userList!;
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter bottomSheetSetState) {
                              return Column(
                                children: [
                                  ...list.map((e) {
                                    bool isExist = postTaggedProfiles
                                            .firstWhereOrNull((element) =>
                                                e.id == element.id) !=
                                        null;
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ProfileWidget(user: e),
                                          if (isExist)
                                            IconButton(
                                              onPressed: () {
                                                postTaggedProfiles.removeWhere(
                                                    (element) =>
                                                        e.id == element.id);
                                                setState(() {});
                                                bottomSheetSetState(() {});
                                              },
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                            ),
                                          if (!isExist)
                                            IconButton(
                                              onPressed: () {
                                                postTaggedProfiles.add(e);
                                                setState(() {});
                                                bottomSheetSetState(() {});
                                              },
                                              icon: Icon(Icons.add,
                                                  color: Colors.green),
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                      bloc: _loadMoreCubit,
                                      listener: (context, state) {
                                        if (state is LoadMoreFailure) {
                                          ErrorHandler(
                                                  exception: state.exception)
                                              .handleError(context);
                                        }
                                        if (state
                                            is LoadMoreSearchTagUpProfileLoaded) {
                                          UserList temp = state.list;
                                          if (temp.userList!.isNotEmpty) {
                                            tagUpProfilePage.currentPage++;
                                            bottomSheetSetState(() {
                                              list.addAll(temp.userList!);
                                            });
                                          }
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is LoadMoreLoading) {
                                          return const CenteredCircularProgressIndicator();
                                        }
                                        return Container();
                                      }),
                                  const SizedBox(height: 5),
                                ],
                              );
                            });
                          }
                          if (state is ProfileFailure) {
                            return ErrorHandler(exception: state.exception)
                                .buildErrorWidget(
                                    context: context,
                                    retryCallback: () => _profileCubit.getUsers(
                                        search: searchController.text));
                          }
                          return Container();
                        }),
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    shape: BoxShape.circle,
                    boxShadow: [Helpers.boxShadow(context)],
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: AppColors.blackColor,
                      radius: 11,
                      child: Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              )
              // GestureDetector(onTap: () {

              // }),
            ],
          ),
          SizedBox(height: 10),
          // Profiles
          if (postTaggedProfiles.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  postTaggedProfiles.length,
                  (index) => ProfileWidget(
                    user: postTaggedProfiles[index],
                    onTapRemove: () {
                      setState(() {
                        postTaggedProfiles.removeAt(index);
                      });
                    },
                  ),
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPickUpLocation(BuildContext context,
      {required Function(PickLocationModel?)? onChange,
      required bool isError}) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkColor
              : AppColors.grey,
          borderRadius: BorderRadius.circular(10.r),
          border: isError ? Border.all(color: Colors.red) : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            S.current.location,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 25),
          GestureDetector(
              onTap: () async {
                AppModalBottomSheet.showMainModalBottomSheet(
                    context: context,
                    height: 200,
                    scrollableContent: Column(
                      children: [
                        CustomElevatedButton(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: AppColors.primaryColor,
                          withBorderRadius: true,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            try {
                              AppDialog.showLoadingDialog(context: context);
                              Position location =
                                  await Helpers.getCurrentLocation(context);
                              String locationName =
                                  await Helpers.getAddressFromLatLng(location);
                              onChange?.call(PickLocationModel(
                                  lat: location.latitude,
                                  lng: location.longitude,
                                  location: locationName));

                              AppDialog.closeAppDialog();
                            } catch (_) {
                              AppDialog.closeAppDialog();
                            }
                          },
                          child: Text(S.current.useCurrentLocation,
                              style: TextStyle(color: Colors.white)),
                        ),
                        CustomElevatedButton(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          backgroundColor: AppColors.primaryColor,
                          withBorderRadius: true,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            bool serviceEnabled =
                                await Geolocator.isLocationServiceEnabled();
                            if (!serviceEnabled) {
                              AppSnackBar(
                                      context: context,
                                      onTap: () =>
                                          Geolocator.openLocationSettings())
                                  .showLocationServiceDisabledSnackBar();
                              return;
                            }
                            LocationPermission permission =
                                await Geolocator.checkPermission();
                            if (permission ==
                                    LocationPermission.deniedForever ||
                                permission == LocationPermission.denied) {
                              AppSnackBar(context: context)
                                  .showLocationPermanentlyDeniedSnackBar();
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Theme(
                                  data: ThemeData(brightness: Brightness.light),
                                  child: PlacePicker(
                                    apiKey: Constants.googleMapKey,
                                    onPlacePicked: (result) {
                                      onChange?.call(PickLocationModel(
                                          lat: result.geometry!.location.lat,
                                          lng: result.geometry!.location.lng,
                                          location: result.formattedAddress
                                              .toString()));
                                      Navigator.of(context).pop();
                                    },
                                    useCurrentLocation: true,
                                    resizeToAvoidBottomInset: false,
                                    initialPosition: LatLng(0, 0),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(S.current.selectFromMap,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ));
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: 89, start: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            S.current.tapToConnect,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            pickLocation?.location ?? S.current.locationIsOff,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: AppColors.green, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    end: 0,
                    top: -2.5,
                    child: Container(
                      width: 80,
                      height: 83,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Icon(Icons.location_on,
                              color: AppColors.whiteColor)),
                    ),
                  )
                ],
              ))
        ]));
  }

  Widget _buildKidsContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.current.postAsKidsContent,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (isKidsChecked) {
                setState(() {
                  isKidsChecked = !isKidsChecked;
                });
                category = null;
                subCategory = null;
                childCategory = null;
                return;
              }
              AppDialog.showConfirmationDialog(
                context: context,
                message: "${S.current.confirmKidsContent}",
                content: "${S.current.confirmSubmitForReview}",
                onConfirm: () {
                  setState(() {
                    isKidsChecked = !isKidsChecked;
                  });
                  category = null;
                  subCategory = null;
                  childCategory = null;
                },
              );
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: [Helpers.boxShadow(context)],
                color: isKidsChecked ? AppColors.green : AppColors.whiteColor,
              ),
              child: Center(
                child: !isKidsChecked
                    ? Icon(
                        Icons.add,
                        color: AppColors.blackColor,
                        size: 20,
                      )
                    : Icon(
                        Icons.check,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIslamicContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.current.postAsIslamicContent,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (isIslamicChecked) {
                setState(() {
                  isIslamicChecked = !isIslamicChecked;
                });
                return;
              }
              AppDialog.showConfirmationDialog(
                context: context,
                message: "${S.current.confirmIslamicContent}",
                content: "${S.current.confirmSubmitForReview}",
                onConfirm: () {
                  setState(() {
                    isIslamicChecked = !isIslamicChecked;
                  });
                },
              );
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: [Helpers.boxShadow(context)],
                color:
                    isIslamicChecked ? AppColors.green : AppColors.whiteColor,
              ),
              child: Center(
                child: !isIslamicChecked
                    ? Icon(
                        Icons.add,
                        color: AppColors.blackColor,
                        size: 20,
                      )
                    : Icon(
                        Icons.check,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPostAdditionalInfoPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              TextButton(
                  onPressed: () {
                    if (childCategory == null) {
                      AppSnackBar(
                              message: S.current.category +
                                  " " +
                                  S.current.requiredField,
                              context: context)
                          .showErrorSnackBar();
                      return;
                    }
                    bool isCategoryOptionError = false;
                    if (childCategory!.options != null)
                      for (CategoryOption o in childCategory!.options!) {
                        if (o.type == Constants.categoryOptionColorTypeKey) {
                          if (o.isRequired! && o.value == null) {
                            isCategoryOptionError = true;
                            o.isError = true;
                          } else {
                            o.isError = false;
                          }
                        }
                      }
                    if (!categoryFormKey.currentState!.validate() ||
                        isCategoryOptionError) {
                      setState(() {});
                      return;
                    }

                    categoryOptionList.clear();
                    if (childCategory!.options != null)
                      for (CategoryOption o in childCategory!.options!) {
                        if (o.type == Constants.categoryOptionColorTypeKey ||
                            o.type == Constants.categoryOptionArrayTypeKey) {
                          categoryOptionList.add(CategoryOption(
                            id: o.id,
                            value: o.value,
                          ));
                        }
                      }
                    categoryFormKey.currentState?.save();

                    nextPage();
                  },
                  child: Text(S.current.next)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Form(
              key: categoryFormKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ViewAllIconHeader(
                    leadingText: S.current.menu,
                    onNavigate: () {
                      Navigator.of(AppRouter.mainContext)
                          .pushNamed(SelectCategoryScreen.routName, arguments: {
                        "isForKids": isKidsChecked ? 1 : 0,
                      }).then((v) {
                        if (v != null) {
                          List<Category> selectedCategoryList =
                              v as List<Category>;
                          category = selectedCategoryList[0];
                          subCategory = selectedCategoryList[1];
                          childCategory = selectedCategoryList[2];
                          setState(() {});
                        }
                      });
                    },
                    icon: Icons.add_circle_outlined,
                  ),
                  const SizedBox(height: 6),
                  if (childCategory != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryWidget(onTap: () {}, category: category!),
                          CategoryWidget(onTap: () {}, category: subCategory!),
                          CategoryWidget(
                              onTap: () {}, category: childCategory!),
                        ],
                      ),
                    ),
                  SizedBox(height: 10.h),
                  if (childCategory != null &&
                      childCategory?.options != null &&
                      childCategory!.options!.isNotEmpty) ...{
                    Text(S.current.specifications),
                    ...childCategory!.options!.map((e) {
                      if (e.type == Constants.categoryOptionNumericTypeKey ||
                          e.type == Constants.categoryOptionStringTypeKey) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0.h),
                          child: TextFormField(
                            keyboardType:
                                e.type == Constants.categoryOptionNumericTypeKey
                                    ? TextInputType.number
                                    : null,
                            inputFormatters: [
                              if (e.type ==
                                  Constants.categoryOptionNumericTypeKey)
                                FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) {
                              categoryOptionList.add(CategoryOption(
                                id: e.id,
                                value: v,
                              ));
                            },
                            initialValue: categoryOptionList
                                    .firstWhereOrNull(
                                        (element) => element.id == e.id)
                                    ?.value ??
                                "",
                            maxLines: 1,
                            minLines: 1,
                            style: Theme.of(context).textTheme.bodyLarge,
                            cursorColor: AppColors.primaryColor,
                            validator: e.isRequired!
                                ? (value) {
                                    if (value != null && value.trim().isEmpty) {
                                      return S.current.requiredField;
                                    }
                                    return null;
                                  }
                                : null,
                            decoration: InputDecoration(
                                counterText: "",
                                label: Text(e.name.toString()),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 14.sp,
                                    ),
                                filled: true,
                                fillColor: Colors.transparent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: AppColors.textFieldBorderLight,
                                      width: 1.w),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: AppColors.textFieldBorderLight,
                                      width: 1.w),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        );
                      } else if (e.type ==
                          Constants.categoryOptionArrayTypeKey) {
                        if (isEdit && e.value == null)
                          e.value = categoryOptionList
                              .firstWhereOrNull((element) => element.id == e.id)
                              ?.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0.h),
                          child: AppDropDownButton<String>(
                            items: e.options!
                                .map((o) => DropdownMenuItem<String>(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            o.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          )),
                                      value: o,
                                    ))
                                .toList(),
                            hintText: e.name,
                            value: e.value,
                            validator: e.isRequired!
                                ? (value) {
                                    if (value == null)
                                      return S.current.requiredField;
                                    if (value.trim().isEmpty) {
                                      return S.current.requiredField;
                                    }
                                    return null;
                                  }
                                : null,
                            onChanged: (v) {
                              setState(() {
                                e.value = v;
                              });
                            },
                          ),
                        );
                      } else if (e.type ==
                          Constants.categoryOptionColorTypeKey) {
                        if (isEdit && e.value == null)
                          e.value = categoryOptionList
                              .firstWhereOrNull((element) => element.id == e.id)
                              ?.value;
                        return ColorPiker(
                          initialValue: e.value,
                          isError: e.isError,
                          isEmpty: !e.isRequired!,
                          title: e.name,
                          onTap: (color) {
                            setState(() {
                              e.value = color.toHexString();
                            });
                          },
                        );
                      }
                      return SizedBox();
                    }).toList(),
                  },
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.h),
                    child: EditTextField(
                        controller: additionalInfoController,
                        label: S.current.additionalInfo,
                        minLine: 3,
                        maxLine: 5,
                        isEmpty: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetailsPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              TextButton(
                  onPressed: () {
                    if (!_postDetails2KeyForm.currentState!.validate()) {
                      return;
                    }
                    bool allStoreTimingNull = true;
                    for (var e in scheduleStockTiming) {
                      if (e.fromTime != null || e.toTime != null) {
                        allStoreTimingNull = false;
                      }
                      if (e.fromTime != null && e.toTime == null) {
                        AppSnackBar(
                                message: S.current.youHaveToSelectTimeForDay(
                                    S.current.toTime, e.dayName!),
                                context: context)
                            .showErrorSnackBar();
                        return;
                      }
                      if (e.toTime != null && e.fromTime == null) {
                        AppSnackBar(
                                message: S.current.youHaveToSelectTimeForDay(
                                    S.current.fromTime, e.dayName!),
                                context: context)
                            .showErrorSnackBar();
                        return;
                      }
                    }
                    if (allStoreTimingNull &&
                        stokeType == Constants.stockTypeSchedule) {
                      AppSnackBar(
                              message: S
                                  .current.youHaveToSelectAtLeastOneWorkingTime,
                              context: context)
                          .showErrorSnackBar();
                      return;
                    }
                    nextPage();
                  },
                  child: Text(S.current.next)),
            ],
          ),
        ),
        Expanded(
          child: Form(
            key: _postDetails2KeyForm,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 10.h),
                  _buildSelectCurrency(context),
                  SizedBox(height: 10.h),
                  EditTextField(
                    controller: priceController,
                    label: S.current.price,
                    // isNumber: true,
                    // isDecimal: true,
                    onChanged: () {
                      priceController.text = _formatNumber(priceValue);

                      if (priceValue.isNotEmpty &&
                          discountController.text.isNotEmpty) {
                        double p = double.parse(priceValue);
                        double d = double.parse(discountController.text);
                        priceWithDiscountController.text =
                            (p - ((p * d) / 100)).toStringAsFixed(2);
                      }
                      if (priceValue.isEmpty) {
                        priceController.clear();
                        priceWithDiscountController.clear();
                      }
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10.h),
                  EditTextField(
                      controller: discountController,
                      label: S.current.discount,
                      isEmpty: true,
                      isNumber: true,
                      suffixWidget: Icon(Icons.percent),
                      onChanged: () {
                        if (priceValue.isNotEmpty &&
                            discountController.text.isNotEmpty) {
                          double p = double.parse(priceValue);
                          double d = double.parse(discountController.text);
                          priceWithDiscountController.text =
                              (p - ((p * d) / 100)).toStringAsFixed(2);
                        }
                        setState(() {});
                      },
                      inputFormatters: [
                        DiscountTextInputFormatter(),
                      ]),
                  SizedBox(height: 10.h),
                  if (discountController.text.isNotEmpty &&
                      priceValue.isNotEmpty) ...{
                    EditTextField(
                      controller: priceWithDiscountController,
                      label: S.current.priceAfterDiscount,
                      isNumber: true,
                      isDecimal: true,
                      onChanged: () {
                        if (priceWithDiscountController.text.isNotEmpty &&
                            priceValue.isNotEmpty) {
                          double p = double.parse(priceValue);
                          double pd =
                              double.parse(priceWithDiscountController.text);
                          discountController.text =
                              (((p - pd) / p) * 100).toStringAsFixed(2);
                        }
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10.h),
                  },
                  EditTextField(
                      controller: stockController,
                      label: S.current.stock,
                      isNumber: true),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.oneTimeStock,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                      ),
                      AppCheckBox(
                        onChange: () {
                          setState(() {
                            stokeType = Constants.stockTypeAllTime;
                            scheduleStockTiming = List.from(AppData().dayList);
                          });
                        },
                        value: stokeType == Constants.stockTypeAllTime,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.dailyStockSchedule,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                      ),
                      AppCheckBox(
                        onChange: () {
                          setState(() {
                            stokeType = Constants.stockTypeSchedule;
                          });
                        },
                        value: stokeType == Constants.stockTypeSchedule,
                      ),
                    ],
                  ),
                  if (stokeType == Constants.stockTypeSchedule)
                    SelectButton(
                        icon: CupertinoIcons.calendar,
                        title: S.current.dailyStockSchedule,
                        onTap: () => AppModalBottomSheet.showDayTimeBottomSheet(
                            context: context, dayList: scheduleStockTiming)),
                  SizedBox(height: 10.h),
                  BoolSelect(
                      controller: isDeliveryController,
                      title: S.current.delivery,
                      onChange: () => setState(() {})),
                  if (isDeliveryController.text == "true") ...{
                    EditTextField(
                        controller: deliveryRangeController,
                        label: S.current.deliveryRange,
                        isNumber: true,
                        suffixWidget: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("KM"),
                        )),
                    SizedBox(height: 10.h),
                    _buildSelectCurrency(context),
                    SizedBox(height: 10.h),
                    EditTextField(
                      controller: deliveryPriceController,
                      label: S.current.deliveryCharges,
                      isNumber: true,
                      isDecimal: true,
                    ),
                  },
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVipDetailsPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              _buildAddPostButton(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Form(
              key: _vipKeyForm,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  BoolSelect(
                      controller: isVipController,
                      title: S.current.vipItem,
                      onChange: () => setState(() {})),
                  if (isVipController.text == "true") ...{
                    EditTextField(
                        controller: vipStockController,
                        label: S.current.stock,
                        isNumber: true),
                    SizedBox(height: 10.h),
                    EditTextField(
                        controller: TextEditingController(text: "Free"),
                        label: S.current.price,
                        isReadOnly: true),
                    SizedBox(height: 10.h),
                    EditTextField(
                        controller: TextEditingController(text: "Free"),
                        isReadOnly: true,
                        label: S.current.deliveryCharges),
                  },
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPostButton() {
    return TextButton(
      onPressed: () {
        addEditPostFunction();
      },
      child: Text(isEdit ? S.current.save : S.current.publish),
    );
  }

  Future<void> addEditPostFunction() async {
    checkLocationError();
    if (postType != Constants.postUpKey) {
      if (!_vipKeyForm.currentState!.validate() || locationError) {
        return null;
      }
    }
    if (postType == Constants.postUpKey) {
      if (!_postDetailsKeyForm.currentState!.validate() || locationError) {
        return null;
      }
    }
    for (int i = 0; i < mediaList.length; i++) {
      final File originalFile = mediaList[i].getFile()!;
      final String fileExtension =
          originalFile.path.split('.').last.toLowerCase();

      File? compressedFile;

      if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
        compressedFile = await compressImage(originalFile);
      } else if (['mp4', 'mov', 'avi'].contains(fileExtension)) {
        compressedFile = await compressVideo(originalFile);
      } else {
        compressedFile =
            originalFile; // Skip compression for unsupported formats
      }

      uploadFiles
          .add(AppFile(file: compressedFile!, fileKey: AddPostBody.imageKey));
    }

    // for (int i = 0; i < mediaList.length; i++) {
    //   print(mediaList[i].getFile()!.readAsBytes());
    //   uploadFiles.add(AppFile(
    //       file: mediaList[i].getFile()!, fileKey: AddPostBody.imageKey));
    // }
    uploadBody = AddPostBody(
      description: captionController.text,
      additionalInfo: additionalInfoController.text,
      type: postType.toString(),
      categoryId: childCategory?.id.toString(),
      price: priceValue,
      priceCurrency: currency?.currency,
      discount: discountController.text,
      stockType: stokeType.toString(),
      stockCount: stockController.text,
      vipStockCount:
          vipStockController.text.isNotEmpty ? vipStockController.text : null,
      postTaggedPosts: postTaggedPosts,
      postTaggedProfiles: postTaggedProfiles,
      postStockTime:
          stokeType == Constants.stockTypeSchedule ? scheduleStockTiming : null,
      isIslamic: isIslamicChecked ? "1" : "0",
      isVip: isVipController.text == "true" ? "1" : "0",
      isKids: isKidsChecked ? "1" : "0",
      deliveryCharge: isDeliveryController.text == "true"
          ? deliveryPriceController.text
          : "0",
      deliveryRange: isDeliveryController.text == "true"
          ? deliveryRangeController.text
          : "0",
      deliveryChargeCurrency: currency?.currency,
      categoryOptionList: categoryOptionList,
      contactNumber: contactNumberController.text.isEmpty
          ? null
          : contactNumberController.text,
      contactNumberCode: contactNumberCountryCodeController.text,
      lat: pickLocation?.lat.toString(),
      lng: pickLocation?.lng.toString(),
      address: pickLocation?.location,
    );

    _addEditPostCubit.validatePost(uploadBody);
  }

  Future<File?> compressImage(File file) async {
    // print("original file size: ${await file.length()} bytes");

    final String targetPath =
        "${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, // Original file path
      targetPath, // Compressed file path
      quality: 70, // Compression quality (1-100, lower means more compression)
    );

    if (result != null) {
      // print("Compressed file size: ${await result.length()} bytes");
      return File(result.path);
    } else {
      print("Compression failed. Returning original file.");
      return file; // Return the original file if compression fails
    }
    // File res = File(result!.path);
    //
    // return res;
    // ?? file; // Return the compressed file or original if compression fails
  }

  Future<File> compressVideo(File file) async {
    // print("original video file size: ${await file.length()} bytes");
    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality, // Compression quality
      deleteOrigin: false, // Whether to delete the original file
    );

    if (info?.file != null) {
      File compressedFile = File(info!.file!.path);
      // print(
      //     "Compressed video file size: ${await compressedFile.length()} bytes");
      return compressedFile;
    } else {
      print("Compression failed. Returning original file.");
      return file;
    }
    // return File(info?.file?.path ??
    //     file.path); // Return compressed file or original if compression fails
  }

  DropdownSearch<CurrencyModel> _buildSelectCurrency(BuildContext context) {
    return DropdownSearch<CurrencyModel>(
      itemAsString: (item) =>
          Helpers.getCurrencyName(item.currency) +
          (item.countryName == null ? "" : " (${item.countryName})"),
      items: AppData.postCurrencyList,
      validator: (val) => val == null ? S.current.requiredField : null,
      onChanged: (value) {
        setState(() {
          currency = value;
        });
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: BorderRadius.circular(15)),
          disabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: BorderRadius.circular(15)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textFieldBorderLight),
            borderRadius: BorderRadius.circular(15),
          ),
          label: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 15.sp,
                  ),
              children: [
                TextSpan(text: "  ${S.current.currency} "),
              ],
            ),
          ),
          floatingLabelStyle: Theme.of(context).textTheme.bodyMedium,
          hintText: S.current.selectedCurrency,
          labelStyle: TextStyle(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        ),
      ),
      popupProps: PopupProps.menu(
          menuProps: MenuProps(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkColor
                : AppColors.grey,
          ),
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: S.current.search,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              filled: true,
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.red),
              border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.textFieldBorderLight),
                  borderRadius: BorderRadius.circular(7)),
              disabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.textFieldBorderLight),
                  borderRadius: BorderRadius.circular(7)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.textFieldBorderLight),
                  borderRadius: BorderRadius.circular(7)),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(7)),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.textFieldBorderLight),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          )),
      selectedItem: currency,
      enabled: true,
      compareFn: (CurrencyModel a, CurrencyModel b) =>
          a.currency == b.currency || a.countryName == b.countryName,
    );
  }
}











// import 'dart:developer';
// import 'dart:io';

// import 'package:collection/collection.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:ezeness/data/models/currency_model.dart';
// import 'package:ezeness/data/models/post/add_post_body.dart';
// import 'package:ezeness/data/models/user/user.dart';
// import 'package:ezeness/data/models/user/user_list.dart';
// import 'package:ezeness/logic/cubit/add_edit_post/add_edit_post_cubit.dart';
// import 'package:ezeness/logic/cubit/loadMore/load_more_cubit.dart';
// import 'package:ezeness/logic/cubit/post/post_cubit.dart';
// import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
// import 'package:ezeness/presentation/screens/category/select_category_screen.dart';
// import 'package:ezeness/presentation/utils/app_dialog.dart';
// import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
// import 'package:ezeness/presentation/utils/app_snackbar.dart';
// import 'package:ezeness/presentation/widgets/category_widget.dart';
// import 'package:ezeness/presentation/widgets/edit_post_media_widget.dart';
// import 'package:ezeness/presentation/widgets/mention_hashtag_text_field.dart';
// import 'package:ezeness/presentation/widgets/post_horizontal_widget.dart';
// import 'package:ezeness/presentation/widgets/post_widget.dart';
// import 'package:ezeness/presentation/widgets/profile_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertagger/fluttertagger.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:intl/intl.dart';
// // import 'package:media_library/core/entity/media_file.dart';
// // import 'package:media_library/media_library.dart';

// import '../../../../data/models/app_file.dart';
// import '../../../../data/models/category/category.dart';
// import '../../../../data/models/day_time.dart';
// import '../../../../data/models/pagination_page.dart';
// import '../../../../data/models/pick_location_model.dart';
// import '../../../../data/models/post/post.dart';
// import '../../../../data/models/post/post_list.dart';
// import '../../../../data/utils/error_handler.dart';
// import '../../../../generated/l10n.dart';
// import '../../../../logic/cubit/app_config/app_config_cubit.dart';
// import '../../../../pkg/media_library-main/lib/core/entity/media_file.dart';
// import '../../../../pkg/media_library-main/lib/media_library.dart';
// import '../../../../res/app_res.dart';
// import '../../../router/app_router.dart';
// import '../../../utils/helpers.dart';
// import '../../../utils/text_input_formatter.dart';
// import '../../../utils/text_input_validator.dart';
// import '../../../widgets/common/common.dart';

// class AddEditPostScreen extends StatefulWidget {
//   final Post? post;
//   final List<File>? sharedFiles;
//   static const String routName = 'add_post_screen';
//   const AddEditPostScreen({this.post, this.sharedFiles, Key? key})
//       : super(key: key);

//   @override
//   State<AddEditPostScreen> createState() => _AddEditPostScreenState();
// }

// class _AddEditPostScreenState extends State<AddEditPostScreen> {
//   PageController _pageController = PageController();
//   final _postDetailsKeyForm = GlobalKey<FormState>();
//   final _vipKeyForm = GlobalKey<FormState>();
//   final _postDetails2KeyForm = GlobalKey<FormState>();
//   final searchDeBouncer = DeBouncer();
//   FlutterTaggerController captionController = FlutterTaggerController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController priceWithDiscountController = TextEditingController();
//   TextEditingController discountController = TextEditingController();
//   TextEditingController stockController = TextEditingController();
//   TextEditingController contactNumberController = TextEditingController();
//   TextEditingController contactNumberCountryCodeController =
//       TextEditingController();
//   TextEditingController additionalInfoController = TextEditingController();
//   TextEditingController isDeliveryController = TextEditingController();
//   TextEditingController deliveryRangeController = TextEditingController();
//   TextEditingController deliveryPriceController = TextEditingController();
//   TextEditingController isVipController = TextEditingController();
//   TextEditingController vipStockController = TextEditingController();
//   List<MediaFile> mediaList = [];
//   int postType = Constants.postUpKey;
//   Category? category;
//   Category? subCategory;
//   Category? childCategory;

//   List<Post> postTaggedPosts = [];
//   List<User> postTaggedProfiles = [];

//   List<CategoryOption> categoryOptionList = [];

//   int stokeType = Constants.stockTypeAllTime;
//   List<DayTime> scheduleStockTiming = List.from(AppData().dayList);
//   bool locationError = false;
//   GlobalKey<FormState> categoryFormKey = GlobalKey<FormState>();
//   void nextPage() {
//     _pageController.animateToPage(_pageController.page!.toInt() + 1,
//         duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
//   }

//   previousPage() async {
//     if (_pageController.page?.toInt() == 0) {
//       AppDialog.showConfirmationDialog(
//         context: context,
//         onConfirm: () {
//           Navigator.pop(context);
//         },
//         message: S.current.youWillLosePostInfoThatYouEntered,
//       );
//     } else {
//       await _pageController.animateToPage(
//         _pageController.page!.toInt() - 1,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeIn,
//       );
//     }
//   }

//   checkLocationError() {
//     if (pickLocation == null) {
//       locationError = true;
//     } else {
//       locationError = false;
//     }
//     setState(() {});
//   }

//   late User user;
//   late PostCubit _postCubit;
//   late ProfileCubit _profileCubit;
//   late AddEditPostCubit _addEditPostCubit;
//   late LoadMoreCubit _loadMoreCubit;
//   bool isBookUpShopUp = false;
//   bool isCallUp = false;
//   bool isEdit = false;
//   PickLocationModel? pickLocation;
//   CurrencyModel? currency;

//   final NumberFormat formatter = NumberFormat("#,###,###,###.##");
//   String _formatNumber(String input) {
//     log(input);
//     if (input.isEmpty) return '';
//     if (input.contains('.')) {
//       final beforeComma = num.parse(input.split('.').first);
//       final afterComma =
//           input.split('.').last; // Keep the decimal part as a String
//       return "${formatter.format(beforeComma)}.$afterComma";
//     } else {
//       // Convert the input to a number before formatting
//       final number = num.parse(input);
//       return formatter.format(number);
//     }
//   }

//   String get priceValue => priceController.text.replaceAll(",", '');

//   List<AppFile> uploadFiles = [];
//   late AddPostBody uploadBody;
//   late Post tempPost;
//   @override
//   void initState() {
//     _postCubit = context.read<PostCubit>();
//     _profileCubit = context.read<ProfileCubit>();
//     _addEditPostCubit = context.read<AddEditPostCubit>();
//     _loadMoreCubit = context.read<LoadMoreCubit>();
//     if (widget.post != null) {
//       isEdit = true;
//       _postCubit.getPost(widget.post!.id!);
//     }
//     user = context.read<AppConfigCubit>().getUser();
//     if (user.contactNumber != null && contactNumberController.text.isEmpty) {
//       contactNumberController.text = user.contactNumber!;
//       contactNumberCountryCodeController.text = user.contactNumberCode!;
//     }
//     if (user.store != null) {
//       //FIRST VERSION EDITS
//       // isBookUpShopUp=user.store!.storePlan!.id==Constants.planSKey || user.store!.storePlan!.id==Constants.plan24Key;
//       isCallUp = user.store != null;
//     }
//     if (pickLocation == null && user.lat != null) {
//       pickLocation = PickLocationModel(
//           lat: double.parse(user.lat!),
//           lng: double.parse(user.lng!),
//           location: user.address!);
//     }
//     super.initState();
//   }

//   bool isKidsChecked = false;
//   bool isIslamicChecked = false;

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (bool didPop, Object) {
//         if (didPop) {
//           return;
//         }
//         previousPage();
//       },
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: BlocConsumer<PostCubit, PostState>(
//               bloc: _postCubit,
//               listener: (context, state) {
//                 if (state is PostLoaded) {
//                   tempPost = state.response;
//                   isEdit = true;
//                   _pageController = PageController(initialPage: 1);
//                   if (tempPost.description != null) {
//                     captionController.text = tempPost.description!;
//                   }
//                   postType = tempPost.postType!;
//                   if (tempPost.additionalInfo != null) {
//                     additionalInfoController.text = tempPost.additionalInfo!;
//                   }
//                   if (tempPost.discount != null && tempPost.discount != 0) {
//                     discountController.text = tempPost.discount!.toString();
//                     priceWithDiscountController.text =
//                         tempPost.sellPrice.toString();
//                   }
//                   if (tempPost.contactNumber != null) {
//                     contactNumberController.text = tempPost.contactNumber!;
//                     contactNumberCountryCodeController.text =
//                         tempPost.contactNumberCode!;
//                   }
//                   if (tempPost.price != null) {
//                     priceController.text =
//                         _formatNumber(tempPost.price!.toString());
//                     currency = CurrencyModel(currency: tempPost.priceCurrency!);
//                     stockController.text = tempPost.stockCount!.toString();
//                     stokeType = tempPost.stockType!;
//                   }
//                   if (tempPost.vipStockCount != null) {
//                     vipStockController.text = tempPost.vipStockCount.toString();
//                   }
//                   if (tempPost.postTaggedPosts != null) {
//                     postTaggedPosts = tempPost.postTaggedPosts!;
//                   }
//                   if (tempPost.postTaggedProfiles != null) {
//                     postTaggedProfiles = tempPost.postTaggedProfiles!;
//                   }
//                   if (tempPost.childCategory != null) {
//                     childCategory = tempPost.childCategory!;
//                     if (tempPost.subCategory != null)
//                       subCategory = tempPost.subCategory!;
//                     if (tempPost.category != null)
//                       category = tempPost.category!;
//                   }
//                   if (tempPost.postCategoryOption != null) {
//                     categoryOptionList = tempPost.postCategoryOption!;
//                   }
//                   if (tempPost.deliveryCharge != null &&
//                       tempPost.deliveryCharge != 0) {
//                     isDeliveryController.text = "true";
//                     deliveryRangeController.text =
//                         tempPost.deliveryRange.toString();
//                     deliveryPriceController.text =
//                         tempPost.deliveryCharge.toString();
//                   }
//                   if (tempPost.shifts != null) {
//                     scheduleStockTiming = tempPost.shifts!;
//                   }
//                   if (tempPost.lat != null) {
//                     pickLocation = PickLocationModel(
//                       lat: double.parse(tempPost.lat!),
//                       lng: double.parse(tempPost.lng!),
//                       location: tempPost.address ?? "",
//                     );
//                   }
//                   isVipController.text = tempPost.isVip == 1 ? "true" : "false";
//                   isKidsChecked = tempPost.isKids == 1;
//                   isIslamicChecked = tempPost.isIslam == 1;
//                 }
//               },
//               builder: (context, state) {
//                 if (state is PostLoading) {
//                   return const CenteredCircularProgressIndicator();
//                 }
//                 if (state is PostFailure) {
//                   return ErrorHandler(exception: state.exception)
//                       .buildErrorWidget(
//                           context: context,
//                           retryCallback: () =>
//                               _postCubit.getPost(widget.post!.id!));
//                 }
//                 return BlocListener<AddEditPostCubit, AddEditPostState>(
//                   bloc: _addEditPostCubit,
//                   listener: (context, state) {
//                     if (state is ValidatePostDone) {
//                       if (isEdit) {
//                         _addEditPostCubit.updatePost(
//                           body: uploadBody,
//                           files: uploadFiles,
//                           postId: widget.post!.id!,
//                         );
//                       } else {
//                         _addEditPostCubit.addPost(
//                           body: uploadBody,
//                           files: uploadFiles,
//                         );
//                       }
//                       Navigator.pop(context);
//                     }
//                     if (state is ValidatePostFailure) {
//                       ErrorHandler(exception: state.exception)
//                           .showErrorSnackBar(context: context);
//                     }
//                   },
//                   child: PageView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     controller: _pageController,
//                     children: [
//                       // Media Lib
//                       _buildMediaPage(context),
//                       _buildPostDetailsPage(context),
//                       _buildPostAdditionalInfoPage(context),
//                       _buildProductDetailsPage(context),
//                       _buildVipDetailsPage(context),
//                     ],
//                   ),
//                 );
//               }),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaPage(BuildContext context) {
//     return MediaLibrary(
//       onPicked: (selectedList) {
//         mediaList = selectedList!;
//         nextPage();
//         setState(() {});
//       },
//       backWidget: Text(S.current.back),
//       nextWidget: Text(S.current.next),
//       maxAssets: 10,
//       editedImagesLength:
//           isEdit ? tempPost.postMediaList!.length : widget.sharedFiles?.length,
//       sharedFiles: widget.sharedFiles ?? [],
//       nextButtonOnEdit: () {
//         nextPage();
//         if (isEdit) setState(() {});
//       },
//     );
//   }

//   Widget _buildPostDetailsPage(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 50.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                   onPressed: () => previousPage(), child: Text(S.current.back)),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Stack(
//             children: [
//               Form(
//                 key: _postDetailsKeyForm,
//                 child: Padding(
//                   padding: EdgeInsets.all(12.0),
//                   child: ListView(
//                     physics: const BouncingScrollPhysics(),
//                     children: [
//                       SizedBox(height: 5.h),

//                       // Media Selected
//                       _buildSelectedMedia(context),
//                       SizedBox(height: 5),

//                       //caption
//                       MentionHashtagTextField(
//                         withButtons: true,
//                         isUnderLineStyle: true,
//                         controller: captionController,
//                         label: "",
//                         hintText: S.current.addCaptionAndHashtags,
//                         validator: (val) =>
//                             val == null ? S.current.requiredField : null,
//                         minLine: 1,
//                         maxLine: 10,
//                         onChanged: () {
//                           setState(() {});
//                         },
//                       ),

//                       SizedBox(height: 20),

//                       // Tag up posts
//                       _buildTagUpPosts(context),
//                       SizedBox(height: 20),

//                       // Tag up Profiles
//                       _buildTagUpProfile(context),
//                       SizedBox(height: 20),

//                       _buildPickUpLocation(
//                         context,
//                         onChange: (location) {
//                           setState(() {
//                             pickLocation = location;
//                           });
//                         },
//                         isError: locationError,
//                       ),
//                       SizedBox(height: 20),
//                       EditTextField(
//                         controller: contactNumberController,
//                         label: S.current.contactNumber,
//                         isNumber: true,
//                         maxLength: 12,
//                         hintText: "XXX XXX XXXX",
//                         withCountryCodePicker: true,
//                         validator: (text) {
//                           return TextInputValidator(minLength: 7, validators: [
//                             InputValidator.minLength,
//                             if(postType == Constants.callUpKey)
//                               InputValidator.requiredField
//                           ]).validate(text);
//                         },
//                         countryCodeController: contactNumberCountryCodeController,
//                       ),
//                       SizedBox(height: 20),
//                       _buildKidsContent(context),

//                       SizedBox(height: 20),
//                       _buildIslamicContent(context),
//                       SizedBox(height: 30.h),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: Container(
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   width: MediaQuery.of(context).size.width,
//                   height: 50,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 postType = Constants.postUpKey;
//                               });
//                               addEditPostFunction();
//                             },
//                             child: Text(S.current.social.toUpperCase())),
//                       ),
//                       Expanded(
//                         child: TextButton(
//                             onPressed: captionController.text.isEmpty
//                                 ? null
//                                 : () {
//                                     setState(() {
//                                       postType = Constants.callUpKey;
//                                     });
//                                     if (!_postDetailsKeyForm.currentState!
//                                         .validate()) {
//                                       return;
//                                     }
//                                     nextPage();
//                                   },
//                             child: Text(S.current.callUp.toUpperCase())),
//                       ),
//                       Expanded(child: SizedBox()),
//                       Expanded(child: SizedBox()),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSelectedMedia(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.darkColor
//             : AppColors.grey,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Media Selected",
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               GestureDetector(
//                 onTap: previousPage,
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: AppColors.darkGrey,
//                     shape: BoxShape.circle,
//                     boxShadow: [Helpers.boxShadow(context)],
//                   ),
//                   child: Center(
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.blackColor,
//                       radius: 11,
//                       child: Icon(
//                         Icons.add,
//                         color: AppColors.whiteColor,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(children: [
//               if (isEdit)
//                 ...tempPost.postMediaList!
//                     .map((e) => EditPostMediaWidget(postMedia: e))
//                     .toList(),
//               ...mediaList
//                   .map((e) => EditPostMediaWidget(mediaFile: e))
//                   .toList(),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTagUpPosts(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.darkColor
//             : AppColors.grey,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 S.current.liftUpPost,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),

//               // add icon
//               GestureDetector(
//                 onTap: () {
//                   _postCubit.initial();
//                   TextEditingController searchController =
//                       TextEditingController();
//                   PaginationPage tagUpPostPage = PaginationPage(currentPage: 2);
//                   AppModalBottomSheet.showMainModalBottomSheet(
//                     context: context,
//                     isExpandable: true,
//                     onScrollEnd: () {
//                       if (_loadMoreCubit.state is! LoadMoreLoading) {
//                         _loadMoreCubit.loadMoreSearchTagUpPost(tagUpPostPage,
//                             withLiftUp: 0,
//                             search: searchController.text,
//                             isKids: isKidsChecked ? 1 : 0,
//                             withIsKids: isKidsChecked);
//                       }
//                     },
//                     scrollableContent: BlocBuilder<PostCubit, PostState>(
//                         bloc: _postCubit,
//                         builder: (context, state) {
//                           if (state is PostListLoading) {
//                             return const CenteredCircularProgressIndicator();
//                           }
//                           if (state is PostListLoaded) {
//                             List<Post> list = state.response.postList!;
//                             tagUpPostPage = PaginationPage(currentPage: 2);
//                             return StatefulBuilder(builder:
//                                 (BuildContext context,
//                                     StateSetter bottomSheetSetState) {
//                               return Column(
//                                 children: [
//                                   ...list.map((e) {
//                                     bool isExist = postTaggedPosts
//                                             .firstWhereOrNull((element) =>
//                                                 e.id == element.id) !=
//                                         null;
//                                     return Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child:
//                                                 PostHorizontalWidget(post: e),
//                                           ),
//                                           if (isExist)
//                                             IconButton(
//                                                 onPressed: () {
//                                                   postTaggedPosts.removeWhere(
//                                                       (element) =>
//                                                           e.id == element.id);
//                                                   setState(() {});
//                                                   bottomSheetSetState(() {});
//                                                 },
//                                                 icon: Icon(Icons.delete,
//                                                     color: Colors.red)),
//                                           if (!isExist)
//                                             IconButton(
//                                                 onPressed: () {
//                                                   postTaggedPosts.add(e);
//                                                   setState(() {});
//                                                   bottomSheetSetState(() {});
//                                                 },
//                                                 icon: Icon(Icons.add,
//                                                     color: Colors.green)),
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                   BlocConsumer<LoadMoreCubit, LoadMoreState>(
//                                       bloc: _loadMoreCubit,
//                                       listener: (context, state) {
//                                         if (state is LoadMoreFailure) {
//                                           ErrorHandler(
//                                                   exception: state.exception)
//                                               .handleError(context);
//                                         }
//                                         if (state
//                                             is LoadMoreSearchTagUpPostLoaded) {
//                                           PostList temp = state.list;
//                                           if (temp.postList!.isNotEmpty) {
//                                             tagUpPostPage.currentPage++;
//                                             bottomSheetSetState(() {
//                                               list.addAll(temp.postList!);
//                                             });
//                                           }
//                                         }
//                                       },
//                                       builder: (context, state) {
//                                         if (state is LoadMoreLoading) {
//                                           return const CenteredCircularProgressIndicator();
//                                         }
//                                         return Container();
//                                       }),
//                                   const SizedBox(height: 5),
//                                 ],
//                               );
//                             });
//                           }
//                           if (state is PostListFailure) {
//                             return ErrorHandler(exception: state.exception)
//                                 .buildErrorWidget(
//                                     context: context,
//                                     retryCallback: () {
//                                       if (int.tryParse(
//                                               searchController.text.trim()) !=
//                                           null) {
//                                         _postCubit.getPosts(
//                                             withLiftUp: 0,
//                                             postId: int.parse(
//                                                 searchController.text),
//                                             isKids: isKidsChecked ? 1 : 0,
//                                             withIsKids: isKidsChecked);
//                                       } else {
//                                         _postCubit.getPosts(
//                                             withLiftUp: 0,
//                                             search: searchController.text,
//                                             isKids: isKidsChecked ? 1 : 0,
//                                             withIsKids: isKidsChecked);
//                                       }
//                                     });
//                           }
//                           return Container();
//                         }),
//                     fixesContent: Container(
//                       margin: EdgeInsets.all(20.w),
//                       child: SearchEditTextField(
//                         controller: searchController,
//                         label: S.current.search,
//                         onChange: (_) {
//                           if (int.tryParse(searchController.text.trim()) !=
//                               null) {
//                             _postCubit.getPosts(
//                                 withLiftUp: 0,
//                                 postId: int.parse(searchController.text),
//                                 isKids: isKidsChecked ? 1 : 0,
//                                 withIsKids: isKidsChecked);
//                           } else {
//                             if (searchController.text.length >= 2) {
//                               searchDeBouncer.run(1, () {
//                                 if (searchController.text.length >= 2)
//                                   _postCubit.getPosts(
//                                       withLiftUp: 0,
//                                       search: searchController.text,
//                                       isKids: isKidsChecked ? 1 : 0,
//                                       withIsKids: isKidsChecked);
//                               });
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: AppColors.darkGrey,
//                     shape: BoxShape.circle,
//                     boxShadow: [Helpers.boxShadow(context)],
//                   ),
//                   child: Center(
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.blackColor,
//                       radius: 11,
//                       child: Icon(
//                         Icons.add,
//                         color: AppColors.whiteColor,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           // Tag up selected post
//           if (postTaggedPosts.isNotEmpty)
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(
//                     postTaggedPosts.length,
//                     (index) => Container(
//                           margin: EdgeInsets.symmetric(horizontal: 4),
//                           width: Helpers.getPostWidgetWidth(context),
//                           child: PostWidget(
//                               post: postTaggedPosts[index],
//                               withDetails: false,
//                               onTapRemove: () {
//                                 setState(() {
//                                   postTaggedPosts.removeAt(index);
//                                 });
//                               }),
//                         )).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTagUpProfile(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.darkColor
//             : AppColors.grey,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 S.current.liftUpProfile,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   TextEditingController searchController =
//                       TextEditingController();
//                   PaginationPage tagUpProfilePage =
//                       PaginationPage(currentPage: 2);
//                   AppModalBottomSheet.showMainModalBottomSheet(
//                     isExpandable: true,
//                     context: context,
//                     onScrollEnd: () {
//                       if (_loadMoreCubit.state is! LoadMoreLoading) {
//                         _loadMoreCubit.loadMoreSearchTagUpProfile(
//                           tagUpProfilePage,
//                           search: searchController.text,
//                         );
//                       }
//                     },
//                     fixesContent: Container(
//                       margin: EdgeInsets.all(20.w),
//                       child: SearchEditTextField(
//                         controller: searchController,
//                         label: S.current.search,
//                         onChange: (_) {
//                           if (searchController.text.length >= 2) {
//                             searchDeBouncer.run(1, () {
//                               if (searchController.text.length >= 2)
//                                 _profileCubit.getUsers(
//                                     search: searchController.text);
//                             });
//                           }
//                         },
//                       ),
//                     ),
//                     scrollableContent: BlocBuilder<ProfileCubit, ProfileState>(
//                         bloc: _profileCubit,
//                         builder: (context, state) {
//                           if (state is ProfileLoading) {
//                             return const CenteredCircularProgressIndicator();
//                           }
//                           if (state is ProfileListLoaded) {
//                             tagUpProfilePage = PaginationPage(currentPage: 2);
//                             List<User> list = state.response.userList!;
//                             return StatefulBuilder(builder:
//                                 (BuildContext context,
//                                     StateSetter bottomSheetSetState) {
//                               return Column(
//                                 children: [
//                                   ...list.map((e) {
//                                     bool isExist = postTaggedProfiles
//                                             .firstWhereOrNull((element) =>
//                                                 e.id == element.id) !=
//                                         null;
//                                     return Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           ProfileWidget(user: e),
//                                           if (isExist)
//                                             IconButton(
//                                               onPressed: () {
//                                                 postTaggedProfiles.removeWhere(
//                                                     (element) =>
//                                                         e.id == element.id);
//                                                 setState(() {});
//                                                 bottomSheetSetState(() {});
//                                               },
//                                               icon: Icon(Icons.delete,
//                                                   color: Colors.red),
//                                             ),
//                                           if (!isExist)
//                                             IconButton(
//                                               onPressed: () {
//                                                 postTaggedProfiles.add(e);
//                                                 setState(() {});
//                                                 bottomSheetSetState(() {});
//                                               },
//                                               icon: Icon(Icons.add,
//                                                   color: Colors.green),
//                                             ),
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                   BlocConsumer<LoadMoreCubit, LoadMoreState>(
//                                       bloc: _loadMoreCubit,
//                                       listener: (context, state) {
//                                         if (state is LoadMoreFailure) {
//                                           ErrorHandler(
//                                                   exception: state.exception)
//                                               .handleError(context);
//                                         }
//                                         if (state
//                                             is LoadMoreSearchTagUpProfileLoaded) {
//                                           UserList temp = state.list;
//                                           if (temp.userList!.isNotEmpty) {
//                                             tagUpProfilePage.currentPage++;
//                                             bottomSheetSetState(() {
//                                               list.addAll(temp.userList!);
//                                             });
//                                           }
//                                         }
//                                       },
//                                       builder: (context, state) {
//                                         if (state is LoadMoreLoading) {
//                                           return const CenteredCircularProgressIndicator();
//                                         }
//                                         return Container();
//                                       }),
//                                   const SizedBox(height: 5),
//                                 ],
//                               );
//                             });
//                           }
//                           if (state is ProfileFailure) {
//                             return ErrorHandler(exception: state.exception)
//                                 .buildErrorWidget(
//                                     context: context,
//                                     retryCallback: () => _profileCubit.getUsers(
//                                         search: searchController.text));
//                           }
//                           return Container();
//                         }),
//                   );
//                 },
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: AppColors.darkGrey,
//                     shape: BoxShape.circle,
//                     boxShadow: [Helpers.boxShadow(context)],
//                   ),
//                   child: Center(
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.blackColor,
//                       radius: 11,
//                       child: Icon(
//                         Icons.add,
//                         color: AppColors.whiteColor,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//               // GestureDetector(onTap: () {

//               // }),
//             ],
//           ),
//           SizedBox(height: 10),
//           // Profiles
//           if (postTaggedProfiles.isNotEmpty)
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(
//                   postTaggedProfiles.length,
//                   (index) => ProfileWidget(
//                     user: postTaggedProfiles[index],
//                     onTapRemove: () {
//                       setState(() {
//                         postTaggedProfiles.removeAt(index);
//                       });
//                     },
//                   ),
//                 ).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPickUpLocation(BuildContext context,
//       {required Function(PickLocationModel?)? onChange,
//       required bool isError}) {
//     return Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).brightness == Brightness.dark
//               ? AppColors.darkColor
//               : AppColors.grey,
//           borderRadius: BorderRadius.circular(10.r),
//           border: isError ? Border.all(color: Colors.red) : null,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(
//             S.current.location,
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontSize: 19,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           SizedBox(height: 25),
//           GestureDetector(
//               onTap: () async {
//                 AppModalBottomSheet.showMainModalBottomSheet(
//                     context: context,
//                     height: 200,
//                     scrollableContent: Column(
//                       children: [
//                         CustomElevatedButton(
//                           margin:
//                               EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                           backgroundColor: AppColors.primaryColor,
//                           withBorderRadius: true,
//                           onPressed: () async {
//                             Navigator.of(context).pop();
//                             try {
//                               AppDialog.showLoadingDialog(context: context);
//                               Position location =
//                                   await Helpers.getCurrentLocation(context);
//                               String locationName =
//                                   await Helpers.getAddressFromLatLng(location);
//                               onChange?.call(PickLocationModel(
//                                   lat: location.latitude,
//                                   lng: location.longitude,
//                                   location: locationName));

//                               AppDialog.closeAppDialog();
//                             } catch (_) {
//                               AppDialog.closeAppDialog();
//                             }
//                           },
//                           child: Text(S.current.useCurrentLocation,
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                         CustomElevatedButton(
//                           margin:
//                               EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//                           backgroundColor: AppColors.primaryColor,
//                           withBorderRadius: true,
//                           onPressed: () async {
//                             Navigator.of(context).pop();
//                             bool serviceEnabled =
//                                 await Geolocator.isLocationServiceEnabled();
//                             if (!serviceEnabled) {
//                               AppSnackBar(
//                                       context: context,
//                                       onTap: () =>
//                                           Geolocator.openLocationSettings())
//                                   .showLocationServiceDisabledSnackBar();
//                               return;
//                             }
//                             LocationPermission permission =
//                                 await Geolocator.checkPermission();
//                             if (permission ==
//                                     LocationPermission.deniedForever ||
//                                 permission == LocationPermission.denied) {
//                               AppSnackBar(context: context)
//                                   .showLocationPermanentlyDeniedSnackBar();
//                               return;
//                             }
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => Theme(
//                                   data: ThemeData(brightness: Brightness.light),
//                                   child: PlacePicker(
//                                     apiKey: Constants.googleMapKey,
//                                     onPlacePicked: (result) {
//                                       onChange?.call(PickLocationModel(
//                                           lat: result.geometry!.location.lat,
//                                           lng: result.geometry!.location.lng,
//                                           location: result.formattedAddress
//                                               .toString()));
//                                       Navigator.of(context).pop();
//                                     },
//                                     useCurrentLocation: true,
//                                     resizeToAvoidBottomInset: false,
//                                     initialPosition: LatLng(0, 0),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Text(S.current.selectFromMap,
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ],
//                     ));
//               },
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 78,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: AppColors.secondary),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.only(end: 89, start: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             S.current.tapToConnect,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(fontSize: 11),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             pickLocation?.location ?? S.current.locationIsOff,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge
//                                 ?.copyWith(
//                                     color: AppColors.green, fontSize: 12),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   PositionedDirectional(
//                     end: 0,
//                     top: -2.5,
//                     child: Container(
//                       width: 80,
//                       height: 83,
//                       decoration: BoxDecoration(
//                         color: AppColors.secondary,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Center(
//                           child: Icon(Icons.location_on,
//                               color: AppColors.whiteColor)),
//                     ),
//                   )
//                 ],
//               ))
//         ]));
//   }

//   Widget _buildKidsContent(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.darkColor
//             : AppColors.grey,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               S.current.postAsKidsContent,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontSize: 19,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               if (isKidsChecked) {
//                 setState(() {
//                   isKidsChecked = !isKidsChecked;
//                 });
//                 category = null;
//                 subCategory = null;
//                 childCategory = null;
//                 return;
//               }
//               AppDialog.showConfirmationDialog(
//                 context: context,
//                 message: "${S.current.confirmKidsContent}",
//                 content: "${S.current.confirmSubmitForReview}",
//                 onConfirm: () {
//                   setState(() {
//                     isKidsChecked = !isKidsChecked;
//                   });
//                   category = null;
//                   subCategory = null;
//                   childCategory = null;
//                 },
//               );
//             },
//             child: Container(
//               width: 25,
//               height: 25,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.r),
//                 boxShadow: [Helpers.boxShadow(context)],
//                 color: isKidsChecked ? AppColors.green : AppColors.whiteColor,
//               ),
//               child: Center(
//                 child: !isKidsChecked
//                     ? Icon(
//                         Icons.add,
//                         color: AppColors.blackColor,
//                         size: 20,
//                       )
//                     : Icon(
//                         Icons.check,
//                         color: AppColors.whiteColor,
//                         size: 20,
//                       ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildIslamicContent(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.darkColor
//             : AppColors.grey,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               S.current.postAsIslamicContent,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontSize: 19,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               if (isIslamicChecked) {
//                 setState(() {
//                   isIslamicChecked = !isIslamicChecked;
//                 });
//                 return;
//               }
//               AppDialog.showConfirmationDialog(
//                 context: context,
//                 message: "${S.current.confirmIslamicContent}",
//                 content: "${S.current.confirmSubmitForReview}",
//                 onConfirm: () {
//                   setState(() {
//                     isIslamicChecked = !isIslamicChecked;
//                   });
//                 },
//               );
//             },
//             child: Container(
//               width: 25,
//               height: 25,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.r),
//                 boxShadow: [Helpers.boxShadow(context)],
//                 color:
//                     isIslamicChecked ? AppColors.green : AppColors.whiteColor,
//               ),
//               child: Center(
//                 child: !isIslamicChecked
//                     ? Icon(
//                         Icons.add,
//                         color: AppColors.blackColor,
//                         size: 20,
//                       )
//                     : Icon(
//                         Icons.check,
//                         color: AppColors.whiteColor,
//                         size: 20,
//                       ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildPostAdditionalInfoPage(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 50.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                   onPressed: () => previousPage(), child: Text(S.current.back)),
//               TextButton(
//                   onPressed: () {
//                     if (childCategory == null) {
//                       AppSnackBar(
//                               message: S.current.category +
//                                   " " +
//                                   S.current.requiredField,
//                               context: context)
//                           .showErrorSnackBar();
//                       return;
//                     }
//                     bool isCategoryOptionError = false;
//                     if (childCategory!.options != null)
//                       for (CategoryOption o in childCategory!.options!) {
//                         if (o.type == Constants.categoryOptionColorTypeKey) {
//                           if (o.isRequired! && o.value == null) {
//                             isCategoryOptionError = true;
//                             o.isError = true;
//                           } else {
//                             o.isError = false;
//                           }
//                         }
//                       }
//                     if (!categoryFormKey.currentState!.validate() ||
//                         isCategoryOptionError) {
//                       setState(() {});
//                       return;
//                     }

//                     categoryOptionList.clear();
//                     if (childCategory!.options != null)
//                       for (CategoryOption o in childCategory!.options!) {
//                         if (o.type == Constants.categoryOptionColorTypeKey ||
//                             o.type == Constants.categoryOptionArrayTypeKey) {
//                           categoryOptionList.add(CategoryOption(
//                             id: o.id,
//                             value: o.value,
//                           ));
//                         }
//                       }
//                     categoryFormKey.currentState?.save();

//                     nextPage();
//                   },
//                   child: Text(S.current.next)),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Form(
//               key: categoryFormKey,
//               child: ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   ViewAllIconHeader(
//                     leadingText: S.current.menu,
//                     onNavigate: () {
//                       Navigator.of(AppRouter.mainContext)
//                           .pushNamed(SelectCategoryScreen.routName, arguments: {
//                         "isForKids": isKidsChecked ? 1 : 0,
//                       }).then((v) {
//                         if (v != null) {
//                           List<Category> selectedCategoryList =
//                               v as List<Category>;
//                           category = selectedCategoryList[0];
//                           subCategory = selectedCategoryList[1];
//                           childCategory = selectedCategoryList[2];
//                           setState(() {});
//                         }
//                       });
//                     },
//                     icon: Icons.add_circle_outlined,
//                   ),
//                   const SizedBox(height: 6),
//                   if (childCategory != null)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           CategoryWidget(onTap: () {}, category: category!),
//                           CategoryWidget(onTap: () {}, category: subCategory!),
//                           CategoryWidget(
//                               onTap: () {}, category: childCategory!),
//                         ],
//                       ),
//                     ),
//                   SizedBox(height: 10.h),
//                   if (childCategory != null &&
//                       childCategory?.options != null &&
//                       childCategory!.options!.isNotEmpty) ...{
//                     Text(S.current.specifications),
//                     ...childCategory!.options!.map((e) {
//                       if (e.type == Constants.categoryOptionNumericTypeKey ||
//                           e.type == Constants.categoryOptionStringTypeKey) {
//                         return Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5.0.h),
//                           child: TextFormField(
//                             keyboardType:
//                                 e.type == Constants.categoryOptionNumericTypeKey
//                                     ? TextInputType.number
//                                     : null,
//                             inputFormatters: [
//                               if (e.type ==
//                                   Constants.categoryOptionNumericTypeKey)
//                                 FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             onSaved: (v) {
//                               categoryOptionList.add(CategoryOption(
//                                 id: e.id,
//                                 value: v,
//                               ));
//                             },
//                             initialValue: categoryOptionList
//                                     .firstWhereOrNull(
//                                         (element) => element.id == e.id)
//                                     ?.value ??
//                                 "",
//                             maxLines: 1,
//                             minLines: 1,
//                             style: Theme.of(context).textTheme.bodyLarge,
//                             cursorColor: AppColors.primaryColor,
//                             validator: e.isRequired!
//                                 ? (value) {
//                                     if (value != null && value.trim().isEmpty) {
//                                       return S.current.requiredField;
//                                     }
//                                     return null;
//                                   }
//                                 : null,
//                             decoration: InputDecoration(
//                                 counterText: "",
//                                 label: Text(e.name.toString()),
//                                 labelStyle: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                       color: Theme.of(context).primaryColorDark,
//                                       fontSize: 14.sp,
//                                     ),
//                                 filled: true,
//                                 fillColor: Colors.transparent,
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                   borderSide: BorderSide(
//                                       color: AppColors.textFieldBorderLight,
//                                       width: 1.w),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                   borderSide: BorderSide(
//                                       color: AppColors.textFieldBorderLight,
//                                       width: 1.w),
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5))),
//                           ),
//                         );
//                       } else if (e.type ==
//                           Constants.categoryOptionArrayTypeKey) {
//                         if (isEdit && e.value == null)
//                           e.value = categoryOptionList
//                               .firstWhereOrNull((element) => element.id == e.id)
//                               ?.value;
//                         return Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5.0.h),
//                           child: AppDropDownButton<String>(
//                             items: e.options!
//                                 .map((o) => DropdownMenuItem<String>(
//                                       child: Container(
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             o.toString(),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge,
//                                           )),
//                                       value: o,
//                                     ))
//                                 .toList(),
//                             hintText: e.name,
//                             value: e.value,
//                             validator: e.isRequired!
//                                 ? (value) {
//                                     if (value == null)
//                                       return S.current.requiredField;
//                                     if (value.trim().isEmpty) {
//                                       return S.current.requiredField;
//                                     }
//                                     return null;
//                                   }
//                                 : null,
//                             onChanged: (v) {
//                               setState(() {
//                                 e.value = v;
//                               });
//                             },
//                           ),
//                         );
//                       } else if (e.type ==
//                           Constants.categoryOptionColorTypeKey) {
//                         if (isEdit && e.value == null)
//                           e.value = categoryOptionList
//                               .firstWhereOrNull((element) => element.id == e.id)
//                               ?.value;
//                         return ColorPiker(
//                           initialValue: e.value,
//                           isError: e.isError,
//                           isEmpty: !e.isRequired!,
//                           title: e.name,
//                           onTap: (color) {
//                             setState(() {
//                               e.value = color.toHexString();
//                             });
//                           },
//                         );
//                       }
//                       return SizedBox();
//                     }).toList(),
//                   },
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 5.0.h),
//                     child: EditTextField(
//                         controller: additionalInfoController,
//                         label: S.current.additionalInfo,
//                         minLine: 3,
//                         maxLine: 5,
//                         isEmpty: true),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProductDetailsPage(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 50.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                   onPressed: () => previousPage(), child: Text(S.current.back)),
//               TextButton(
//                   onPressed: () {
//                     if (!_postDetails2KeyForm.currentState!.validate()) {
//                       return;
//                     }
//                     bool allStoreTimingNull = true;
//                     for (var e in scheduleStockTiming) {
//                       if (e.fromTime != null || e.toTime != null) {
//                         allStoreTimingNull = false;
//                       }
//                       if (e.fromTime != null && e.toTime == null) {
//                         AppSnackBar(
//                                 message: S.current.youHaveToSelectTimeForDay(
//                                     S.current.toTime, e.dayName!),
//                                 context: context)
//                             .showErrorSnackBar();
//                         return;
//                       }
//                       if (e.toTime != null && e.fromTime == null) {
//                         AppSnackBar(
//                                 message: S.current.youHaveToSelectTimeForDay(
//                                     S.current.fromTime, e.dayName!),
//                                 context: context)
//                             .showErrorSnackBar();
//                         return;
//                       }
//                     }
//                     if (allStoreTimingNull &&
//                         stokeType == Constants.stockTypeSchedule) {
//                       AppSnackBar(
//                               message: S
//                                   .current.youHaveToSelectAtLeastOneWorkingTime,
//                               context: context)
//                           .showErrorSnackBar();
//                       return;
//                     }
//                     nextPage();
//                   },
//                   child: Text(S.current.next)),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Form(
//             key: _postDetails2KeyForm,
//             child: Padding(
//               padding: EdgeInsets.all(12.0),
//               child: ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   SizedBox(height: 10.h),
//                   _buildSelectCurrency(context),
//                   SizedBox(height: 10.h),
//                   EditTextField(
//                     controller: priceController,
//                     label: S.current.price,
//                     // isNumber: true,
//                     // isDecimal: true,
//                     onChanged: () {
//                       priceController.text = _formatNumber(priceValue);

//                       if (priceValue.isNotEmpty &&
//                           discountController.text.isNotEmpty) {
//                         double p = double.parse(priceValue);
//                         double d = double.parse(discountController.text);
//                         priceWithDiscountController.text =
//                             (p - ((p * d) / 100)).toStringAsFixed(2);
//                       }
//                       if (priceValue.isEmpty) {
//                         priceController.clear();
//                         priceWithDiscountController.clear();
//                       }
//                       setState(() {});
//                     },
//                   ),
//                   SizedBox(height: 10.h),
//                   EditTextField(
//                       controller: discountController,
//                       label: S.current.discount,
//                       isEmpty: true,
//                       isNumber: true,
//                       suffixWidget: Icon(Icons.percent),
//                       onChanged: () {
//                         if (priceValue.isNotEmpty &&
//                             discountController.text.isNotEmpty) {
//                           double p = double.parse(priceValue);
//                           double d = double.parse(discountController.text);
//                           priceWithDiscountController.text =
//                               (p - ((p * d) / 100)).toStringAsFixed(2);
//                         }
//                         setState(() {});
//                       },
//                       inputFormatters: [
//                         DiscountTextInputFormatter(),
//                       ]),
//                   SizedBox(height: 10.h),
//                   if (discountController.text.isNotEmpty &&
//                       priceValue.isNotEmpty) ...{
//                     EditTextField(
//                       controller: priceWithDiscountController,
//                       label: S.current.priceAfterDiscount,
//                       isNumber: true,
//                       isDecimal: true,
//                       onChanged: () {
//                         if (priceWithDiscountController.text.isNotEmpty &&
//                             priceValue.isNotEmpty) {
//                           double p = double.parse(priceValue);
//                           double pd =
//                               double.parse(priceWithDiscountController.text);
//                           discountController.text =
//                               (((p - pd) / p) * 100).toStringAsFixed(2);
//                         }
//                         setState(() {});
//                       },
//                     ),
//                     SizedBox(height: 10.h),
//                   },
//                   EditTextField(
//                       controller: stockController,
//                       label: S.current.stock,
//                       isNumber: true),
//                   SizedBox(height: 10.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         S.current.oneTimeStock,
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: Theme.of(context).primaryColorDark,
//                             ),
//                       ),
//                       AppCheckBox(
//                         onChange: () {
//                           setState(() {
//                             stokeType = Constants.stockTypeAllTime;
//                             scheduleStockTiming = List.from(AppData().dayList);
//                           });
//                         },
//                         value: stokeType == Constants.stockTypeAllTime,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         S.current.dailyStockSchedule,
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: Theme.of(context).primaryColorDark,
//                             ),
//                       ),
//                       AppCheckBox(
//                         onChange: () {
//                           setState(() {
//                             stokeType = Constants.stockTypeSchedule;
//                           });
//                         },
//                         value: stokeType == Constants.stockTypeSchedule,
//                       ),
//                     ],
//                   ),
//                   if (stokeType == Constants.stockTypeSchedule)
//                     SelectButton(
//                         icon: CupertinoIcons.calendar,
//                         title: S.current.dailyStockSchedule,
//                         onTap: () => AppModalBottomSheet.showDayTimeBottomSheet(
//                             context: context, dayList: scheduleStockTiming)),
//                   SizedBox(height: 10.h),
//                   BoolSelect(
//                       controller: isDeliveryController,
//                       title: S.current.delivery,
//                       onChange: () => setState(() {})),
//                   if (isDeliveryController.text == "true") ...{
//                     EditTextField(
//                         controller: deliveryRangeController,
//                         label: S.current.deliveryRange,
//                         isNumber: true,
//                         suffixWidget: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text("KM"),
//                         )),
//                     SizedBox(height: 10.h),
//                     _buildSelectCurrency(context),
//                     SizedBox(height: 10.h),
//                     EditTextField(
//                       controller: deliveryPriceController,
//                       label: S.current.deliveryCharges,
//                       isNumber: true,
//                       isDecimal: true,
//                     ),
//                   },
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVipDetailsPage(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 50.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                   onPressed: () => previousPage(), child: Text(S.current.back)),
//               _buildAddPostButton(),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Form(
//               key: _vipKeyForm,
//               child: ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   BoolSelect(
//                       controller: isVipController,
//                       title: S.current.vipItem,
//                       onChange: () => setState(() {})),
//                   if (isVipController.text == "true") ...{
//                     EditTextField(
//                         controller: vipStockController,
//                         label: S.current.stock,
//                         isNumber: true),
//                     SizedBox(height: 10.h),
//                     EditTextField(
//                         controller: TextEditingController(text: "Free"),
//                         label: S.current.price,
//                         isReadOnly: true),
//                     SizedBox(height: 10.h),
//                     EditTextField(
//                         controller: TextEditingController(text: "Free"),
//                         isReadOnly: true,
//                         label: S.current.deliveryCharges),
//                   },
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAddPostButton() {
//     return TextButton(
//       onPressed: () {
//         addEditPostFunction();
//       },
//       child: Text(isEdit ? S.current.save : S.current.publish),
//     );
//   }

//   void addEditPostFunction() {
//     checkLocationError();
//     if (postType != Constants.postUpKey) {
//       if (!_vipKeyForm.currentState!.validate() || locationError) {
//         return;
//       }
//     }
//     if (postType == Constants.postUpKey) {
//       if (!_postDetailsKeyForm.currentState!.validate() || locationError) {
//         return;
//       }
//     }
//     for (int i = 0; i < mediaList.length; i++) {
//       uploadFiles.add(AppFile(
//           file: mediaList[i].getFile()!, fileKey: AddPostBody.imageKey));
//     }
//     uploadBody = AddPostBody(
//       description: captionController.text,
//       additionalInfo: additionalInfoController.text,
//       type: postType.toString(),
//       categoryId: childCategory?.id.toString(),
//       price: priceValue,
//       priceCurrency: currency?.currency,
//       discount: discountController.text,
//       stockType: stokeType.toString(),
//       stockCount: stockController.text,
//       vipStockCount:
//           vipStockController.text.isNotEmpty ? vipStockController.text : null,
//       postTaggedPosts: postTaggedPosts,
//       postTaggedProfiles: postTaggedProfiles,
//       postStockTime:
//           stokeType == Constants.stockTypeSchedule ? scheduleStockTiming : null,
//       isIslamic: isIslamicChecked ? "1" : "0",
//       isVip: isVipController.text == "true" ? "1" : "0",
//       isKids: isKidsChecked ? "1" : "0",
//       deliveryCharge: isDeliveryController.text == "true"
//           ? deliveryPriceController.text
//           : "0",
//       deliveryRange: isDeliveryController.text == "true"
//           ? deliveryRangeController.text
//           : "0",
//       deliveryChargeCurrency: currency?.currency,
//       categoryOptionList: categoryOptionList,
//       contactNumber: contactNumberController.text.isEmpty ? null : contactNumberController.text,
//       contactNumberCode: contactNumberCountryCodeController.text,
//       lat: pickLocation?.lat.toString(),
//       lng: pickLocation?.lng.toString(),
//       address: pickLocation?.location,
//     );

//     _addEditPostCubit.validatePost(uploadBody);
//   }

//   DropdownSearch<CurrencyModel> _buildSelectCurrency(BuildContext context) {
//     return DropdownSearch<CurrencyModel>(
//       itemAsString: (item) =>
//           Helpers.getCurrencyName(item.currency) +
//           (item.countryName == null ? "" : " (${item.countryName})"),
//       items: AppData.postCurrencyList,
//       validator: (val) => val == null ? S.current.requiredField : null,
//       onChanged: (value) {
//         setState(() {
//           currency = value;
//         });
//       },
//       dropdownDecoratorProps: DropDownDecoratorProps(
//         dropdownSearchDecoration: InputDecoration(
//           border: OutlineInputBorder(
//               borderSide:
//                   const BorderSide(color: AppColors.textFieldBorderLight),
//               borderRadius: BorderRadius.circular(15)),
//           disabledBorder: OutlineInputBorder(
//               borderSide:
//                   const BorderSide(color: AppColors.textFieldBorderLight),
//               borderRadius: BorderRadius.circular(15)),
//           enabledBorder: OutlineInputBorder(
//               borderSide:
//                   const BorderSide(color: AppColors.textFieldBorderLight),
//               borderRadius: BorderRadius.circular(15)),
//           errorBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.red),
//               borderRadius: BorderRadius.circular(15)),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: AppColors.textFieldBorderLight),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           label: RichText(
//             textAlign: TextAlign.start,
//             text: TextSpan(
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: Theme.of(context).primaryColorDark,
//                     fontSize: 15.sp,
//                   ),
//               children: [
//                 TextSpan(text: "  ${S.current.currency} "),
//               ],
//             ),
//           ),
//           floatingLabelStyle: Theme.of(context).textTheme.bodyMedium,
//           hintText: S.current.selectedCurrency,
//           labelStyle: TextStyle(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
//         ),
//       ),
//       popupProps: PopupProps.menu(
//           menuProps: MenuProps(
//             backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.darkColor
//                 : AppColors.grey,
//           ),
//           showSelectedItems: true,
//           showSearchBox: true,
//           searchFieldProps: TextFieldProps(
//             maxLines: 1,
//             decoration: InputDecoration(
//               hintText: S.current.search,
//               fillColor: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.darkColor
//                   : AppColors.grey,
//               filled: true,
//               isDense: true,
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               errorStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(color: Colors.red),
//               border: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: AppColors.textFieldBorderLight),
//                   borderRadius: BorderRadius.circular(7)),
//               disabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: AppColors.textFieldBorderLight),
//                   borderRadius: BorderRadius.circular(7)),
//               enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: AppColors.textFieldBorderLight),
//                   borderRadius: BorderRadius.circular(7)),
//               errorBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.red),
//                   borderRadius: BorderRadius.circular(7)),
//               focusedBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: AppColors.textFieldBorderLight),
//                 borderRadius: BorderRadius.circular(7),
//               ),
//             ),
//           )),
//       selectedItem: currency,
//       enabled: true,
//       compareFn: (CurrencyModel a, CurrencyModel b) =>
//           a.currency == b.currency || a.countryName == b.countryName,
//     );
//   }
// }
