import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageFullViewerWidget extends StatefulWidget {
  final int index;
  final List galleryItems;
  ImageFullViewerWidget({Key key, this.index, this.galleryItems})
      : pageController = PageController(initialPage: index);

  final PageController pageController;

  @override
  _ImageFullViewerWidegtState createState() => _ImageFullViewerWidegtState();
}

class _ImageFullViewerWidegtState extends State<ImageFullViewerWidget> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      // AssetImage(widget.galleryItems[index]),
      imageProvider: NetworkImage(widget.galleryItems[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      // heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.galleryItems.length,
            // loadingBuilder: widget.loadingBuilder,
            // backgroundDecoration: widget.backgroundDecoration,
            pageController: widget.pageController,
            onPageChanged: onPageChanged,
            // scrollDirection: widget.scrollDirection,
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "${currentIndex + 1}/${widget.galleryItems.length}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                decoration: null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
