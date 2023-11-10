import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_demo_web/data/database/form_database_connection.dart';
import 'package:form_demo_web/data/services/service_shared_preferences.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';

/// в WEB версии не отображается т.к. SQL база данных не требуется

class ConnectDbScreen extends StatefulWidget {
  const ConnectDbScreen({Key? key, this.screen}) : super(key: key);
  final Widget? screen;

  @override
  State<ConnectDbScreen> createState() => _ConnectDbScreenState();
}

class _ConnectDbScreenState extends State<ConnectDbScreen> {
  static const String keyDbFilePath = 'key_db_file_path';

  onSelectNewPathPressed() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['exe']);
    if (result?.paths[0] != null) {
      ServiceSharedPreferences.putString(key: keyDbFilePath, stringData: result!.paths[0]!);
      ToolShowToast.show('Путь успешно изменён');
      setState(() {});
    } else {
      ToolShowToast.showError('Путь не выбран');
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    final double screenHeight = mediaQueryData.size.height;
    String? path = ServiceSharedPreferences.getString(key: keyDbFilePath);

    return WillPopScope(
      onWillPop: () async {
        ToolShowToast.showError("нужно подключение к база денных");
        return false;
      },
      child: Scaffold(
        backgroundColor: ToolThemeDataHolder.mainShadowBgColor,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [ToolThemeDataHolder.alertShadowBox],
            ),
            height: screenHeight / 2.1,
            width: screenWidth / 2.3,
            margin: EdgeInsetsDirectional.only(bottom: screenHeight / 10),
            constraints: const BoxConstraints(
              minWidth: 600,
              minHeight: 400,
            ),
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ОШИБКА",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "подключения к базе данных",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  MyWidgetButton(
                    onPressed: () async {
                      if (await FormDatabaseConnection.init()) {
                        widget.screen != null
                            ? ToolNavigator.popAndReplace(widget.screen!)
                            : ToolNavigator.pop();
                      } else {
                        ToolShowToast.showError("Не удалось подключиться к базе данных");
                      }
                    },
                    name: "Проверить подключение",
                    color: Colors.grey,
                    height: screenHeight / 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: MyWidgetButton(
                          onPressed: onSelectNewPathPressed,
                          name: "Указать путь",
                          color: Colors.grey,
                          height: screenHeight / 10,
                        ),
                      ),
                      Flexible(
                        child: MyWidgetButton(
                          onPressed: () async {
                            String? dbFilePath =
                                await ServiceSharedPreferences.getString(key: keyDbFilePath);
                            if (dbFilePath != null) {
                              Process.start(dbFilePath, [], runInShell: true);
                            } else {
                              ToolShowToast.showError('Укажите путь к файлу');
                            }
                          },
                          name: "Подключиться",
                          color: Colors.green,
                          height: screenHeight / 10,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Путь: ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                      children: [
                        TextSpan(
                          text: path ?? ' *не указан*',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
