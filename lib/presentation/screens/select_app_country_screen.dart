import 'package:dropdown_search/dropdown_search.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/country_model.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../res/app_res.dart';
import '../widgets/common/common.dart';
import 'auth/auth_screen.dart';
import 'get_user_location_screen.dart';
import 'home/home_screen.dart';
import 'onboarding_screen.dart';

class SelectAppCountryScreen extends StatefulWidget {
  static const String routName = 'select_app_country_screen';
  const SelectAppCountryScreen();

  @override
  State<SelectAppCountryScreen> createState() => _SelectAppCountryScreenState();
}

class _SelectAppCountryScreenState extends State<SelectAppCountryScreen> {
  bool isLoggedIn = false;
  late SessionControllerCubit _sessionControllerCubit;
  CountryModel? appCountry;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    isLoggedIn = _sessionControllerCubit.isLoggedIn();
    super.initState();
  }

  onDoneNavigate() {
    if (_sessionControllerCubit.getUserLocation() == null) {
      Navigator.of(context)
          .pushReplacementNamed(GetUserLocationScreen.routName);
    } else if (context.read<AppConfigCubit>().getIsFirstLaunch()) {
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routName);
    } else if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
    } else {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        SizedBox(
          width: 90,
          height: 35,
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? Assets.assetsImagesEzenessLogoDark
                : Assets.assetsImagesEzenessLogoLight,
          ),
        ),
        SizedBox(width: 15)
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(S.current.selectYourCountry,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            DropdownSearch<CountryModel>(
              itemAsString: (item) =>
                  item.title.toUpperCase() + " (${item.value})",
              items: AppData.countries,
              validator: (val) =>
                  val == null && AppData.isUserProfileNationalityRequired
                      ? S.current.requiredField
                      : null,
              onChanged: (value) {
                setState(() {
                  appCountry = value;
                });
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.textFieldBorderLight),
                      borderRadius: BorderRadius.circular(15)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.textFieldBorderLight),
                      borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.textFieldBorderLight),
                      borderRadius: BorderRadius.circular(15)),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.textFieldBorderLight),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  labelText: S.current.country,
                  hintText: S.current.country,
                  labelStyle: TextStyle(),
                ),
              ),
              popupProps: PopupProps.menu(
                  menuProps:
                      MenuProps(backgroundColor: Theme.of(context).canvasColor),
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
                          borderSide: const BorderSide(
                              color: AppColors.textFieldBorderLight),
                          borderRadius: BorderRadius.circular(15)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.textFieldBorderLight),
                          borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.textFieldBorderLight),
                          borderRadius: BorderRadius.circular(15)),
                      errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.textFieldBorderLight),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  )),
              selectedItem: appCountry,
              enabled: true,
              compareFn: (CountryModel a, CountryModel b) => a.value == b.value,
            ),
            const SizedBox(height: 50),
            CustomElevatedButton(
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
              backgroundColor: AppColors.secondary,
              withBorderRadius: true,
              borderColor: AppColors.shadowColor,
              onPressed: () {
                if (appCountry == null) {
                  AppSnackBar(
                          context: context,
                          message: S.current.selectYourCountry)
                      .showErrorSnackBar();
                  return;
                }
                _sessionControllerCubit.setAppCountry(appCountry);
                _sessionControllerCubit.setCurrency(
                    Helpers.getCurrencyFromCountryCode(appCountry!.value));
                onDoneNavigate();
              },
              child: Text(
                S.current.next,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
