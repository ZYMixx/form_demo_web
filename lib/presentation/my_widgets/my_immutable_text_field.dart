import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';

class MyImmutableTextField extends StatelessWidget {
  final String text;
  final String? copyText;
  final Color? textColor;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool isRichText;

  const MyImmutableTextField({
    Key? key,
    required this.text,
    this.textColor,
    this.copyText,
    this.style,
    this.textAlign,
    this.isRichText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        ToolShowToast.show("Ячейка скопирована");
        Clipboard.setData(ClipboardData(text: copyText ?? text));
      },
      child: isRichText
          ? RichText(
              text: TextSpan(
                style: style ??
                    ToolThemeDataHolder.defFillTextDataStyle.copyWith(
                      decoration: TextDecoration.none,
                      color: textColor ?? Colors.black87,
                    ),
                children: parsText(
                  text,
                  (style?.fontSize ?? ToolThemeDataHolder.defFillTextDataStyle.fontSize!),
                ),
              ),
            )
          : Text(
              text,
              textAlign: textAlign,
              style: style ??
                  ToolThemeDataHolder.defFillTextDataStyle.copyWith(
                    decoration: TextDecoration.none,
                    color: textColor ?? Colors.black87,
                  ),
            ),
    );
  }
}

/// возможность делать часть текста жирным шрифтом

List<TextSpan> parsText(String userText, double fontSize) {
  List<TextSpan> formattedTextSpanList = [];
  var firstPos = 0;
  var secondPos = 0;
  while (userText.contains("**")) {
    firstPos = userText.indexOf("**");
    secondPos = userText.indexOf("**", firstPos + 2);
    if (secondPos == -1) {
      break;
    }
    var regularTextPart = userText.substring(0, firstPos);
    var bloodTextPart = userText.substring(firstPos, secondPos + 2).replaceAll("**", "");
    formattedTextSpanList.add(
      TextSpan(
        text: regularTextPart,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
    formattedTextSpanList.add(
      TextSpan(
        text: bloodTextPart,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSize + 2),
      ),
    );
    userText = userText.substring(secondPos + 2);
  }
  formattedTextSpanList
      .add(TextSpan(text: userText, style: const TextStyle(color: Colors.black87)));
  return formattedTextSpanList;
}
