import 'dart:async';
import 'dart:ui';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:ezeness/data/models/country_model.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ezeness/data/models/pick_location_model.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/date_handler.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../../generated/l10n.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/bool_parsing.dart';
import '../../utils/text_input_formatter.dart';
import '../../utils/helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar(
      {Key? key, this.backgroundColor, this.title, this.leading, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: leading,
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: title,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ?? [],
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class CenteredCircularProgressIndicator extends StatelessWidget {
  const CenteredCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).scaffoldBackgroundColor,
      highlightColor: Colors.grey.shade500,
      child: Container(
        color: Colors.black,
        height: 500.h,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class MainButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const MainButton({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Constants.symmetricPadding,
          horizontal: Constants.mainPadding),
      width: MediaQuery.of(context).size.width - 50.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0.w),
          ),
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.all(Constants.symmetricPadding),
        ),
        child: child,
        onPressed: onTap,
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isError;
  final bool isEmpty;
  final Color? subtitleColor;

  const SelectButton({
    Key? key,
    this.onTap,
    this.isError = false,
    required this.icon,
    required this.title,
    this.isEmpty = false,
    this.subtitle,
    this.subtitleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: Constants.mainPadding / 4),
          padding: EdgeInsets.symmetric(horizontal: Constants.symmetricPadding),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: isError ? Colors.red : AppColors.textFieldBorderLight,
                width: 1.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 15.sp,
                    ),
                children: <TextSpan>[
                  TextSpan(text: title),
                  if (isEmpty)
                    TextSpan(
                      text: "   (${S.current.optional})",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.greyDark,
                            fontSize: 15.sp,
                          ),
                    ),
                ],
              ),
            ),
            subtitle: subtitle == null
                ? null
                : Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: subtitleColor ??
                              Theme.of(context).primaryColorDark,
                          fontSize: 15.sp,
                        ),
                  ),
            trailing: Icon(icon),
            onTap: onTap,
          ),
        ),
        // if (isError) ...{
        //   SizedBox(height: 4.h),
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 20.w),
        //     child: Text(S.current.requiredField, style: Styles.errorStyle),
        //   ),
        // },
      ],
    );
  }
}

class ChangeLanguageButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;
  final Color? color;

  final TextStyle? style;

  const ChangeLanguageButton(
      {Key? key, this.label, this.onTap, this.color, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0.w),
        ),
        backgroundColor: color,
        padding: EdgeInsets.all(10.w),
      ),
      child: Text(
        label!,
        style: style,
      ),
      onPressed: onTap,
    );
  }
}

/// Date Piker
class PickDate extends StatefulWidget {
  final TextEditingController controller;
  final String? title;
  final bool isEmpty;
  final bool withTime;
  final bool isError;
  final bool isBottomPicker;

  const PickDate({
    Key? key,
    this.isError = false,
    required this.controller,
    this.title,
    this.isEmpty = false,
    this.withTime = false,
    this.isBottomPicker = false,
  }) : super(key: key);

  @override
  State<PickDate> createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  var date;

