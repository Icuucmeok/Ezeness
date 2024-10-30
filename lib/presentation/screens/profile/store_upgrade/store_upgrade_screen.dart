import 'package:collection/collection.dart';
import 'package:ezeness/data/models/app_file.dart';
import 'package:ezeness/data/models/upgrade_store_plan/upgrade_store_plan_body.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/widgets/wallet_balance_widget.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/widgets/top_up_wallet_header_widget.dart';
import 'package:ezeness/presentation/screens/profile/store_upgrade/widgets/store_upgrade_plan_widget.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

import '../../../../data/models/day_time.dart';
import '../../../../data/models/pay_item_body.dart';
import '../../../../data/models/pick_location_model.dart';
import '../../../../data/models/upgrade_store_plan/upgrade_store_plan.dart';
import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../logic/cubit/upgrade_store/upgrade_store_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../widgets/common/common.dart';
import '../about/about_screen.dart';

class StoreUpgradeScreen extends StatefulWidget {
  static const String routName = 'store_upgrade_screen';
  final args;
  const StoreUpgradeScreen({this.args, Key? key}) : super(key: key);

  @override
  State<StoreUpgradeScreen> createState() => _StoreUpgradeScreenState();
}

class _StoreUpgradeScreenState extends State<StoreUpgradeScreen> {
  bool isEditStore = false;
  bool isEditPlan = false;
  late PageController _pageController;

  final _storeOwnerDetailsKeyForm = GlobalKey<FormState>();
  final _storeDetailsKeyForm = GlobalKey<FormState>();
  final _bankDetailsKeyForm = GlobalKey<FormState>();
  final _licenceDetailsKeyForm = GlobalKey<FormState>();
  bool isAccept = false;

  TextEditingController ownerNameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController idExpiryDateController = TextEditingController();
  TextEditingController idIssueDateController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  TextEditingController storeNameController = TextEditingController();
  TextEditingController isDeliveryController = TextEditingController();
  TextEditingController deliveryRangeController = TextEditingController();
  PickLocationModel? pickLocation;
  bool locationError = false;
  checkLocationError() {
    if (pickLocation == null) {
      locationError = true;
    } else {
      locationError = false;
    }
    setState(() {});
  }

  TextEditingController bankHolderNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ibnController = TextEditingController();

  TextEditingController licenceNameController = TextEditingController();
  TextEditingController licenceNumberController = TextEditingController();
  TextEditingController licenceExpiryDateController = TextEditingController();
  TextEditingController licenceIssueDateController = TextEditingController();
  TextEditingController licenceRegistrationDateController =
      TextEditingController();
  bool licenceExpiryDateError = false;
  bool licenceIssueDateError = false;
  bool licenceRegistrationDateError = false;

  checkLicenceExpiryDateError() {
    if (licenceExpiryDateController.text.isEmpty) {
      licenceExpiryDateError = true;
    } else {
      licenceExpiryDateError = false;
    }
    setState(() {});
  }

  checkLicenceIssueDateError() {
    if (licenceIssueDateController.text.isEmpty) {
      licenceIssueDateError = true;
    } else {
      licenceIssueDateError = false;
    }
    setState(() {});
  }

  checkLicenceRegistrationDateError() {
    if (licenceRegistrationDateController.text.isEmpty) {
      licenceRegistrationDateError = true;
    } else {
      licenceRegistrationDateError = false;
    }
    setState(() {});
  }

  int selectedGender = Constants.maleKey;
  int? selectedPlanId;
  List<Media> idFrontImage = [];
  List<Media> idBackImage = [];
  List<Media> bankAccountImage = [];
  List<Media> licenceImage = [];
  List<DayTime> storeTiming = List.from(AppData().dayList);

  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  late UpgradeStoreCubit _upgradeStoreCubit;
  late PaymentCubit _paymentCubit;
  late ProfileCubit _profileCubit;
  List<UpgradeStorePlan> plans = [];
  late User user;
  late String currency;

