import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

class GiveStarReviews extends StatelessWidget {
  final List<GiveStarData> starData;
  final double spaceBetween;

  GiveStarReviews({required this.starData, this.spaceBetween = 17.0});

  @override
  Widget build(BuildContext context) {
    return _createList(this.starData, this.spaceBetween, context);
  }

  Widget _createList(
      List<GiveStarData> list, double space, BuildContext context) {
    List<Widget> tmp = <Widget>[];

    for (var x in list) {
      tmp.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            x.text,
            style: x.textStyle ??
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
          ),
          StarRating(
            value: x.value,
            starCount: x.starCount,
            onChanged: x.onChanged,
            filledStar: x.filledStar,
            unfilledStar: x.unfilledStar,
            size: x.size,
            spaceBetween: x.spaceBetween,
          ),
        ],
      ));
    }

    return Column(
        children: List.generate(list.length + list.length, (i) {
      if (i % 2 == 0) {
        return SizedBox(
          height: space,
        );
      }

      return tmp[i ~/ 2];
    }));
  }
}

class StarRating extends StatefulWidget {
  final void Function(int index)? onChanged;
  final int? value;
  final IconData? filledStar;
  final IconData? unfilledStar;
  final int starCount;
  final double size;
  final double spaceBetween;

  StarRating({
    Key? key,
    this.onChanged,
    this.value = 0,
    this.starCount = 5,
    this.filledStar,
    this.unfilledStar,
    this.spaceBetween = 3,
    this.size = 22,
  })  : assert(value != null),
        super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int value;

  @override
  void initState() {
    value = widget.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return GestureDetector(
          onTap: () {
            if (widget.onChanged != null) {
              setState(() {
                value = value == index + 1 ? index : index + 1;
              });
              widget.onChanged!.call(value);
            }
          },
          child: Container(
            padding:
                EdgeInsets.only(left: index == 0 ? 0 : widget.spaceBetween),
            child: Icon(
              widget.filledStar ?? Icons.star,
              color: index < value
                  ? AppColors.darkPrimary
                  : AppColors.greyTextColor.withOpacity(.2),
              size: widget.size,
            ),
          ),
        );
      }),
    );
  }
}

class GiveStarData {
  final String text;
  final TextStyle? textStyle;
  final void Function(int index)? onChanged;
  final int value;
  final int starCount;
  final IconData? filledStar;
  final IconData? unfilledStar;
  final double size;
  final double spaceBetween;
  final Color activeStarColor;
  final Color inactiveStarColor;

  GiveStarData(
      {required this.text,
      this.onChanged,
      this.textStyle,
      this.value = 0,
      this.starCount = 5,
      this.filledStar,
      this.unfilledStar,
      this.size = 25,
      this.spaceBetween = 5,
      this.activeStarColor = const Color(0xffffd900),
      this.inactiveStarColor = Colors.black54});
}
