import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:iconly/iconly.dart';

import '../../data/models/pick_location_model.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../res/app_res.dart';
import '../utils/app_dialog.dart';
import '../utils/helpers.dart';
import '../widgets/common/common.dart';
import 'auth/auth_screen.dart';
import 'home/home_screen.dart';
import 'onboarding_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserLocationScreen extends StatefulWidget {
  static const String routName = 'get_user_location_screen';
  final bool isFilterLocation;
  const GetUserLocationScreen({this.isFilterLocation = false, super.key});

  @override
  State<GetUserLocationScreen> createState() => _GetUserLocationScreenState();
}

class _GetUserLocationScreenState extends State<GetUserLocationScreen> {
  bool isLoggedIn = false;
  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    isLoggedIn = _sessionControllerCubit.isLoggedIn();
    super.initState();
  }

  onDoneNavigate() {
    if (widget.isFilterLocation) {
      _sessionControllerCubit.restartApp();
    } else {
      if (context.read<AppConfigCubit>().getIsFirstLaunch()) {
        Navigator.of(context).pushReplacementNamed(OnboardingScreen.routName);
      } else if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
      } else {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.current.getUserLocationTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(S.current.getUserLocationText,
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              // const Expanded(child: SizedBox()),
              // Expanded(
              //   flex: 8,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              //     decoration: BoxDecoration(
              //         color: Theme.of(context).brightness == Brightness.dark
              //             ? AppColors.backgroundGrey.withOpacity(0.2)
              //             : AppColors.backgroundGrey,
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Container(
              //           width: width / 2.7,
              //           height: height * 0.6,
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.circular(10),
              //             // border: Border.all(color: AppColors.primaryColor),
              //             image: DecorationImage(
              //               // fit: BoxFit.cover,
              //               image: AssetImage(
              //                 Theme.of(context).brightness == Brightness.dark
              //                     ? Assets.locationUserDark
              //                     : Assets.locationUser,
              //               ),
              //             ),
              //           ),
              //         ),
              //         Container(
              //           width: width / 2,
              //           height: height * 0.6,
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.circular(10),
              //             // border: Border.all(color: AppColors.primaryColor),
              //             image: DecorationImage(
              //               // fit: BoxFit.cover,
              //               image: AssetImage(
              //                 Theme.of(context).brightness == Brightness.dark
              //                     ? Assets.locationPostDark
              //                     : Assets.locationPost,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              const Expanded(child: SizedBox()),
              CustomElevatedButton(
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                backgroundColor: AppColors.primaryColor,
                withBorderRadius: true,
                onPressed: () async {
                  try {
                    bool serviceEnabled;
                    LocationPermission permission;

                    serviceEnabled =
                        await Geolocator.isLocationServiceEnabled();
                    if (!serviceEnabled) {
                      onTapSelectFromMap();
                      return;
                    }

                    permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        return;
                      }
                    }

                    if (permission == LocationPermission.deniedForever) {
                      onTapSelectFromMap();
                      return;
                    }
                    AppDialog.showLoadingDialog(context: context);
                    Position location = await Geolocator.getCurrentPosition();
                    String locationName =
                        await Helpers.getAddressFromLatLng(location);
                    PickLocationModel currentLocation = PickLocationModel(
                        lat: location.latitude,
                        lng: location.longitude,
                        location: locationName);
                    _sessionControllerCubit.setCurrentLocation(currentLocation);
                    _sessionControllerCubit.setUserLocation(currentLocation);
                    AppDialog.closeAppDialog();
                    onDoneNavigate();
                  } catch (_) {
                    AppDialog.closeAppDialog();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.location_searching_rounded,
                      color: AppColors.whiteColor,
                      size: 28,
                    ),
                    Text(
                      S.current.useCurrentLocation,
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    Icon(
                      Icons.location_searching_rounded,
                      color: AppColors.transparent,
                      size: 28,
                    ),
                  ],
                ),
              ),
              CustomElevatedButton(
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
                backgroundColor: AppColors.primaryColor,
                withBorderRadius: true,
                onPressed: () async {
                  onTapSelectFromMap();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.whiteColor,
                      size: 28,
                    ),
                    Text(
                      S.current.selectFromMap,
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.location_on,
                      color: AppColors.transparent,
                      size: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onTapSelectFromMap() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          GoogleMapController? mapController;
          bool isShowLocationServiceError = false;
          bool isShowLocationPermissionError = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            getMapCurrentLocation() async {
              bool serviceEnabled;
              LocationPermission permission;

              serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                setState(() {
                  isShowLocationServiceError = true;
                });
                return;
              } else {
                setState(() {
                  isShowLocationServiceError = false;
                });
              }

              permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {
                  return;
                }
              }

              if (permission == LocationPermission.deniedForever) {
                setState(() {
                  isShowLocationPermissionError = true;
                });
                return;
              } else {
                setState(() {
                  isShowLocationPermissionError = false;
                });
              }

              Position location = await Geolocator.getCurrentPosition();
              await mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(location.latitude, location.longitude),
                    zoom: 16,
                  ),
                ),
              );
            }

            Widget showError() {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                width: MediaQuery.sizeOf(context).width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isShowLocationPermissionError
                                ? S.current.locationPermanentlyDenied
                                : S.current.pleaseEnableLocationService,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: AppColors.whiteColor),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isShowLocationPermissionError
                                ? S.current.locationPermanentlyDeniedText
                                : S.current.locationServiceText,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (isShowLocationPermissionError) {
                          await Geolocator.openAppSettings();
                        } else if (isShowLocationServiceError) {
                          await Geolocator.openLocationSettings();
                        }
                        getMapCurrentLocation();
                      },
                      child: Text(S.current.enable,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              body: Stack(
                children: [
                  Theme(
                    data: Styles.lightTheme,
                    child: PlacePicker(
                      apiKey: Constants.googleMapKey,
                      onPlacePicked: (result) async {
                        PickLocationModel currentLocation = PickLocationModel(
                            lat: result.geometry!.location.lat,
                            lng: result.geometry!.location.lng,
                            location: result.formattedAddress.toString());
                        Navigator.of(context).pop();
                        _sessionControllerCubit
                            .setCurrentLocation(currentLocation);
                        _sessionControllerCubit
                            .setUserLocation(currentLocation);
                        onDoneNavigate();
                      },
                      useCurrentLocation: false,
                      resizeToAvoidBottomInset: false,
                      enableMyLocationButton: false,
                      enableMapTypeButton: false,
                      ignoreLocationPermissionErrors: true,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        getMapCurrentLocation();
                      },
                      initialPosition: LatLng(23.4241, 53.8478),
                    ),
                  ),
                  if (isShowLocationPermissionError ||
                      isShowLocationServiceError)
                    Positioned(
                      top: 115,
                      child: showError(),
                    ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (mapController != null) {
                              getMapCurrentLocation();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(IconlyBold.location, color: Colors.white),
                                const SizedBox(width: 4),
                                Text("Locate Me",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            if (widget.isFilterLocation) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } else {
                              onDoneNavigate();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.shadowColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Text(S.current.skip,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
