import 'package:flutter/material.dart';

class PanelSettingNotificationWidget extends StatelessWidget {
  final String notificationText;
  final Color? notificationTextColor;
  final Color? notificationCountColor;
  final String notificationCount;
  final double? hSize;
  final double? wSize;
  final VoidCallback onTap;

  const PanelSettingNotificationWidget(
      {Key? key,
      required this.notificationText,
      required this.notificationCount,
      this.notificationTextColor,
      this.notificationCountColor,
      this.wSize,
      this.hSize,
      required this.onTap //if active set font color
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (onTap),
            child: Text(
              notificationText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    // fontFamily: 'Poppins',
                    color: notificationTextColor ??
                        Theme.of(context).primaryColorDark.withOpacity(0.7),
                    // color: textColor ?? Colors.grey.shade400,
                  ),
            ),
          ),
          GestureDetector(
            onTap: (onTap),
            child: Container(
              alignment: Alignment.center,
              height: hSize ?? 24,
              width: wSize ?? 70,
              decoration: BoxDecoration(
                // color: Colors.transparent,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.2),

                  // color: Colors.grey.shade700,
                ),
              ),
              child: Text(
                notificationCount,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: notificationCountColor ??
                          Theme.of(context).primaryColorDark.withOpacity(0.5),
                      // color: textColor ?? Colors.grey.shade700,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
