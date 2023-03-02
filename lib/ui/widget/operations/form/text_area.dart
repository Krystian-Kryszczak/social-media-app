import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool expands;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  const TextArea({Key? key, this.hintText, this.controller, this.expands = true, this.onTap, this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      expands: expands, maxLines: null,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(16.0),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      onTap: onTap,
      onChanged: onChanged,
    );
  }
}
