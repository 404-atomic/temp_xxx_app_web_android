import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatefulWidget {
  final Duration? duration;
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final bool repeat;
  final bool reverse;
  final bool autoPlay;
  final void Function()? onLoaded;
  final void Function()? onError;

  const LottieWidget(
    this.url, {
    Key? key,
    this.duration,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.repeat = true,
    this.reverse = false,
    this.autoPlay = true,
    this.onLoaded,
    this.onError,
  }) : super(key: key);

  @override
  _LottieWidgetState createState() => _LottieWidgetState();
}

class _LottieWidgetState extends State<LottieWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    super.initState();
    _animationController.repeat(period: widget.duration, reverse: widget.reverse);
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        reverse: widget.reverse,
        controller: _animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