  @override
  Widget build(BuildContext context) {
    date = widget.controller.text.isEmpty
        ? null
        : DateTime.parse(widget.controller.text);
    DateTime now = DateTime.now();
    void _showDatePicker(context) {
      showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
                height: 300.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkColor
                    : Colors.white,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: widget.controller.text.isEmpty
                        ? DateTime.now()
                        : DateTime.parse(widget.controller.text),
                    minimumDate: DateTime(1950),
                    maximumDate: DateTime(now.year + 10, now.month, now.day),
                    onDateTimeChanged: (val) {
                      setState(() {
                        widget.controller.text =
                            DateHandler(val.toString()).getDate();
                        date = date;
                      });
                    }),
              ));
    }

    return SelectButton(
      isEmpty: widget.isEmpty,
      isError: widget.isError,
      icon: widget.withTime ? CupertinoIcons.clock : CupertinoIcons.calendar,
      title: widget.title ?? S.current.selectDate,
      subtitle: date == null
          ? S.current.tapToSelectDate
          : "${intl.DateFormat.yMMMd().format(date)}${widget.withTime ? " - " + intl.DateFormat.Hm().format(date) : ""}",
      onTap: () {
        if (widget.isBottomPicker) {
          _showDatePicker(context);
        } else {
          showDatePicker(
            context: context,
            initialDate: widget.controller.text.isEmpty
                ? DateTime.now()
                : DateTime.parse(widget.controller.text),
            firstDate: DateTime(1950),
            lastDate: DateTime(now.year + 10, now.month, now.day),
            builder: (BuildContext context, Widget? child) {
              return Theme(data: ThemeData.dark(), child: child ?? Container());
            },
          ).then((date) {
            if (date == null) return;
            if (!widget.withTime) {
              setState(() {
                widget.controller.text = DateHandler(date.toString()).getDate();
                date = date;
              });
              return;
            }
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(widget.controller.text.isEmpty
                  ? DateTime.now()
                  : DateTime.parse(widget.controller.text)),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark(),
                  child: child!,
                );
              },
            ).then((time) {
              if (time == null) return;
              setState(() {
                var d = DateTime(
                    date!.year, date!.month, date!.day, time.hour, time.minute);
                widget.controller.text = d.toString();
                date = d;
              });
            });
          });
        }
      },
    );
  }
}

/// End

/// location Piker
class PickLocation extends StatefulWidget {
  final String? initialLocation;
  final String? title;
  final bool isError;
  final Function(PickLocationModel?)? onChange;

  const PickLocation({
    Key? key,
    this.isError = false,
    this.title,
    required this.onChange,
    this.initialLocation,
  }) : super(key: key);

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  String? location;

  @override
  void initState() {
    location = widget.initialLocation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectButton(
      isError: widget.isError,
      icon: CupertinoIcons.location_solid,
      title: widget.title ?? S.current.pickLocation,
      subtitle: location ?? S.current.tapToPickLocation,
      onTap: () async {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          AppSnackBar(
                  context: context,
                  onTap: () => Geolocator.openLocationSettings())
              .showLocationServiceDisabledSnackBar();
          return;
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          AppSnackBar(context: context).showLocationPermanentlyDeniedSnackBar();
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
                  setState(() {
                    double lat = result.geometry!.location.lat;
                    double lng = result.geometry!.location.lng;
                    location = result.formattedAddress;
                    widget.onChange?.call(PickLocationModel(
                        lat: lat, lng: lng, location: location!));
                  });

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
    );
  }
}

/// End

class BlurButton extends StatelessWidget {
  final Widget child;
  final double margin;
  final onTap;

  const BlurButton(
      {Key? key,
      required this.child,
      this.margin = Constants.mainPadding,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      // padding:EdgeInsets.all(Constants.mainPadding) ,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.w),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(Constants.symmetricPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.w),
                color: Colors.white.withOpacity(0.3),
              ),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class BlurContainer extends StatelessWidget {
  final Widget child;
  final double margin;
  final double? height;

  const BlurContainer(
      {Key? key, required this.child, this.margin = 10, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.all(margin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.w),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white.withOpacity(0.3),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CircleIcon extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final Color backColor;
  final onTap;
  final Color iconColor;

  const CircleIcon(
      {Key? key,
      this.icon,
      this.backColor = AppColors.whiteColor,
      this.iconData,
      required this.onTap,
      this.iconColor = AppColors.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 50.w,
        child: RawMaterialButton(
          onPressed: onTap,
          elevation: 2.0,
          fillColor: backColor,
          shape: const CircleBorder(),
          child: iconData == null
              ? SvgPicture.asset(
                  icon!,
                  width: 15.w,
                  height: 15.h,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              : Icon(iconData, color: iconColor, size: 18.sp),
        ),
      ),
    );
  }
}

class RoundedText extends StatelessWidget {
  final String text;
  final Color color;
  final bool isEnable;
  final onTap;

  const RoundedText(
      {Key? key,
      required this.text,
      this.color = AppColors.primaryColor,
      this.isEnable = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Constants.mainPadding / 4),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Constants.symmetricPadding),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: const Offset(0.0, 2.0),
                  blurRadius: 5.0,
                ),
              ],
              color: isEnable ? color : AppColors.whiteColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.borderRadius),
              )),
          child: Center(
              child: Text(text,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: isEnable
                          ? AppColors.whiteColor
                          : AppColors.primaryColor))),
        ),
      ),
    );
  }
}

