import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../generated/l10n.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../res/app_res.dart';

class ChildLockWidget extends StatefulWidget {
  const ChildLockWidget();

  @override
  State<ChildLockWidget> createState() => _ChildLockWidgetState();
}

class _ChildLockWidgetState extends State<ChildLockWidget> {
  late SessionControllerCubit _sessionControllerCubit;
  int isKids = 0;
  bool isActive = false;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    isKids = _sessionControllerCubit.getIsKids();
    isActive = isKids == 1;
    super.initState();
  }

  Color color(BuildContext context) => isActive
      ? AppColors.secondary
      : Theme.of(context).brightness == Brightness.dark
          ? AppColors.whiteColor
          : AppColors.blackColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            isActive = !isActive;
          });
          await Future.delayed(const Duration(milliseconds: 600));
          if (isKids == 0) {
            _sessionControllerCubit.setIsKids(1);
          } else {
            _sessionControllerCubit.setIsKids(0);
          }
          _sessionControllerCubit.restartApp();
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 65,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.kidsLock,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              end: isActive ? 0 : null,
              start: isActive ? null : 0,
              top: -2.5,
              child: Container(
                width: 80,
                height: 70,
                decoration: BoxDecoration(
                  color: color(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Icon(
                  isActive ? IconlyBold.lock : IconlyBold.shield_fail,
                  color: isActive
                      ? AppColors.whiteColor
                      : Theme.of(context).brightness == Brightness.dark
                          ? AppColors.blackColor
                          : AppColors.whiteColor,
                )),
              ),
            )
          ],
        ));
  }
}

/*
class ChildLockWidget extends StatefulWidget {
  const ChildLockWidget({Key? key}) : super(key: key);

  @override
  State<ChildLockWidget> createState() => _ChildLockWidgetState();
}

class _ChildLockWidgetState extends State<ChildLockWidget> {
  late SessionControllerCubit _sessionControllerCubit;
  int isKids = 0;
  bool isActive = false;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    isKids = _sessionControllerCubit.getIsKids();
    isActive = isKids == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () async {
        setState(() {
          isActive = !isActive;
        });
        await Future.delayed(const Duration(milliseconds: 600));
        if (isKids == 0) {
          _sessionControllerCubit.setIsKids(1);
        } else {
          _sessionControllerCubit.setIsKids(0);
        }
        _sessionControllerCubit.restartApp();
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.darkBlue,
              boxShadow: [Helpers.boxShadow(context)],
              borderRadius:
                  BorderRadius.all(Radius.circular(.04 * size.width))),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                ],
              ),
              CustomAnimatedSwitchWidget(
                isActive: isActive,
                colorSwitched: AppColors.darkBlue,
                children: [
                  Container(
                    // color: Colors.green,
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        Assets.assetsImagesKidsIcon,
                        fit: BoxFit.fill,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(S.current.kidsMode,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: isActive
                                  ? AppColors.green
                                  : AppColors.whiteColor,
                              fontSize: 15)),
                  Spacer(),
                ],
              ),
              Container(
                padding: EdgeInsetsDirectional.only(
                    end: size.width * .025, top: size.width * .03),
                alignment: Alignment.centerRight,
                child: Icon(
                  isActive ? Icons.gpp_good : Icons.gpp_bad,
                  color: isActive ? AppColors.green : AppColors.whiteColor,
                  size: 35,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
