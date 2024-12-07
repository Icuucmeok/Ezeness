import 'dart:math';

import 'package:flutter/material.dart';

class LightText8 extends StatelessWidget {
  final String text;
  final Color? color;
  const LightText8(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: color, fontSize: size.width * .02));
  }
}

class LightText10 extends StatelessWidget {
  final String text;
  final Color? color;
  const LightText10(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: color, fontSize: size.width * .025));
  }
}

class LightText12 extends StatelessWidget {
  final String text;
  final Color? color;
  const LightText12(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: color, fontSize: size.width * .035));
  }
}

class LightText14 extends StatelessWidget {
  final String text;
  final Color? color;
  const LightText14(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: color, fontSize: size.width * .04));
  }
}

class RegularText9 extends StatelessWidget {
  final String text;
  final Color? color;
  const RegularText9(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: color, fontSize: size.width * .03));
  }
}

class RegularText10 extends StatelessWidget {
  final String text;
  final Color? color;
  const RegularText10(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: color, fontSize: size.width * .03));
  }
}

class RegularText12 extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  const RegularText12(this.text, {Key? key, this.color, this.maxLines = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: maxLines,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: color, fontSize: size.width * .035));
  }
}

class RegularText14 extends StatelessWidget {
  final String text;
  final Color? color;
  const RegularText14(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textWidthBasis: TextWidthBasis.longestLine,
        textScaleFactor: ScaleSize.textScaleFactor(context),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: size.width * .04,
              color: color,
            ));
  }
}

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class RegularText16 extends StatelessWidget {
  final String text;
  final Color? color;
  const RegularText16(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 4,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: color, fontSize: size.width * .045));
  }
}

class RegularText18 extends StatelessWidget {
  final String text;
  final Color? color;
  const RegularText18(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: color, fontSize: size.width * .05));
  }
}

class MediumText12 extends StatelessWidget {
  final String text;
  final Color? color;
  const MediumText12(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: color, fontSize: size.width * .035));
  }
}

class MediumText14 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? alignment;
  const MediumText14(this.text, {Key? key, this.color, this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        textAlign: alignment,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: color, fontSize: size.width * .04));
  }
}

class MediumText16 extends StatelessWidget {
  final String text;
  final Color? color;
  const MediumText16(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: color, fontSize: size.width * .045));
  }
}

class SemiBoldText12 extends StatelessWidget {
  final String text;
  final Color? color;
  const SemiBoldText12(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: color, fontSize: size.width * .035));
  }
}

class SemiBoldText14 extends StatelessWidget {
  final String text;
  final Color? color;
  const SemiBoldText14(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: color, fontSize: size.width * .04));
  }
}

class SemiBoldText16 extends StatelessWidget {
  final String text;
  final Color? color;
  const SemiBoldText16(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: color, fontSize: size.width * .045));
  }
}

class BoldText12 extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  const BoldText12(this.text, {Key? key, this.color, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: maxLines ?? 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(color: color, fontSize: size.width * .035));
  }
}

class BoldText14 extends StatelessWidget {
  final String text;
  final Color? color;
  const BoldText14(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(color: color, fontSize: size.width * .04));
  }
}

class BoldText16 extends StatelessWidget {
  final String text;
  final Color? color;
  const BoldText16(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(color: color, fontSize: size.width * .045));
  }
}

class BoldText18 extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  const BoldText18(this.text, {Key? key, this.color, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(text,
        maxLines: maxLines ?? 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(color: color, fontSize: size.width * .045));
  }
}
