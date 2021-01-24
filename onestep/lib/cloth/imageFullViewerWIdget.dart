import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:onestep/PermissionLib/customPermisson.dart';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageFullViewerWidget extends StatefulWidget {
  final int index;
  final List galleryItems;
  ImageFullViewerWidget({Key key, this.index, this.galleryItems})
      : pageController = PageController(initialPage: index);

  final PageController pageController;

  @override
  _ImageFullViewerWidegtState createState() => _ImageFullViewerWidegtState();
}

class _ImageFullViewerWidegtState
    extends ImageFullViewerWidegtStateParent<ImageFullViewerWidget> {
  @override
  setGalleryItemsURL() => galleryItems = widget.galleryItems;

  @override
  setIndex() => currentIndex = widget.index;
  @override
  setPageController() => pageController = widget.pageController;
}

abstract class ImageFullViewerWidegtStateParent<T extends StatefulWidget>
    extends State<T> with OneStepPermission {
  int currentIndex;
  List galleryItems = [];
  PageController pageController;
  setIndex();
  setGalleryItemsURL();
  setPageController();

  @override
  void initState() {
    setIndex();
    setGalleryItemsURL();
    // currentIndex = widget.index;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    // print(widget.galleryItems[index] + "hi");
    return PhotoViewGalleryPageOptions(
      // AssetImage(widget.galleryItems[index]),

      imageProvider: NetworkImage(galleryItems[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      // heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }

  setClickButton() {
    return Container();
  }

  bottomClickButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      setClickButton(),
      Container(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "${currentIndex + 1}/${galleryItems.length}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            decoration: null,
          ),
        ),
      )
    ]);
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
            itemCount: galleryItems.length,
            // loadingBuilder: widget.loadingBuilder,
            // backgroundDecoration: widget.backgroundDecoration,
            pageController: pageController,
            onPageChanged: onPageChanged,
            // scrollDirection: widget.scrollDirection,
          ),
          bottomClickButton()
        ],
      ),
    );
  }
}

class CustomImageViewer extends StatefulWidget {
  final int index;
  final List galleryItems;
  CustomImageViewer({Key key, this.index, this.galleryItems})
      : pageController = PageController(initialPage: index);

  final PageController pageController;

  @override
  _CustomImageViewrState createState() => _CustomImageViewrState();
}

class _CustomImageViewrState
    extends ImageFullViewerWidegtStateParent<CustomImageViewer> {
  @override
  setGalleryItemsURL() => galleryItems = widget.galleryItems;

  @override
  setIndex() => currentIndex = widget.index;
  @override
  setPageController() => pageController = widget.pageController;
  // @override
  // setClickButton() {
  //   // return GestureDetector(onTap: () async {
  //   // });
  // }

  //   return IconButton(
  //       icon: Icon(
  //         Icons.download_outlined,
  //         color: Colors.white,
  //       ),
  //       onPressed: () {});
  // }

}

// class _TaskInfo {
//   final String name;
//   final String link;

//   String taskId;
//   int progress = 0;
//   DownloadTaskStatus status = DownloadTaskStatus.undefined;

//   _TaskInfo({this.name, this.link});
// }

// class _ItemHolder {
//   final String name;
//   final _TaskInfo task;

//   _ItemHolder({this.name, this.task});
// }
