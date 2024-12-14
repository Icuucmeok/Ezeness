import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:ezeness/data/models/auth/edit_profile_body.dart';
import 'package:ezeness/data/models/pick_location_model.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/presentation/screens/profile/edit_profile_screen/edit_bio_screen.dart';
import 'package:ezeness/presentation/screens/profile/edit_profile_screen/edit_username_screen.dart';
import 'package:ezeness/presentation/screens/profile/store_upgrade/store_upgrade_screen.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/widgets/common/share_user_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../res/app_res.dart';
import '../../../../data/models/app_file.dart';
import '../../../../data/models/country_model.dart';
import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../utils/app_modal_bottom_sheet.dart';
import '../../../utils/helpers.dart';
import '../../../utils/text_input_validator.dart';
import '../../../widgets/common/common.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routName = 'edit_profile_screen';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactNumberCountryCodeController =
      TextEditingController();
  int? selectedGender;
  PickLocationModel? pickLocation;
  CountryModel? userNationality;
  bool locationError = false;
  late ProfileCubit _profileCubit;
  List<Media> selectedImage = [];

  List<Media> selectedCoverImage = [];

  checkLocationError() {
    if (pickLocation == null) {
      locationError = true;
    } else {
      locationError = false;
    }
    setState(() {});
  }

  late User user;

  @override
  void initState() {
    user = context.read<AppConfigCubit>().getUser();
    fullNameController.text = user.name!;
    if (user.birthDate != null) {
      birthDateController.text = user.birthDate!;
    }
    userNameController.text = user.proUsername == null
        ? user.username.toString().substring(1)
        : user.proUsername.toString();

    if (user.gender != null) selectedGender = user.gender!;
    if (user.nationality != null)
      userNationality = CountryModel(value: user.nationality.toString());
    if (user.lat != null)
      pickLocation = PickLocationModel(
          lat: double.parse(user.lat!),
          lng: double.parse(user.lng!),
          location: user.address!);
    if (user.image != null &&
        user.image != Constants.maleImageUrl &&
        user.image != Constants.femaleImageUrl) {
      setImage(user.image!);
    }

    if (user.coverImage != null) {
      setCoverImage(user.coverImage!);
    }
    if (user.bio != null) {
      bioController.text = user.bio!;
    }
    if (user.email != null) {
      emailController.text = user.email!;
    }
    if (user.website != null) {
      websiteController.text = user.website!;
    }
    if (user.contactNumberCode != null) {
      contactNumberCountryCodeController.text = user.contactNumberCode!;
    }
    if (user.contactNumber != null) {
      contactNumberController.text = user.contactNumber!;
    }
    _profileCubit = context.read<ProfileCubit>();
    super.initState();
  }

  void setImage(String image) async {
    selectedImage.add(
      Media(
        id: "0",
        file: await Helpers.urlToFile(image,
            path: "img_${Random().nextInt(100000)}"),
      ),
    );
    setState(() {});
  }

  void setCoverImage(String coverImage) async {
    selectedCoverImage.add(
      Media(
        id: "1",
        file: await Helpers.urlToFile(coverImage,
            path: "cover_img_${Random().nextInt(100000)}"),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: _profileCubit,
          listener: (context, state) {
            if (state is EditProfileDone) {
              AppSnackBar(context: context, message: S.current.editSuccessfully)
                  .showSuccessSnackBar();
              Navigator.of(context).pop();
            }
            if (state is EditProfileFailure) {
              ErrorHandler(exception: state.exception)
                  .showErrorSnackBar(context: context);
            }
          },
          builder: (context, state) {
            return Form(
              key: _keyForm,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildProfileHeaderWithCover(size, context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        EditTextField(
                          controller: fullNameController,
                          label: S.current.fullName,
                        ),
                        SizedBox(height: 8.h),
                        PickDate(
                          controller: birthDateController,
                          title: S.current.birthdate,
                          isEmpty: AppData.isUserProfileBirthDateRequired
                              ? false
                              : true,
                          isBottomPicker: true,
                        ),
                        SizedBox(height: 8.h),
                        EditTextField(
                          controller: userNameController,
                          label: S.current.userName,
                          isReadOnly: true,
                          onTap: () => Navigator.of(context).pushNamed(
                              EditUsernameScreen.routName,
                              arguments: {
                                'controller': userNameController,
                              }),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          validator: (text) {
                            return TextInputValidator(validators: [
                              InputValidator.requiredField,
                              InputValidator.userName,
                            ]).validate(text);
                          },
                        ),
                        // SizedBox(height: 8.h),
                        // EditTextField(
                        //   controller: emailController,
                        //   label: S.current.email,
                        //   validator: (text) {
                        //     return TextInputValidator(
                        //         validators: [
                        //           InputValidator.email,
                        //         ]).validate(text);
                        //   },
                        //
                        // ),
                        SizedBox(height: 8.h),
                        EditTextField(
                          controller: contactNumberController,
                          label: S.current.contactNumber,
                          isNumber: true,
                          isEmpty: true,
                          maxLength: 12,
                          hintText: "0XX XXX XXXX",
                          withCountryCodePicker: true,
                          validator: (text) {
                            return TextInputValidator(
                                    minLength: 7,
                                    validators: [InputValidator.minLength])
                                .validate(text);
                          },
                          countryCodeController:
                              contactNumberCountryCodeController,
                        ),
                        SizedBox(height: 8.h),
                        EditTextField(
                          controller: bioController,
                          label: S.current.bio,
                          isEmpty: true,
                          isReadOnly: true,
                          hintText: S.current.addSomethingAboutYourself,
                          maxLength: 5000,
                          minLine: 3,
                          maxLine: 3,
                          onTap: () => Navigator.of(context)
                              .pushNamed(EditBioScreen.routName, arguments: {
                            'controller': bioController,
                          }),
                        ),
                        SizedBox(height: 8.h),
                        EditTextField(
                          controller: websiteController,
                          label: S.current.website,
                          isEmpty: true,
                          validator: (text) {
                            return TextInputValidator(validators: [
                              InputValidator.website,
                            ]).validate(text);
                          },
                        ),
                        SizedBox(height: 8.h),
                        _buildSearchNationality(context),
                        SizedBox(height: 8.h),
                        PickLocation(
                            initialLocation: pickLocation?.location,
                            isError: locationError,
                            onChange: (location) {
                              pickLocation = location;
                            }),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  AppCheckBox(
                                    value: selectedGender == Constants.maleKey,
                                    onChange: () => setState(() {
                                      selectedGender = Constants.maleKey;
                                    }),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    S.current.male,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  AppCheckBox(
                                    value:
                                        selectedGender == Constants.femaleKey,
                                    onChange: () => setState(() {
                                      selectedGender = Constants.femaleKey;
                                    }),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    S.current.female,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        if (user.store != null) ...{
                          ListTile(
                            title: Text(S.current.upgradeShopInfo),
                            leading: Icon(Icons.storefront,
                                color: AppColors.primaryColor),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, StoreUpgradeScreen.routName,
                                  arguments: {"isEditStore": true});
                            },
                          ),
                          Divider(height: 2),
                        },
                        CustomElevatedButton(
                          isLoading: state is EditProfileLoading,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          backgroundColor: AppColors.secondary,
                          withBorderRadius: true,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!_keyForm.currentState!.validate()) {
                              return;
                            }
                            if (AppData.isUserProfileLocationRequired) {
                              checkLocationError();
                              if (locationError) {
                                return;
                              }
                            }
                            if (AppData.isUserProfileGenderRequired &&
                                selectedGender == null) {
                              AppSnackBar(
                                      message: S.current.selectGender,
                                      context: context)
                                  .showErrorSnackBar();
                              return;
                            }

                            // image File Extracting
                            AppFile? imageFile = selectedImage.isEmpty
                                ? null
                                : AppFile(
                                    file: selectedImage.first.file!,
                                    fileKey: EditProfileBody.imageKey);

                            // cover image File Extracting
                            AppFile? coverImageFile = selectedCoverImage.isEmpty
                                ? null
                                : AppFile(
                                    file: selectedCoverImage.first.file!,
                                    fileKey: EditProfileBody.coverImageKey,
                                  );

                            _profileCubit.editProfile(
                              body: EditProfileBody(
                                name: fullNameController.text,
                                birthDate: birthDateController.text,
                                lat: pickLocation?.lat,
                                lng: pickLocation?.lng,
                                gender: selectedGender,
                                username: userNameController.text,
                                address: pickLocation?.location,
                                website: websiteController.text,
                                bio: bioController.text,
                                contactNumber: contactNumberController.text,
                                contactNumberCode:
                                    contactNumberCountryCodeController.text,
                                userNationality: userNationality?.value,
                              ),
                              image: imageFile,
                              coverImage: coverImageFile,
                            );
                          },
                          child: Text(S.current.save,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp,
                                      color: AppColors.whiteColor)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _buildProfileHeaderWithCover(Size size, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.grey.withOpacity(0.1)
            : AppColors.grey,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          Container(
            height: size.height * .30,
            margin: EdgeInsets.only(
                left: size.width * .02, right: size.width * .02, bottom: 5),
            decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(
              Radius.circular(size.width * .1),
            )),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: double.infinity,
                        height: size.height * .25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size.width * .1),
                          color: AppColors.greyDark,
                        ),
                        child: _buildProfileCoverImagePicker(context, size)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    height: size.width * .18,
                    width: size.width * .93,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.blackColor.withOpacity(0.6)
                          : AppColors.whiteColor.withOpacity(0.6),
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.width * .1),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: size.width * .06,
                            end: size.width * .10,
                            top: size.width * .02,
                            bottom: size.width * .02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 30),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${user.name}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 30),
                                child: Text(
                                  user.address ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          bottom: 0,
                          end: -12,
                          child: Container(
                            // alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(size.width * .025),
                            decoration: BoxDecoration(
                              color: user.type == Constants.specialInviteKey
                                  ? AppColors.gold
                                  : (user.gender != null &&
                                          user.gender == Constants.femaleKey)
                                      ? Colors.pinkAccent
                                      : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: ShareUserButton(
                              user: user,
                              isOtherUser: false,
                              size: size.width * .13,
                              withBorder: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: Helpers.isTab(context) ? 5 : 0,
                  left: 0,
                  child: Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: 2,
                        ),
                      ),
                      child: _buildProfileImagePicker(context, size)),
                )
              ],
            ),
          ),
          SizedBox(height: 5)
        ],
      ),
    );
  }

  Widget _buildProfileCoverImagePicker(BuildContext context, Size size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: double.infinity,
            height: size.height * .25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * .1),
              color: AppColors.grey,
              image: selectedCoverImage.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(selectedCoverImage.first.file!),
                    )
                  : null,
            )),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: CircleAvatar(
                backgroundColor: AppColors.blackColor.withOpacity(0.2),
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.whiteColor.withOpacity(0.75)
                      : AppColors.darkGrey,
                ),
              ),
              onPressed: () {
                AppModalBottomSheet.showMainModalBottomSheet(
                  context: context,
                  scrollableContent: MediaPicker(
                    mediaList: selectedCoverImage,
                    onPicked: (selectedList) {
                      Navigator.pop(context);
                      setState(() {
                        selectedCoverImage = selectedList;
                      });
                    },
                    headerBuilder: (context, albumPicker, onDone, onCancel) {
                      return SizedBox(
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.clear)),
                            Expanded(child: Center(child: albumPicker)),
                            TextButton(
                              onPressed: onDone,
                              child: Text(S.current.next),
                            ),
                          ],
                        ),
                      );
                    },
                    mediaCount: MediaCount.single,
                    mediaType: MediaType.image,
                    decoration: PickerDecoration(
                      albumTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                      albumTitleStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    ),
                  ),
                );
              },
            ),
            if (selectedCoverImage.isNotEmpty)
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: AppColors.blackColor.withOpacity(0.2),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedCoverImage.clear();
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImagePicker(BuildContext context, Size size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: Helpers.isTab(context) ? 150 : size.width * .24,
          height: Helpers.isTab(context) ? 150 : size.width * .24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey,
            image: selectedImage.isNotEmpty
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(selectedImage.first.file!))
                : null,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: CircleAvatar(
                backgroundColor: AppColors.whiteColor.withOpacity(0.2),
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.whiteColor.withOpacity(0.75)
                      : AppColors.darkGrey,
                ),
              ),
              onPressed: () {
                AppModalBottomSheet.showMainModalBottomSheet(
                  context: context,
                  scrollableContent: MediaPicker(
                    mediaList: selectedImage,
                    onPicked: (selectedList) {
                      Navigator.pop(context);
                      setState(() {
                        selectedImage = selectedList;
                      });
                    },
                    headerBuilder: (context, albumPicker, onDone, onCancel) {
                      return SizedBox(
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.clear)),
                            Expanded(child: Center(child: albumPicker)),
                            TextButton(
                                onPressed: onDone, child: Text(S.current.next)),
                          ],
                        ),
                      );
                    },
                    mediaCount: MediaCount.single,
                    mediaType: MediaType.image,
                    decoration: PickerDecoration(
                      albumTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                      albumTitleStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    ),
                  ),
                );
              },
            ),
            if (selectedImage.isNotEmpty)
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: AppColors.whiteColor.withOpacity(0.2),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedImage.clear();
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  DropdownSearch<CountryModel> _buildSearchNationality(BuildContext context) {
    return DropdownSearch<CountryModel>(
      itemAsString: (item) => item.title.toUpperCase() + " (${item.value})",
      items: AppData.countries,
      dropdownButtonProps: DropdownButtonProps(
          style: ButtonStyle(
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      )),
      validator: (val) =>
          val == null && AppData.isUserProfileNationalityRequired
              ? S.current.requiredField
              : null,
      onChanged: (value) {
        setState(() {
          userNationality = value;
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          labelText: S.current.nationality,
          hintText: S.current.nationality,
          labelStyle: TextStyle(),
        ),
      ),
      popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: S.current.search,
              fillColor: Colors.transparent,
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
                borderSide:
                    const BorderSide(color: AppColors.textFieldBorderLight),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )),
      selectedItem: userNationality,
      enabled: true,
      compareFn: (CountryModel a, CountryModel b) => a.value == b.value,
    );
  }
}