/// bool select
class BoolSelect extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final VoidCallback? onChange;

  const BoolSelect(
      {Key? key, required this.controller, required this.title, this.onChange})
      : super(key: key);

  @override
  State<BoolSelect> createState() => _BoolSelectState();
}

class _BoolSelectState extends State<BoolSelect> {
  late bool checked;

  @override
  Widget build(BuildContext context) {
    checked = BoolParsing(widget.controller.text).toBool();
    return CheckboxListTile(
        activeColor: AppColors.primaryColor,
        contentPadding: EdgeInsets.zero,
        title: Text(widget.title),
        value: checked,
        onChanged: (v) {
          if (widget.onChange != null) {
            widget.onChange!();
          }
          setState(() {
            checked = v!;
            widget.controller.text = checked.toString();
          });
        });
  }
}

/// End

class ColumnSection extends StatelessWidget {
  final String title;
  final String body;
  final bool isBoldTitle;

  const ColumnSection(
      {Key? key,
      required this.title,
      required this.body,
      this.isBoldTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: isBoldTitle
                  ? Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.white)
                      .copyWith(color: AppColors.primaryColor)
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.primaryColor)),
          Expanded(
              child: Text(body,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.textColor),
                  overflow: TextOverflow.clip)),
        ],
      ),
    );
  }
}

class RowSection extends StatelessWidget {
  final String title;
  final String body;
  final Color? bodyColor;
  final bool isBoldTitle;

  const RowSection(
      {Key? key,
      required this.title,
      required this.body,
      this.isBoldTitle = true,
      this.bodyColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title,
              style: isBoldTitle
                  ? Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.white)
                      .copyWith(color: AppColors.greyDark, fontSize: 15.sp)
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.greyDark, fontSize: 15.sp)),
          SizedBox(width: 30.w),
          Text(body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: bodyColor ?? AppColors.textColor, fontSize: 15.sp)),
        ],
      ),
    );
  }
}

class AppCheckBox extends StatelessWidget {
  final bool value;
  final VoidCallback onChange;

  const AppCheckBox({Key? key, required this.onChange, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: Colors.white,
      fillColor: WidgetStateProperty.all(
          value ? AppColors.primaryColor : Colors.transparent),
      shape: const CircleBorder(),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          width: 2.0.w,
          color: AppColors.primaryColor,
        ),
      ),
      value: value,
      onChanged: (value) {
        onChange();
      },
    );
  }
}

class TitleIconRowSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? titleColor;
  final bool isBoldTitle;
  final VoidCallback? onIconTap;
  final Color iconColor;

  const TitleIconRowSection(
      {Key? key,
      required this.title,
      this.onIconTap,
      required this.icon,
      this.isBoldTitle = false,
      this.titleColor,
      this.iconColor = AppColors.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          title,
          style: isBoldTitle
              ? Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.white)
                  .copyWith(color: titleColor ?? AppColors.textColor)
              : Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: titleColor ?? AppColors.textColor),
          overflow: TextOverflow.clip,
        )),
        SizedBox(width: 10.w),
        IconButton(onPressed: onIconTap, icon: Icon(icon, color: iconColor)),
      ],
    );
  }
}

