import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeNoticeBody extends StatefulWidget {
  @override
  _HomeNoticeBodyState createState() => _HomeNoticeBodyState();
}

final List<String> imgList = [
  "https://cdn.pixabay.com/photo/2020/09/01/06/10/lake-5534341__340.jpg",
  "https://cdn.pixabay.com/photo/2019/09/24/09/58/marrakech-4500910__340.jpg",
  "https://cdn.pixabay.com/photo/2019/12/02/07/07/autumn-4667080__340.jpg"
];

class _HomeNoticeBodyState extends State<HomeNoticeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Color(0xFFDF0F4),
        height: 150,
        child: Swiper(
          autoplay: true,
          pagination: SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: DotSwiperPaginationBuilder(
                  activeSize: 5, size: 5, activeColor: Colors.blueGrey)),
          itemCount: imgList.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(imgList[index], fit: BoxFit.fill);
          },
        ),
      ),
    );
  }
}
