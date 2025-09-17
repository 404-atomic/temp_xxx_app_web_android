import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/app/app_color.dart';
import 'package:framework/base/utils/color.dart';

import 'image_widget.dart';

/// 登录输入框
class LoginInput extends StatefulWidget {
  /// 标题
  final String title;

  /// 提示文字
  final String hint;

  /// 底部线边距
  final bool lineStretch;

  /// 隐藏文本
  final bool obscureText;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 输入事件
  final ValueChanged<String>? onChanged;

  /// 聚焦事件
  final ValueChanged<bool>? focusChanged;

  /// 验证码
  final String? validateCode;

  /// 点击验证码事件
  final VoidCallback? onValidateCodeClicked;

  const LoginInput(
    this.title,
    this.hint, {
    Key? key,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.focusChanged,
    this.validateCode,
    this.onValidateCodeClicked,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 是否获取光标的监听
    _focusNode.addListener(() {
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// 输入框
  Widget _input() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autofocus: !widget.obscureText,
        cursorColor: accentDefaultColor,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        // 输入框的样式
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.validateCode != null) {
      return _buildInputImg();
    } else {
      return _buildInput();
    }
  }

  Widget _buildInput() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: AppColor.inputColor2,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: 100,
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                _input()
              ],
            )),
        Padding(
          padding: EdgeInsets.only(left: widget.lineStretch ? 15 : 0),
        ),
      ],
    );
  }

  Widget _buildInputImg() {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: AppColor.inputColor2,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: 100,
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                _input(),
                Container(
                    padding: EdgeInsets.only(right: 10),
                    width: 90,
                    child: GestureDetector(
                        onTap: widget.onValidateCodeClicked,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ImageFromDio.name(widget.validateCode ?? ''),
                        )))
              ],
            )
          ],
        ));
  }
}