class EmptyCard extends StatelessWidget {
  final bool withIcon;
  final String? massage;
  const EmptyCard({this.withIcon = true, this.massage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (withIcon) ...{
            SvgPicture.asset(
              Assets.assetsIconsEmpty,
              fit: BoxFit.cover,
              width: 150.w,
            ),
            SizedBox(height: 15.h),
          },
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Text(
              massage ?? S.current.no_data_to_display,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class GuestCard extends StatelessWidget {
  const GuestCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                S.current.youHaveToSignInFirst,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),
            CustomElevatedButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                context.read<SessionControllerCubit>().goToSigInScreen();
              },
              child: Text(S.current.signIn,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 15.sp, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

///start
class SearchEditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final onChange;
  final bool isNumber;
  const SearchEditTextField({
    Key? key,
    required this.controller,
    this.label,
    required this.onChange,
    this.isNumber = false,
  }) : super(key: key);

  @override
  State<SearchEditTextField> createState() => _SearchEditTextFieldState();
}

class _SearchEditTextFieldState extends State<SearchEditTextField> {
  bool isRtlText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: isRtlText ? TextDirection.rtl : TextDirection.ltr,
      keyboardType: widget.isNumber ? TextInputType.number : null,
      inputFormatters: widget.isNumber
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      autofocus: true,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.textFieldBorderLight)),
        prefixIcon: Icon(IconlyLight.search),
        hintText: widget.label ?? S.current.exploreEzeness,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.primaryColor),
      ),
      controller: widget.controller,
      onChanged: (v) {
        widget.onChange(v);
        setState(() {
          isRtlText = Helpers.isRtlText(v);
        });
      },
      enableInteractiveSelection: true,
      contextMenuBuilder:
          (BuildContext context, EditableTextState editableTextState) {
        return AdaptiveTextSelectionToolbar(
          anchors: editableTextState.contextMenuAnchors,
          children: editableTextState.contextMenuButtonItems
              .map((ContextMenuButtonItem buttonItem) {
            return CupertinoButton(
              borderRadius: null,
              color: (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark
                  : AppColors
                      .whiteColor), // Here you can change the background color
              disabledColor: Colors.green,
              onPressed: buttonItem.onPressed,
              padding: const EdgeInsets.all(10.0),
              pressedOpacity: 0.7,
              child: SizedBox(
                // width: 50.0,
                child: Text(
                  CupertinoTextSelectionToolbarButton.getButtonLabel(
                    context,
                    buttonItem,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            );
          }).toList(),
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
    );
  }
}

///end
///start
class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? countryCodeController;
  final String label;
  final String? hintText;
  final bool isNumber;
  final bool isPass;
  final bool isEmpty;
  final bool isDecimal;
  final bool isReadOnly;
  final bool withCountryCodePicker;
  final bool withBorder;
  final bool showMaxLengthNumber;
  final String? Function(String? value)? validator;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final double? verticalPadding;
  final double? horizontalMargin;
  final Widget? suffixWidget;
  final VoidCallback? onSave;
  final VoidCallback? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  const EditTextField({
    Key? key,
    this.hintText,
    this.suffixWidget,
    this.minLine,
    this.isReadOnly = false,
    this.validator,
    this.horizontalMargin,
    this.verticalPadding,
    this.maxLine,
    required this.controller,
    required this.label,
    this.showMaxLengthNumber = true,
    this.isPass = false,
    this.isDecimal = false,
    this.isNumber = false,
    this.isEmpty = false,
    this.withBorder = true,
    this.withCountryCodePicker = false,
    this.countryCodeController,
    this.maxLength,
    this.onSave,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  bool isRtlText = false;
  late bool isPass;

  @override
  void initState() {
    isPass = widget.isPass;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CountryModel? appCountry =
        context.read<SessionControllerCubit>().getAppCountry();
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.isReadOnly,
      obscureText: isPass,
      onSaved: widget.onSave == null
          ? null
          : (e) {
              widget.onSave!();
            },
      maxLength: widget.maxLength,
      maxLines: widget.maxLine ?? 1,
      minLines: widget.minLine ?? 1,
      keyboardType: widget.isNumber ? TextInputType.number : null,
      inputFormatters: widget.inputFormatters != null
          ? widget.inputFormatters
          : <TextInputFormatter>[
              if (widget.isNumber && !widget.isDecimal)
                FilteringTextInputFormatter.digitsOnly,
              if (widget.isNumber && widget.isDecimal)
                DecimalTextInputFormatter()
            ],
      textDirection: isRtlText ? TextDirection.rtl : TextDirection.ltr,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: AppColors.primaryColor,
      validator: widget.validator ??
          (widget.isEmpty
              ? null
              : (value) {
                  if (value != null && value.trim().isEmpty) {
                    return S.current.requiredField;
                  }
                  return null;
                }),
      decoration: InputDecoration(
        counterText: widget.showMaxLengthNumber ? null : "",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hintText,
        suffixIcon: widget.suffixWidget ??
            (!widget.isPass
                ? null
                : FittedBox(
                    child: IconButton(
                      icon: Icon(
                          isPass ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.primaryColor),
                      onPressed: () {
                        setState(() {
                          isPass = !isPass;
                        });
                      },
                    ),
                  )),
        prefixIcon: !widget.withCountryCodePicker
            ? null
            : FittedBox(
                child: CountryCodePicker(
                initialSelection: widget.countryCodeController!.text.isNotEmpty
                    ? widget.countryCodeController!.text
                    : appCountry == null
                        ? "AE"
                        : "${appCountry.value}",
                dialogBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                barrierColor: Colors.black.withOpacity(0.5),
                onInit: (CountryCode? countryCode) {
                  if (countryCode != null) {
                    widget.countryCodeController!.text =
                        countryCode.dialCode.toString();
                  }
                },
                onChanged: (value) {
                  setState(() {
                    widget.countryCodeController?.text = value.toString();
                    widget.countryCodeController?.text !=
                        widget.countryCodeController?.text;
                  });
                },
                flagDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                ),
              )),
        label: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 15.sp,
                ),
            children: [
              TextSpan(text: widget.label),
              if (widget.isEmpty && !widget.isReadOnly)
                TextSpan(
                  text: "   (${S.current.optional})",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyDark,
                        fontSize: 15.sp,
                      ),
                ),
            ],
          ),
        ),
        filled: true,
        fillColor: Colors.transparent,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
              BorderSide(color: AppColors.textFieldBorderLight, width: 1.w),
        ),
        enabledBorder: widget.withBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: AppColors.textFieldBorderLight, width: 1.w),
              )
            : InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
            horizontal: Constants.mainPadding,
            vertical: widget.verticalPadding ?? 15),
        border: widget.withBorder
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(15))
            : InputBorder.none,
      ),
      controller: widget.controller,
      onChanged: (v) {
        if (widget.onChanged != null) {
          widget.onChanged!();
        }
        setState(() {
          isRtlText = Helpers.isRtlText(v);
        });
      },
      enableInteractiveSelection: true,
      contextMenuBuilder:
          (BuildContext context, EditableTextState editableTextState) {
        return AdaptiveTextSelectionToolbar(
          anchors: editableTextState.contextMenuAnchors,
          children: editableTextState.contextMenuButtonItems
              .map((ContextMenuButtonItem buttonItem) {
            return CupertinoButton(
              borderRadius: null,
              color: (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark
                  : AppColors
                      .whiteColor), // Here you can change the background color
              disabledColor: Colors.green,
              onPressed: buttonItem.onPressed,
              padding: const EdgeInsets.all(10.0),
              pressedOpacity: 0.7,
              child: SizedBox(
                // width: 50.0,
                child: Text(
                    CupertinoTextSelectionToolbarButton.getButtonLabel(
                      context,
                      buttonItem,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            );
          }).toList(),
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
    );
  }
}

///end
class CustomElevatedButton extends StatelessWidget {
  final Widget? child;
  final bool isLoading;
  final double borderRadius;
  final bool withBorderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final Function()? onPressed;
  final Function()? onLongPress;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const CustomElevatedButton({
    Key? key,
    this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 30,
    this.withBorderRadius = true,
    this.padding,
    this.onPressed,
    this.onLongPress,
    this.margin,
    this.isLoading = false,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          padding: padding ?? EdgeInsets.all(8.w),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(withBorderRadius ? borderRadius : 5),
            side: BorderSide(color: borderColor ?? AppColors.primaryColor),
          ),
          elevation: 0.0,
          shadowColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : onPressed,
        onLongPress: onLongPress,
        child: isLoading
            ? const FittedBox(child: CenteredCircularProgressIndicator())
            : child,
      ),
    );
  }
}

