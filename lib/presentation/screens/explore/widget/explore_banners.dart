import 'package:carousel_slider/carousel_slider.dart';
import 'package:ezeness/data/models/banner/banner.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';
import '../../../widgets/banner_widgets.dart';

class ExploreBanners extends StatefulWidget {
  final List<BannerModel> bannerList;
  const ExploreBanners(this.bannerList, {Key? key}) : super(key: key);

  @override
  State<ExploreBanners> createState() => _ExploreBannersState();
}

class _ExploreBannersState extends State<ExploreBanners> {
  @override
  Widget build(BuildContext context) {
    return Helpers.isTab(context)
        ? SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.bannerList.length,
                itemBuilder: (context, index) => BannerWidget(
                      width: 400,
                      banner: widget.bannerList[index],
                    )),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.05,
                enableInfiniteScroll: widget.bannerList.length > 1,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 15),
              ),
              items: widget.bannerList
                  .map((e) => BannerWidget(banner: e))
                  .toList(),
            ),
          );
  }
}
