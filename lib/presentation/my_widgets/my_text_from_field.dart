import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool numbOnly;
  final bool allowDouble;
  final TextStyle? textStyle;
  bool? autofocus;
  Widget? prefixIcon;
  String? hint;

  MyTextFormField({
    Key? key,
    required this.controller,
    this.numbOnly = false,
    this.allowDouble = false,
    this.hint,
    this.prefixIcon,
    this.textStyle,
    this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp regExp = allowDouble ? ToolHelpData.regExpDouble : ToolHelpData.regExpNumOnly;
    return Center(
      child: TextFormField(
        autofocus: autofocus ?? controller.text.isEmpty,
        expands: false,
        maxLines: 1,
        minLines: null,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: prefixIcon != null ? const EdgeInsets.only(right: 35) : null,
          isCollapsed: true,
          hintText: hint ?? '—',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            letterSpacing: 2.5,
          ),
        ),
        inputFormatters:
            numbOnly ? <TextInputFormatter>[FilteringTextInputFormatter.allow(regExp)] : null,
        controller: controller,
        cursorWidth: 1,
        textAlign: TextAlign.center,
        cursorHeight: textStyle != null ? null : 27,
        cursorColor: ToolThemeDataHolder.colorMonoPlastGreen,
        textAlignVertical: TextAlignVertical.center,
        style: textStyle ?? ToolThemeDataHolder.defFillTextDataStyle,
      ),
    );
  }
}