class MoreIconButton extends StatelessWidget {
  final IconData icon;
  final String? value;
  final double? size;
  final double verticalPadding;
  final double horizontalPadding;
  final VoidCallback onTapIcon;
  final bool canGustTap;
  final Color? color;
  final bool withBorder;

  const MoreIconButton({
    Key? key,
    required this.icon,
    this.value,
    this.size,
    required this.onTapIcon,
    this.verticalPadding = 0,
    this.horizontalPadding = 12,
    this.canGustTap = false,
    this.color,
    this.withBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: !isLoggedIn && !canGustTap ? Helpers.onGustTapButton : onTapIcon,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: !withBorder ? null : EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: !withBorder
                    ? null
                    : Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                      ),
              ),
              child: Icon(
                icon,
                size: size ?? 23,
                color: color ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.whiteColor
                        : AppColors.blackColor),
              ),
            ),
            if (value != null) ...{
              SizedBox(height: 5),
              Text(
                value!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: color ??
                          (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.whiteColor
                              : AppColors.blackColor),
                    ),
              ),
            }
          ],
        ),
      ),
    );
  }
}

class IconTextVerticalButton extends StatelessWidget {
  final IconData icon;
  final String? number;
  final double? size;
  final double verticalPadding;
  final double horizontalPadding;
  final VoidCallback onTapIcon;
  final VoidCallback? onLongPressIcon;
  final VoidCallback? onTapText;
  final bool canGustTap;
  final Color? iconColor;