  @override
  void initState() {
    currency = context.read<SessionControllerCubit>().getCurrency();

    _pageController = PageController();
    if (widget.args != null) {
      isEditStore = widget.args["isEditStore"] ?? false;
      isEditPlan = widget.args["isEditPlan"] ?? false;
    }
    user = context.read<AppConfigCubit>().getUser();
    _upgradeStoreCubit = context.read<UpgradeStoreCubit>();
    _paymentCubit = context.read<PaymentCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _upgradeStoreCubit.getPlan();
    if (user.gender != null) selectedGender = user.gender!;
    ownerNameController.text = user.name!;
    if (user.birthDate != null) {
      birthDateController.text = user.birthDate!;
    }
    if (user.bank != null) {
      setBankImage();
      bankNameController.text = user.bank!.bankName!;
      bankHolderNameController.text = user.bank!.name!;
      ibnController.text = user.bank!.ibn!;
    }
    if (user.identityCard != null) {
      setIdentityCardImage();
      if (user.identityCard!.number != null) {
        idNumberController.text = user.identityCard!.number!;
      }
      if (user.identityCard!.issueDate != null) {
        idIssueDateController.text = user.identityCard!.issueDate!;
      }
      if (user.identityCard!.expireDate != null) {
        idExpiryDateController.text = user.identityCard!.expireDate!;
      }
    }
    if (user.lat != null)
      pickLocation = PickLocationModel(
          lat: double.parse(user.lat!),
          lng: double.parse(user.lng!),
          location: user.address!);
    if (user.store == null) {
      storeNameController.text = user.name!;
    }
    if (user.store != null) {
      storeNameController.text = user.store!.name!;
      isDeliveryController.text =
          user.store!.deliveryRange == 0 ? "false" : "true";
      deliveryRangeController.text = user.store!.deliveryRange.toString();
      if (user.store?.storePlan != null) {
        selectedPlanId = user.store?.storePlan?.id;
      }
      if (user.store?.storeLicence != null) {
        setLicenceImage();
        licenceNumberController.text =
            user.store!.storeLicence!.commercialNumber!;
        licenceRegistrationDateController.text =
            user.store!.storeLicence!.registerDate!;
        licenceNameController.text = user.store!.storeLicence!.name!;
        licenceExpiryDateController.text =
            user.store!.storeLicence!.commercialExpiryDate!;
        licenceIssueDateController.text =
            user.store!.storeLicence!.commercialIssueDate!;
      }
      if (user.store?.shift != null) {
        for (DayTime e in user.store!.shift!) {
          DayTime temp =
              storeTiming.firstWhere((element) => element.id == e.id);
          temp.fromTime = e.fromTime;
          temp.toTime = e.toTime;
        }
      }
    }
    if (isEditStore) {
      _pageController = PageController(initialPage: 2);
    }
    super.initState();
  }

  setBankImage() async {
    bankAccountImage
        .add(Media(id: "0", file: await Helpers.urlToFile(user.bank!.file!)));
    setState(() {});
  }

  setLicenceImage() async {
    licenceImage.add(Media(
        id: "0",
        file: await Helpers.urlToFile(user.store!.storeLicence!.file!)));
    setState(() {});
  }

