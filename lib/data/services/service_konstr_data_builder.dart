import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/repository/repository_form_database.dart';
import 'package:form_demo_web/domain/constant_entity.dart';
import 'package:form_demo_web/domain/db_form_entity/clepki_form.dart';

class ServiceKonstrData {
  ConstantEntity konstr;
  RepositoryFormDataBase _repositoryShield = RepositoryFormDataBase();
  bool haveSecondWidth = false;

  ServiceKonstrData(this.konstr) {
    init();
  }

  init() {
    haveSecondWidth = _repositoryShield.cheekDoubleWidthFromConst(konstr.tip);
    buildClepki();
    buildPeremichki();
    buildOther();
  }

  buildClepki() async {
    if (haveSecondWidth) {
      List<ClepkiForm> clepkiListFirst = await _repositoryShield.checkKonstExist(
          height: konstr.height, width: konstr.width, tip: konstr.tip);
      List<ClepkiForm> clepkiListSecond = await _repositoryShield.checkKonstExist(
          height: konstr.height, width: konstr.widthSecond, tip: konstr.tip);
      if (clepkiListFirst.isNotEmpty && clepkiListSecond.isNotEmpty) {
        konstr.clepki = clepkiListFirst.first.count!; // дату билдем только если есть клёпки
      } else {
        throw ("нет клёпок");
      }
    } else {
      List<ClepkiForm> clepkiList = await _repositoryShield.checkKonstExist(
          height: konstr.height, width: konstr.width, tip: konstr.tip);
      if (clepkiList.isNotEmpty) {
        konstr.clepki = clepkiList.first.count!;
      } else {
        throw ("нет клёпок");
      }
    }
  }

  buildPeremichki() {
    if (konstr.tip == (ConstName.tip_linear) ||
        konstr.tip == (ConstName.tip_tortsevoy) ||
        konstr.tip == (ConstName.tip_linear_end)) {
      if (konstr.width >= 1300) {
        konstr.n_jamper_line = 6;
      }
      if (konstr.width >= 1000 && konstr.width < 1300) {
        konstr.n_jamper_line = 4;
      }
      if (konstr.width >= 700 && konstr.width < 1000) {
        konstr.n_jamper_line = 2;
      }
      if (konstr.width < 700) {
        konstr.n_jamper_line = 0;
      }
    }
    if (konstr.tip == (ConstName.tip_generic)) {
      if (konstr.width >= 750) {
        konstr.n_jamper_line = 2;
      }
      if (konstr.width > 900) {
        konstr.n_jamper_line = 4;
      }
    }
    if (konstr.height < 2800) {
      konstr.n_jamper_line = 0;
    }
  }

  buildOther() {
    if (konstr.width >= 700) {
      konstr.n_hole_link = konstr.n_line * 2;
    }
    if (konstr.width < 700 && konstr.width >= 250) {
      if (konstr.n_jamper_line == 0) {
        konstr.n_hole_link = konstr.n_line;
      } else {
        konstr.n_hole_link = (konstr.n_line - 2);
      }
    }
    if (konstr.tip == (ConstName.tip_generic)) {
      konstr.n_hole_univ = (konstr.width / 100).toInt();
      if (konstr.width < 550) {
        konstr.n_hole_link = konstr.n_line;
      } else {
        konstr.n_hole_link = (konstr.n_line * 2);
      }
    }
    if (konstr.tip == (ConstName.tip_angular_outer)) {
      konstr.n_hole_link = konstr.n_line * 2;
    }
    if (konstr.width < 250 ||
        konstr.tip == (ConstName.tip_sharnir) ||
        konstr.tip == (ConstName.tip_Wy_shaped) ||
        konstr.tip == (ConstName.tip_W_shaped) ||
        konstr.tip == (ConstName.tip_angular_inner)) {
      konstr.n_hole_link = 0;
    }
    if (konstr.tip == (ConstName.tip_generic)) {
      konstr.l_jamper_line = 295;
    } else {
      konstr.l_jamper_line = 245;
    }
  }
}
