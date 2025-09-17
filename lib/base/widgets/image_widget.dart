import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/net/net_helper.dart';

import '../utils/debug_utils.dart';

class ImageFromDio extends StatefulWidget {
  final String imageUrl;

  ImageFromDio.name(this.imageUrl);

  @override
  _ImageFromDioState createState() => _ImageFromDioState();
}

class _ImageFromDioState extends State<ImageFromDio> {
  Uint8List? _imageData;

  String? imageUrlOld = null;

  bool isFetching = false;

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    setSessionCookie(dio);
    fetchImage();
  }

  fetchImage() async {
    try {
      if(isFetching) return;
      isFetching = true;
      Response response = await dio.get(
        widget.imageUrl, // 替换为你的图片URL
        options: Options(responseType: ResponseType.bytes),
      );
      setState(() {
        _imageData = response.data;
        imageUrlOld = widget.imageUrl;
      });
      isFetching = false;
    } catch (e) {
      isFetching = false;
      DLog.log('Error fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrlOld == widget.imageUrl) {
      return _imageData == null
          ? LinearProgressIndicator()
          : Image.memory(_imageData ?? Uint8List(0));
    } else {
      fetchImage();
      return _imageData == null
          ? LinearProgressIndicator()
          : Image.memory(_imageData ?? Uint8List(0));
    }

  }
}