  setIdentityCardImage() async {
    if (user.identityCard!.backImage != null) {
      idBackImage.add(Media(
          id: "0",
          file: await Helpers.urlToFile(user.identityCard!.backImage!)));
    }
    if (user.identityCard!.frontImage != null) {
      idFrontImage.add(Media(
          id: "0",
          file: await Helpers.urlToFile(user.identityCard!.frontImage!)));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            _buildPlanPage(context),
            _buildPaymentPage(context),
            _buildSecondPage(context),
            _buildThirdPage(context),
            _buildForthPage(context),
            if (selectedPlanId != Constants.planPKey) _buildFifthPage(context),
            _buildTermsPage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              SizedBox(),
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<UpgradeStoreCubit, UpgradeStoreState>(
              bloc: _upgradeStoreCubit,
              listener: (context, state) {
                if (state is UpgradeStoreDone) {
                  AppSnackBar(
                          message: S.current.sentSuccessfully, context: context)
                      .showSuccessSnackBar();
                  _profileCubit.getMyProfile(context.read<AppConfigCubit>());
                  Navigator.pop(context);
                }
                if (state is UpgradeStoreFailure) {
                  ErrorHandler(exception: state.exception)
                      .showErrorSnackBar(context: context);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 20),
                      Text(
                        S.current.agreeTermsConditions,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        S.current.peopleUseServices,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.greyDark, fontSize: 18.sp),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AboutScreen.routName);
                            },
                            child: Text(
                              S.current.termsAndConditions,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0.005,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                            ),
                          ),
                          AppCheckBox(
                            value: isAccept,
                            onChange: () => setState(() {
                              isAccept = !isAccept;
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      CustomElevatedButton(
                        withBorderRadius: true,
                        isLoading: state is UpgradeStoreLoading,
                        margin: EdgeInsets.only(bottom: 30),
                        backgroundColor: AppColors.secondary,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!isAccept) {
                            AppSnackBar(
                                    message: S.current.accept +
                                        " " +
                                        S.current.termsAndConditions,
                                    context: context)
                                .showErrorSnackBar();
                            return;
                          }
                          List<AppFile> files = [];
                          if (idFrontImage.isNotEmpty) {
                            AppFile identityCardFrontFile = AppFile(
                                file: idFrontImage.first.file!,
                                fileKey: UpgradeStorePlanBody
                                    .identityCardFrontImageKey);
                            files.add(identityCardFrontFile);
                          }
                          if (idBackImage.isNotEmpty) {
                            AppFile identityCardBackFile = AppFile(
                                file: idBackImage.first.file!,
                                fileKey: UpgradeStorePlanBody
                                    .identityCardBackImageKey);
                            files.add(identityCardBackFile);
                          }

                          if (licenceImage.isNotEmpty) {
                            AppFile licenceFile = AppFile(
                                file: licenceImage.first.file!,
                                fileKey: UpgradeStorePlanBody.licenceImageKey);
                            files.add(licenceFile);
                          }
                          if (bankAccountImage.isNotEmpty) {
                            AppFile bankFile = AppFile(
                                file: bankAccountImage.first.file!,
                                fileKey: UpgradeStorePlanBody.bankImageKey);
                            files.add(bankFile);
                          }
                          UpgradeStorePlanBody body = UpgradeStorePlanBody(
                            ownerName: ownerNameController.text,
                            ownerGender: selectedGender.toString(),
                            ownerBirthDate: birthDateController.text,
                            storeTypeId: selectedPlanId.toString(),
                            storeName: storeNameController.text,
                            storeLat: pickLocation?.lat.toString(),
                            storeLng: pickLocation?.lng.toString(),
                            storeAddress: pickLocation?.location,
                            storeDeliveryRange:
                                isDeliveryController.text == "true"
                                    ? deliveryRangeController.text
                                    : "0",
                            identityCardNumber: idNumberController.text,
                            identityCardIssueDate: idIssueDateController.text,
                            identityCardExpireDate: idExpiryDateController.text,
                            licenceName: licenceNameController.text,
                            licenceCommercialNumber:
                                licenceNumberController.text,
                            licenceRegisterDate:
                                licenceRegistrationDateController.text,
                            licenceCommercialIssueDate:
                                licenceIssueDateController.text,
                            licenceCommercialExpiryDate:
                                licenceExpiryDateController.text,
                            bankHolderName: bankHolderNameController.text,
                            bankName: bankNameController.text,
                            bankIbn: ibnController.text,
                            shifts: storeTiming,
                          );
                          if (isEditStore) {
                            _upgradeStoreCubit.editStoreInfo(
                                body: body, files: files);
                          } else {
                            _upgradeStoreCubit.upgradeToStorePlan(
                                body: body, files: files);
                          }
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
                );
              }),
        ),
      ],
    );
  }

  Widget _buildFifthPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              Text(S.current.licenceName),
              TextButton(
                  onPressed: () {
                    checkLicenceExpiryDateError();
                    checkLicenceIssueDateError();
                    checkLicenceRegistrationDateError();
                    if (!_licenceDetailsKeyForm.currentState!.validate() ||
                        licenceExpiryDateError ||
                        licenceRegistrationDateError ||
                        licenceIssueDateError) {
                      return;
                    }
                    if (licenceImage.isEmpty) {
                      AppSnackBar(
                              message: S.current.pikeFiles, context: context)
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
            key: _licenceDetailsKeyForm,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  EditTextField(
                      controller: licenceNameController,
                      label: S.current.licenceName),
                  SizedBox(height: 10.h),
                  PickDate(
                      controller: licenceRegistrationDateController,
                      title: S.current.dateOfRegistration,
                      isError: licenceRegistrationDateError),
                  SizedBox(height: 10.h),
                  Text(S.current.commercialCard,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                  SizedBox(height: 10.h),
                  EditTextField(
                      controller: licenceNumberController, label: "ID"),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                          child: PickDate(
                              controller: licenceIssueDateController,
                              title: S.current.issueDate,
                              isError: licenceIssueDateError)),
                      SizedBox(width: 10.w),
                      Expanded(
                          child: PickDate(
                              controller: licenceExpiryDateController,
                              title: S.current.expiryDate,
                              isError: licenceExpiryDateError)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(S.current.uploadImages),
                  InkWell(
                    onTap: () {
                      AppModalBottomSheet.showMainModalBottomSheet(
                        context: context,
                        scrollableContent: MediaPicker(
                          mediaList: licenceImage,
                          onPicked: (selectedList) {
                            Navigator.pop(context);
                            setState(() {
                              licenceImage = selectedList;
                            });
                          },
                          headerBuilder:
                              (context, albumPicker, onDone, onCancel) {
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
                                      child: Text(S.current.next)),
                                ],
                              ),
                            );
                          },
                          mediaCount: MediaCount.single,
                          mediaType: MediaType.image,
                          decoration: PickerDecoration(
                            albumTextStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                            albumTitleStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            image: licenceImage.isNotEmpty
                                ? DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(licenceImage.first.file!),
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyLight.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Icon(
                                licenceImage.isNotEmpty
                                    ? Icons.edit
                                    : Icons.add,
                                color: AppColors.primaryColor),
                          ),
                        ),
                        Text(S.current.uploadFiles),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForthPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              Text(S.current.bankDetails),
              TextButton(
                  onPressed: () {
                    if (selectedPlanId != Constants.planPKey) {
                      if (!_bankDetailsKeyForm.currentState!.validate()) {
                        return;
                      }
                      if (bankAccountImage.isEmpty) {
                        AppSnackBar(
                                message: S.current.pikeFiles, context: context)
                            .showErrorSnackBar();
                        return;
                      }
                    }
                    nextPage();
                  },
                  child: Text(S.current.next)),
            ],
          ),
        ),
        Expanded(
          child: Form(
            key: _bankDetailsKeyForm,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  EditTextField(
                      controller: bankHolderNameController,
                      label: S.current.accountHolderName),
                  SizedBox(height: 10.h),
                  EditTextField(
                      controller: bankNameController,
                      label: S.current.bankName),
                  SizedBox(height: 10.h),
                  EditTextField(
                      controller: ibnController,
                      label: "IBN #",
                      isNumber: true),
                  SizedBox(height: 10.h),
                  Text(S.current.bankStatement,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                  SizedBox(height: 10.h),
                  Text(S.current.uploadImages),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          AppModalBottomSheet.showMainModalBottomSheet(
                            context: context,
                            scrollableContent: MediaPicker(
                              mediaList: bankAccountImage,
                              onPicked: (selectedList) {
                                Navigator.pop(context);
                                setState(() {
                                  bankAccountImage = selectedList;
                                });
                              },
                              headerBuilder:
                                  (context, albumPicker, onDone, onCancel) {
                                return SizedBox(
                                  height: 50.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: Icon(Icons.clear)),
                                      Expanded(
                                          child: Center(child: albumPicker)),
                                      TextButton(
                                          onPressed: onDone,
                                          child: Text(S.current.next)),
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                albumTitleStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                image: bankAccountImage.isNotEmpty
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(
                                            bankAccountImage.first.file!),
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.greyLight.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Icon(
                                    bankAccountImage.isNotEmpty
                                        ? Icons.edit
                                        : Icons.add,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            Text(S.current.uploadFiles),
                            if (bankAccountImage.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    bankAccountImage.clear();
                                  });
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (selectedPlanId == Constants.planPKey)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          bankHolderNameController.clear();
                          bankNameController.clear();
                          ibnController.clear();
                          bankAccountImage.clear();
                          setState(() {});
                          nextPage();
                        },
                        child: Text(S.current.skip),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThirdPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => previousPage(), child: Text(S.current.back)),
              Text(S.current.storeDetails),
              TextButton(
                  onPressed: () {
                    checkLocationError();
                    if (!_storeDetailsKeyForm.currentState!.validate() ||
                        locationError) {
                      return;
                    }
                    bool allStoreTimingNull = true;
                    for (var e in storeTiming) {
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
                    if (allStoreTimingNull) {
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
            key: _storeDetailsKeyForm,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  EditTextField(
                      controller: storeNameController,
                      label: S.current.storeName),
                  SizedBox(height: 10.h),
                  PickLocation(
                      initialLocation:
                          pickLocation != null ? pickLocation!.location : null,
                      isError: locationError,
                      onChange: (location) {
                        pickLocation = location;
                      }),
                  SizedBox(height: 10.h),
                  SelectButton(
                      icon: CupertinoIcons.calendar,
                      title: S.current.storeTiming,
                      onTap: () => AppModalBottomSheet.showDayTimeBottomSheet(
                          context: context, dayList: storeTiming)),
                  BoolSelect(
                      controller: isDeliveryController,
                      title: S.current.delivery,
                      onChange: () => setState(() {})),
                  if (isDeliveryController.text == "true")
                    EditTextField(
                        controller: deliveryRangeController,
                        label: S.current.deliveryRange,
                        isNumber: true,
                        suffixWidget: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("KM"),
                        )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isEditStore) ...{
                TextButton(
                    onPressed: () => previousPage(),
                    child: Text(S.current.back)),
              } else ...{
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.clear)),
              },
              Text(S.current.ownerDetails),
              TextButton(
                  onPressed: () {
                    if (!_storeOwnerDetailsKeyForm.currentState!.validate()) {
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
            key: _storeOwnerDetailsKeyForm,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
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
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            AppCheckBox(
                              value: selectedGender == Constants.femaleKey,
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
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  EditTextField(
                      controller: ownerNameController,
                      label: S.current.fullName),
                  SizedBox(height: 10.h),
                  PickDate(
                      controller: birthDateController,
                      title: S.current.birthdate,
                      isEmpty: true),
                  SizedBox(height: 10.h),
                  Text(S.current.identifyCard,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                  SizedBox(height: 10.h),
                  EditTextField(
                      controller: idNumberController,
                      label: "ID",
                      isEmpty: true),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                          child: PickDate(
                              controller: idIssueDateController,
                              title: S.current.issueDate,
                              isEmpty: true)),
                      SizedBox(width: 10.w),
                      Expanded(
                          child: PickDate(
                              controller: idExpiryDateController,
                              title: S.current.expiryDate,
                              isEmpty: true)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(S.current.identificationVerification,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                  SizedBox(height: 10.h),
                  Text(S.current.identifyCard + " (${S.current.images}) "),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          AppModalBottomSheet.showMainModalBottomSheet(
                            context: context,
                            scrollableContent: MediaPicker(
                              mediaList: idFrontImage,
                              onPicked: (selectedList) {
                                Navigator.pop(context);
                                setState(() {
                                  idFrontImage = selectedList;
                                });
                              },
                              headerBuilder:
                                  (context, albumPicker, onDone, onCancel) {
                                return SizedBox(
                                  height: 50.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: Icon(Icons.clear)),
                                      Expanded(
                                          child: Center(child: albumPicker)),
                                      TextButton(
                                          onPressed: onDone,
                                          child: Text(S.current.next)),
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                albumTitleStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                image: idFrontImage.isNotEmpty
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            FileImage(idFrontImage.first.file!),
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.greyLight.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Icon(
                                    idFrontImage.isNotEmpty
                                        ? Icons.edit
                                        : Icons.add,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            Text(S.current.frontImage),
                            if (idFrontImage.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    idFrontImage.clear();
                                  });
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () {
                          AppModalBottomSheet.showMainModalBottomSheet(
                            context: context,
                            scrollableContent: MediaPicker(
                              mediaList: idBackImage,
                              onPicked: (selectedList) {
                                Navigator.pop(context);
                                setState(() {
                                  idBackImage = selectedList;
                                });
                              },
                              headerBuilder:
                                  (context, albumPicker, onDone, onCancel) {
                                return SizedBox(
                                  height: 50.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: Icon(Icons.clear)),
                                      Expanded(
                                          child: Center(child: albumPicker)),
                                      TextButton(
                                          onPressed: onDone,
                                          child: Text(S.current.next)),
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                albumTitleStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                image: idBackImage.isNotEmpty
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            FileImage(idBackImage.first.file!),
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.greyLight.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Icon(
                                    idBackImage.isNotEmpty
                                        ? Icons.edit
                                        : Icons.add,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            Text(S.current.backImage),
                            if (idBackImage.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    idBackImage.clear();
                                  });
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentPage(BuildContext context) {
    UpgradeStorePlan? selectedPlan =
        plans.firstWhereOrNull((e) => e.id == selectedPlanId);
    Size size = MediaQuery.of(context).size;
    return ListView(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
        children: [
          SizedBox(
            height: 50.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => previousPage(),
                    child: Text(S.current.back)),
                if (!isEditPlan)
                  TextButton(
                    onPressed: () {
                      if (selectedPlanId == null) {
                        AppSnackBar(
                                message: S.current.selectToContinue,
                                context: context)
                            .showErrorSnackBar();
                        return;
                      }

                      nextPage();
                    },
                    child: Text(S.current.next),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Wallet Balance Widget
          if (user.wallet != null)
            WalletBalanceWidget(walletBalance: user.wallet ?? ''),
          SizedBox(height: 10),
          if (user.wallet != null) TopUpWalletHeaderWidget(_paymentCubit),

          SizedBox(height: 30),

          _buildRowItem(
            context,
            title: S.current.subTotal,
            amount: selectedPlan?.cost?.toString() ?? "",
          ),

          Divider(
            color: Theme.of(context).primaryColorDark,
          ),

          _buildRowItem(
            context,
            title: S.current.total,
            amount: selectedPlan?.cost.toString() ?? "",
          ),
          SizedBox(height: size.height * 0.05),
          CustomElevatedButton(
            margin: EdgeInsets.only(bottom: 10),
            // backgroundColor: AppColors.secondary,
            backgroundColor: (user.wallet == null ||
                        (num.tryParse(user.wallet!) ?? 0) <= 0) &&
                    (selectedPlan?.cost ?? 0) > 0
                ? AppColors.grey
                : AppColors.secondary,
            withBorderRadius: true,
            onPressed: (user.wallet == null ||
                        (num.tryParse(user.wallet!) ?? 0) <= 0) &&
                    (selectedPlan?.cost ?? 0) > 0
                ? null
                : () {
                    if (selectedPlanId == null) {
                      AppSnackBar(
                              message: S.current.selectToContinue,
                              context: context)
                          .showErrorSnackBar();
                      return;
                    }
                    if (user.usernamePlan != null &&
                        user.usernamePlan?.planId == selectedPlanId) {
                      AppSnackBar(
                              message: S.current.editToContinue,
                              context: context)
                          .showErrorSnackBar();
                      return;
                    }

                    nextPage();
                  },
            child: Text(
              S.current.pay,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
            ),
          )
        ]);
  }

  Widget _buildRowItem(BuildContext context,
      {required String title, required String amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 15.sp),
            ),
          ),
          Text(
            "${currency} ${Helpers.numberFormatter(double.tryParse(amount) ?? 0)}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15.sp,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanPage(BuildContext context) {
    return BlocConsumer<UpgradeStoreCubit, UpgradeStoreState>(
        bloc: _upgradeStoreCubit,
        listener: (context, state) {
          if (state is EditStorePlanDone) {
            AppSnackBar(message: S.current.editSuccessfully, context: context)
                .showSuccessSnackBar();
            _profileCubit.getMyProfile(context.read<AppConfigCubit>());
            Navigator.pop(context);
          }
          if (state is GetPlanLoaded) {
            plans = state.response.upgradeStorePlanList!;
          }
        },
        builder: (context, state) {
          if (state is GetPlanLoading) {
            return const CenteredCircularProgressIndicator();
          }
          if (state is GetPlanFailure) {
            return ErrorHandler(exception: state.exception).buildErrorWidget(
                context: context,
                retryCallback: () => _upgradeStoreCubit.getPlan());
          }
          return Column(
            children: [
              SizedBox(
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.clear)),
                    if (!isEditPlan)
                      TextButton(
                          onPressed: () {
                            if (selectedPlanId == null) {
                              AppSnackBar(
                                      message: S.current.selectToContinue,
                                      context: context)
                                  .showErrorSnackBar();
                              return;
                            }
                            // if (selectedPlanId != Constants.planPKey) {
                            //   UpgradeStorePlan selectedPlan = plans
                            //       .singleWhere((e) => e.id == selectedPlanId);
                            //   AppModalBottomSheet.showPayBottomSheet(
                            //       context: context,
                            //       items: [
                            //         PayItemBody(
                            //           name: selectedPlan.name!,
                            //           price: double.parse(
                            //               selectedPlan.cost.toString()),
                            //           quantity: 1,
                            //         )
                            //       ],
                            //       onDone: () {
                            //         nextPage();
                            //       });
                            // } else {
                            nextPage();
                            // }
                          },
                          child: Text(S.current.next)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                  child: Column(
                    children: [
                      // Title (header)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(100.r),
                            boxShadow: [Helpers.boxShadow(context)]),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        child: Text(
                          S.current.sellingOnline,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blackColor,
                                  ),
                        ),
                      ),

                      // suh-title
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 15),
                        child: Text(S.current.selectOnlineShopPlanOption),
                      ),
                      SizedBox(height: 50),

                      // Plan
                      StoreUpgradePlanWidget(
                        title: S.current.individualLicence,
                        onSelect: () {
                          setState(() {
                            selectedPlanId = Constants.planPKey;
                          });
                        },
                        titleChild: S.current.callUp + " + " + S.current.postUp,
                        subTitle: plans
                            .singleWhere((e) => e.id == Constants.planPKey)
                            .name
                            .toString(),
                        trailTitle: S.current.free,
                        index: 0,
                        selectedIndex:
                            selectedPlanId == Constants.planPKey ? 0 : 1,
                      ),

                      // button shown on edit
                      if (isEditPlan)
                        CustomElevatedButton(
                          isLoading: state is EditStorePlanLoading,
                          margin: EdgeInsets.only(bottom: 30),
                          backgroundColor: AppColors.primaryColor,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (user.store?.storePlan?.id != null &&
                                user.store?.storePlan?.id == selectedPlanId) {
                              AppSnackBar(
                                      message: S.current.editToContinue,
                                      context: context)
                                  .showErrorSnackBar();
                              return;
                            }
                            if (selectedPlanId != Constants.planPKey) {
                              UpgradeStorePlan selectedPlan = plans
                                  .singleWhere((e) => e.id == selectedPlanId);
                              AppModalBottomSheet.showPayBottomSheet(
                                  context: context,
                                  items: [
                                    PayItemBody(
                                      name: selectedPlan.name!,
                                      price: double.parse(
                                          selectedPlan.cost.toString()),
                                      quantity: 1,
                                    )
                                  ],
                                  onDone: () {
                                    _upgradeStoreCubit
                                        .editStorePlan(selectedPlanId!);
                                  });
                            } else {
                              _upgradeStoreCubit.editStorePlan(selectedPlanId!);
                            }
                          },
                          child: Text(S.current.confirm,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 15.sp, color: Colors.white)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
