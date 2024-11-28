import 'package:ezeness/presentation/screens/get_user_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/pick_location_model.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../res/app_res.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({super.key});

  @override
  State<CurrentLocationWidget> createState() => _CurrentLocationWidgetState();
}

class _CurrentLocationWidgetState extends State<CurrentLocationWidget> {
  bool isActive = false;
  late SessionControllerCubit _sessionControllerCubit;
  PickLocationModel? currentLocation;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    currentLocation = _sessionControllerCubit.getCurrentLocation();
    isActive = currentLocation != null;
    super.initState();
  }

  Color color(BuildContext context) => isActive
      ? AppColors.secondary
      : Theme.of(context).brightness == Brightness.dark
          ? AppColors.whiteColor
          : AppColors.blackColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: (){
            if(isActive){
                Navigator.of(context).pushNamed(GetUserLocationScreen.routName,
                    arguments: {"isFilterLocation": true});
            }
          },
          child: Container(
            width: double.infinity,
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color(context)),
            ),
            child: Padding(
              padding: isActive
                  ? EdgeInsetsDirectional.only(end: 89, start: 20)
                  : EdgeInsetsDirectional.only(end: 20, start: 89),
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
                    isActive && currentLocation != null
                        ? currentLocation!.location
                        : S.current.locationIsOff,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.green, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: isActive ? 0 : null,
          start: isActive ? null : 0,
          top: -2.5,
          child:  GestureDetector(
            onTap: ()async{
              setState(() {
                isActive = !isActive;
              });
              await Future.delayed(const Duration(milliseconds: 600));
              if (currentLocation == null) {
                Navigator.of(context).pushNamed(GetUserLocationScreen.routName,
                    arguments: {"isFilterLocation": true});
              } else {
                _sessionControllerCubit.setCurrentLocation(null);
                _sessionControllerCubit.restartApp();
              }
              setState(() {
                isActive = !isActive;
              });
            },
            child: Container(
              width: 80,
              height: 83,
              decoration: BoxDecoration(
                color: color(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Icon(
                Icons.location_on,
                color: isActive
                    ? AppColors.whiteColor
                    : Theme.of(context).brightness == Brightness.dark
                        ? AppColors.blackColor
                        : AppColors.whiteColor,
              )),
            ),
          ),
        )
      ],
    );
  }
}
