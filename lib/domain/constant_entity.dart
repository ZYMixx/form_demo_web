import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/domain/db_form_entity/konstr_form.dart';

class ConstantEntity {
  ///recreate from old java program

  String tip;
  String? comment;

  String get fullName => createFullName();

  int height = 0,
      width = 0,
      widthSecond = 0,
      n_hole_line = 0, //getLO(){return n_hole_line}
      n_hole_edge = 0, //getTO(){return n_hole_edge}
      n_hole_univ = 0, //getYO(){return n_hole_univ}
      n_univ = 0, //getYS(){return n_univ}
      n_line = 0, //getLS(){return n_line}
      n_jamper_line = 0, //getP(){return } n_jamper_line
      l_jamper_line = 0, //getDP(){return l_jamper_line}
      clepki = 0, //getK(){return clepki}
      n_hole_link = 0; //getV(){return n_hole_link}
  int get sumWidth => width + widthSecond;

  ConstantEntity({
    required KonstrForm konstrForm,
    required this.width,
    required this.clepki,
    this.widthSecond = 0,
  })  : height = konstrForm.height,
        tip = konstrForm.tip.trim(),
        comment = konstrForm.comment,
        n_line = konstrForm.line_jumper,
        n_hole_line = konstrForm.line_pipe,
        n_univ = konstrForm.univ_jamper,
        n_hole_edge = konstrForm.pipe_edge;

  String createFullName() {
    double hh = height.toDouble();
    double ww = width.toDouble();
    double ww2 = widthSecond.toDouble();
    if (tip == ConstName.tip_Wy_shaped || tip == ConstName.tip_W_shaped) {
      double www = ww + ww2;
      www = www % 10 != 0 ? round(number: www / 1000, length: 3) : round(number: www / 1000);
      return "Щит ${getTip()} $www x $www x ${round(number: hh / 1000)} (${ww2 / 1000}) $comment";
    } else {
      ww = ww % 10 != 0 ? round(number: ww / 1000, length: 3) : round(number: ww / 1000);
      ww2 = ww2 % 10 != 0 ? round(number: ww2 / 1000, length: 3) : round(number: ww2 / 1000);
      String dop = ww2 == 0 ? "" : "x $ww2"
        ..trim();
      return "Щит ${getTip()} $ww${(dop != "") ? " $dop" : ""} x ${round(number: hh / 1000)} $comment";
    }
  }

  double round({dynamic number, int length = 2}) {
    return double.parse(number.toStringAsFixed(length));
  }

  int getLO() {
    return n_hole_line;
  }

  int getTO() {
    return n_hole_edge;
  }

  int getYO() {
    return n_hole_univ;
  }

  int getYS() {
    return n_univ;
  }

  int getLS() {
    return n_line;
  }

  int getP() {
    return n_jamper_line;
  }

  int getDP() {
    return l_jamper_line;
  }

  int getK() {
    return clepki;
  }

  int getV() {
    return n_hole_link;
  }

  String getTip() {
    return tip;
  }
}
