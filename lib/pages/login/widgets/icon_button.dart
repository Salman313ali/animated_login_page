import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    required this.url,
    required this.todo,
    super.key,
  });
  final Function() todo;
  final String url;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: todo,
      child: Container(
        height: 150 / 1600 * height,
        width: 150 / 757 * width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage(url),
            width: 75 / 757 * width,
            height: 75 / 1600 * height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
