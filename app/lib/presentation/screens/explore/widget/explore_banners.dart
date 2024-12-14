import 'package:carousel_slider/carousel_slider.dart';
import 'package:ezeness/data/models/banner/banner.dart';
import 'package:ezeness/data/models/post/post.dart';
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
  PostMedia? _createPostMedia(BannerModel banner) {
    if (banner.image != null) {
      return PostMedia(
        id: banner.id,  
        path: banner.image,  
        type: 'image',  
      );
    }
    return null;  
  }

  @override
  Widget build(BuildContext context) {
    return Helpers.isTab(context)
        ? SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.bannerList.length,
              itemBuilder: (context, index) {
                final banner = widget.bannerList[index];

                final media = _createPostMedia(banner);

                return BannerWidget(
                  width: 400,
                  banner: banner,
                  media: media!,  
                );
              },
            ),
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
              items: widget.bannerList.map((e) {
                final media = _createPostMedia(e);

                return BannerWidget(
                  banner: e,  
                  media: media!,  
                  width: null,  
                );
              }).toList(),
            ),
          );
  }
}
