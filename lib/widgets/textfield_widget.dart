import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class UnderLineTextField extends TextFormField {
  final bool isReadOnly;
  final bool isDisable;
  final TextEditingController controller;
  final String label;
  final String hint;
  final double fontSize;
  final Widget sufficIcon;
  final TextInputType keyboardType;
  final Function(String) onEnterTrigger;
  final String errorText;
  final bool isPassword;
  final Function() onTap;

  UnderLineTextField({
    Key key,
    this.isReadOnly = false,
    this.isDisable = false,
    this.controller,
    this.label,
    this.hint,
    this.fontSize = fontMd,
    this.sufficIcon,
    this.keyboardType = TextInputType.text,
    this.onEnterTrigger,
    this.errorText,
    this.isPassword = false,
    this.onTap,
  }) : super(
          key: key,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: onEnterTrigger != null ? TextInputAction.go : null,
          obscureText: isPassword,
          onFieldSubmitted: (value) {
            if (onEnterTrigger != null) {
              onEnterTrigger(value);
            }
          },
          readOnly: isReadOnly,
          decoration: InputDecoration(
            enabled: !isDisable,
            labelText: label,
            labelStyle: semiBold.copyWith(fontSize: fontSize),
            hintText: hint,
            hintStyle: semiBold.copyWith(fontSize: fontSize),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey)),
            errorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            suffixIcon: sufficIcon,
            suffixIconConstraints: BoxConstraints(
              maxWidth: 24,
              maxHeight: 24,
              minHeight: 24,
              minWidth: 24,
            ),
            errorText: errorText,
            errorStyle:
                semiBold.copyWith(fontSize: fontSize, color: Colors.red),
          ),
          onTap: onTap
        );
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key key,
    @required this.searchController,
    this.onClear,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController searchController;
  final Function() onClear;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(offsetBase)),
      elevation: 2.0,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: offsetXSm),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  style:
                      semiBold.copyWith(fontSize: fontMd, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: semiBold.copyWith(
                        fontSize: fontMd, color: Colors.black.withOpacity(0.5)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: onChanged,
                ),
              ),
              InkWell(
                  onTap: onClear,
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  )),
              SizedBox(
                width: offsetXSm,
              )
            ],
          )),
    );
  }
}
