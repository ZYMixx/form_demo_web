import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

class ServiceCopyData {
  ///возвращает данные выделенные рамкой и скопированные с экрана Таблицы
  ///в формате удобном для вставления в Excel

  createCopyData(CopyableDataInterface dataInterface) {
    dataInterface.getCopyableDataList();
  }

  static String fillCopyExcelData(List<List<String>> listOfListData) {
    String finalCopyString = '';
    for (var listRowData in listOfListData) {
      String stringRow = '';
      for (var data in listRowData) {
        stringRow = '$stringRow$data${getHorizontalTub()}';
      }
      stringRow = stringRow.trim();
      stringRow = '$stringRow${getVerticalTub()}';
      finalCopyString = '$finalCopyString$stringRow';
    }
    return finalCopyString;
  }

  static String fillCopyTextData(List<List<String>> listOfListData) {
    String finalCopyString = '';
    for (var listRowData in listOfListData) {
      String stringRow = '';
      for (var data in listRowData) {
        stringRow = '$stringRow$data ';
      }
      stringRow = stringRow.trim();
      stringRow = '$stringRow\n';
      finalCopyString = '$finalCopyString$stringRow';
    }
    return finalCopyString;
  }

  static String getHorizontalTub() {
    return String.fromCharCode(9);
  }

  static String getVerticalTub() {
    return String.fromCharCode(13);
  }
}