  const IconTextVerticalButton({
    Key? key,
    required this.icon,
    this.number,
    this.size,
    required this.onTapIcon,
    this.verticalPadding = 3,
    this.horizontalPadding = 0,
    this.onTapText,
    this.canGustTap = false,
    this.iconColor,
    this.onLongPressIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: onLongPressIcon,
            onTap: !isLoggedIn && !canGustTap
                ? Helpers.onGustTapButton
                : onTapIcon,
            child: Icon(
              icon,
              size: size ?? 30,
              color: iconColor ?? AppColors.whiteColor.withOpacity(0.8),
              shadows: const [
                Shadow(
                    color: Colors.black45,
                    offset: Offset(1, 1),
                    blurRadius: 1.1),
              ],
            ),
          ),
          if (number != null)
            GestureDetector(
              onTap: !isLoggedIn && !canGustTap
                  ? Helpers.onGustTapButton
                  : onTapText,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.transparent,
                child: Text(
                  number!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 1),
                          blurRadius: 1.1),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class IconTextHorizontalButton extends StatelessWidget {
  final IconData icon;
  final String? number;
  final double? size;
  final double verticalPadding;
  final VoidCallback onTapIcon;
  final VoidCallback? onTapText;
  final VoidCallback? onLongPressIcon;
  final bool canGustTap;
  final Color? iconColor;
  const IconTextHorizontalButton({
    Key? key,
    required this.icon,
    this.number,
    this.size,
    required this.onTapIcon,
    this.verticalPadding = 8,
    this.onTapText,
    this.canGustTap = false,
    this.iconColor,
    this.onLongPressIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: onLongPressIcon,
            onTap: !isLoggedIn && !canGustTap
                ? Helpers.onGustTapButton
                : onTapIcon,
            child: Icon(
              icon,
              size: size ?? 30,
              color: iconColor,
            ),
          ),
          if (number != null) ...{
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: !isLoggedIn && !canGustTap
                  ? Helpers.onGustTapButton
                  : onTapText,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                color: Colors.transparent,
                child: Text(number!),
              ),
            ),
          },
        ],
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool? isIcon;
  final String labelText;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderRadius;
  final bool withBorderRadius;
  final Color? shadowColor;
  final Alignment? alignment;
  final double? hSize;
  final double? wSize;

  const CustomOutlineButton({
    Key? key,
    this.onPressed,
    this.icon,
    this.isIcon,
    this.borderRadius = 30,
    this.withBorderRadius = false,
    required this.labelText,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.shadowColor,
    this.alignment,
    this.hSize,
    this.wSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hSize ?? 60.0,
      width: wSize ?? 100.0,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          alignment: alignment ?? Alignment.center,
          backgroundColor: bgColor ?? Colors.blue,
          elevation: 0.1,
          shadowColor:
              shadowColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
          side: BorderSide(
            color: borderColor ??
                Theme.of(context).primaryColorDark.withOpacity(0.5),
            width: 1.0.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(withBorderRadius ? borderRadius : 5.0),
            ),
          ),
        ),
        child: Text(
          labelText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12.0.sp,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.white,
              ),
        ),
      ),
    );
  }
}

class ViewAllIconHeader extends StatelessWidget {
  final String leadingText;
  final VoidCallback? onNavigate;
  final VoidCallback? onAdd;
  final bool withIcon;
  final IconData? icon;
  final EdgeInsets? margin;

  const ViewAllIconHeader({
    Key? key,
    required this.leadingText,
    this.withIcon = true,
    this.onNavigate,
    this.icon,
    this.onAdd,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigate,
      child: Container(
        margin: margin ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.blackText
              : AppColors.shadowColor,
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                color: Theme.of(context).primaryColorDark.withOpacity(0.1),
                blurRadius: 3.0,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsetsDirectional.only(
                    start: 40.0.w, top: 10.0.h, bottom: 10.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkColor
                      : Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.6),
                  borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(10),
                  ),
                ),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  leadingText.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Expanded(
              child: withIcon
                  ? onAdd != null
                      ? GestureDetector(
                          onTap: onAdd,
                          child: Align(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.0.w, vertical: 5.0.h),
                              height: 30.h,
                              width: 30.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 6.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentShadowColor,
                                    offset: Offset(0, 3),
                                    blurRadius: 6.r,
                                  ),
                                ],
                              ),
                              child: Container(
                                height: 25.h,
                                width: 25.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 15.r,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                          ),
                        )
                      : Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0.w, vertical: 5.0.h),
                            child: Icon(
                              icon != null
                                  ? icon
                                  : Helpers.isRTL(context)
                                      ? IconlyLight.arrow_left
                                      : IconlyLight.arrow_right,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  final Color? shadowTopColor;
  final Color? shadowBottomColor;

  const Logo({Key? key, this.shadowTopColor, this.shadowBottomColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "EZENESS",
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        letterSpacing: 1,
        fontSize: 38,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins",
        shadows: [
          Shadow(
            color: shadowTopColor ?? Colors.lightBlue,
            offset: const Offset(-1, -1),
          ),
          Shadow(
            color: shadowBottomColor ?? Colors.lightBlue,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}

class ImageIconButton extends StatelessWidget {
  final String imageIcon;
  final VoidCallback? onTap;
  final double? hSize;
  final double? wSize;

  const ImageIconButton(
      {Key? key, required this.imageIcon, this.onTap, this.hSize, this.wSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onTap),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 0.0),
        height: hSize ?? 28,
        width: wSize ?? 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade800,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(imageIcon),
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    this.color,
  }) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w.w),
      child: Navigator.canPop(context)
          ? IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_outlined))
          : SizedBox(),
    );
  }
}

class LabelWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTapRemove;

  const LabelWidget({Key? key, required this.title, this.onTapRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white)),
          if (onTapRemove != null) ...{
            SizedBox(width: 10.w),
            IconButton(
                onPressed: onTapRemove,
                icon: Icon(Icons.clear, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 15,
                splashRadius: 25),
          }
        ],
      ),
    );
  }
}

class AppDropDownButton<T> extends StatelessWidget {
  final double? height;
  final T? value;
  final TextStyle? style;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value)? onChanged;
  final String? Function(T? value)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? iconColor;
  final Color fillColor;
  final double horizontalMargin;
  final double verticalMargin;

  const AppDropDownButton({
    Key? key,
    this.height,
    this.onChanged,
    this.style,
    this.contentPadding,
    this.hintText,
    this.hintStyle,
    this.value,
    required this.items,
    this.validator,
    this.iconColor,
    this.fillColor = Colors.transparent,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(7);
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
      child: DropdownButtonFormField<T>(
        value: value,
        focusColor: Colors.transparent,
        items: items,
        onChanged: onChanged,
        validator: validator,
        hint: Text(hintText ?? '',
            style: hintStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textColor)),
        icon: Icon(Icons.keyboard_arrow_down_outlined,
            size: 25.sp, color: iconColor ?? AppColors.primaryColor),
        isExpanded: true,
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          isDense: true,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorStyle: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.red),
          border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: borderRadius),
          disabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: borderRadius),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorderLight),
              borderRadius: borderRadius),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: borderRadius),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textFieldBorderLight),
            borderRadius: borderRadius,
          ),
        ),
        // dropdownColor: Theme.of(context).brightness == Brightness.dark
        //     ? AppColors.darkColor
        //     : null,
      ),
    );
  }
}

class BottomSheetDropDown<T> extends StatelessWidget {
  final double? height;
  final T? value;
  final TextStyle? style;
  final List<Widget> items;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final String? title;
  final TextStyle? hintStyle;
  final Color? iconColor;
  final Color fillColor;
  final double horizontalMargin;
  final double verticalMargin;
  final bool isLoading;

  const BottomSheetDropDown({
    Key? key,
    this.height,
    this.style,
    this.contentPadding,
    this.hintText,
    this.hintStyle,
    this.value,
    required this.title,
    required this.items,
    this.iconColor,
    this.fillColor = Colors.transparent,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(7);
    return InkWell(
      onTap: isLoading
          ? null
          : () {
              AppModalBottomSheet.showMainModalBottomSheet(
                  context: context,
                  scrollableContent: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items,
                    ),
                  ));
            },
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin, vertical: verticalMargin),
        padding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.textFieldBorderLight),
            borderRadius: borderRadius,
            color: fillColor),
        child: isLoading
            ? SizedBox(height: 30, child: ShimmerLoading())
            : Row(
                children: [
                  Expanded(
                      child: value == null || title == null
                          ? Text(hintText ?? '',
                              style: hintStyle ??
                                  Theme.of(context).textTheme.bodyLarge)
                          : Text(title.toString(),
                              style: style ??
                                  Theme.of(context).textTheme.bodyLarge)),
                  Icon(Icons.keyboard_arrow_down_outlined,
                      size: 25.sp, color: iconColor ?? AppColors.primaryColor),
                ],
              ),
      ),
    );
  }
}

class DeBouncer {
  late VoidCallback action;
  Timer? _timer;

  DeBouncer();

  run(int seconds, VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(seconds: seconds), action);
  }

  dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(AppRouter.mainContext).pushNamed(SearchScreen.routName);
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(left: 8, right: 8, top: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.blackColor
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyDark),
        ),
        child: Row(
          children: [
            Icon(IconlyLight.search, color: AppColors.greyDark),
            SizedBox(width: 8.w),
            Text(S.current.exploreEzeness.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.greyDark)),
          ],
        ),
      ),
    );
  }
}

//FIRST VERSION EDITS
class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Coming Soon",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey)));
  }
}

/// Color Piker
class ColorPiker extends StatefulWidget {
  final String? initialValue;
  final String? title;
  final bool isEmpty;
  final bool isError;
  final ValueChanged<Color> onTap;

  const ColorPiker({
    Key? key,
    this.isError = false,
    this.initialValue,
    this.title,
    this.isEmpty = false,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ColorPiker> createState() => _ColorPikerState();
}

class _ColorPikerState extends State<ColorPiker> {
  Color? pickerColor;
  @override
  void initState() {
    pickerColor = widget.initialValue == null ||
            widget.initialValue == "null" ||
            widget.initialValue == ""
        ? null
        : widget.initialValue!.toColor()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectButton(
      isEmpty: widget.isEmpty,
      isError: widget.isError,
      icon: CupertinoIcons.paintbrush,
      title: widget.title ?? S.current.colors,
      subtitle: pickerColor == null
          ? S.current.tapToSelect
          : pickerColor!.toHexString(),
      subtitleColor: pickerColor,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor ?? AppColors.primaryColor,
                    onColorChanged: (c) {
                      pickerColor = c;
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(S.current.confirm),
                    onPressed: () {
                      if (pickerColor != null) widget.onTap(pickerColor!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}

/// End