/// Отвечает за то какие данные будут отображаться пользователю
/// какие данные можно изменять и по каким правилам

enum TableShowEnum {
  productsMaterialsConst,
  workConst,
  otherConst,
  shieldsType,
  rabotniki,
  products,
  productsWork,
  shieldsWidthType,
  bracketMaterials,
  bracketSalary,
  bracketOtherCost,
  bracketSpendForm,
  trenogaMaterials,
  trenogaSalary,
  trenogaOtherCost,
  trenogaSpendForm,
  clepki;

  Map<String, TableSetting> get columnNameMap => getColumnName();

  Map<String, TableSetting> getColumnName() {
    switch (this) {
      case productsMaterialsConst:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'key': TableSetting(title: null, isEditable: false, type: String),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'ed': TableSetting(title: 'Единицы', isEditable: true, type: String),
          'norma': TableSetting(title: 'Норма Расхода', isEditable: true, type: double),
          'coast':
              TableSetting(title: 'Цена', isEditable: true, type: double, keyGroup: 'aluminiy'),
          'subGroup': TableSetting(title: null, isEditable: false, type: String),
        };
      case otherConst:
      case workConst:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'key': TableSetting(title: null, isEditable: false, type: String),
          'subKey': TableSetting(title: null, isEditable: false, type: String),
          'value': TableSetting(title: 'Наименование', isEditable: false, type: String),
          'value2': TableSetting(title: null, isEditable: false, type: String),
          'value3': TableSetting(title: null, isEditable: false, type: double),
          'value4': TableSetting(title: null, isEditable: false, type: String),
          'value5': TableSetting(title: 'цена', isEditable: true, type: double),
        };
      case shieldsType:
        return {
          'tip': TableSetting(title: 'тип', isEditable: false, type: String),
          'comment':
              TableSetting(title: 'Комментарий', isEditable: true, type: String, canBeNull: true),
          'id': TableSetting(title: null, isEditable: false, type: int),
          'height': TableSetting(title: 'Высота', isEditable: true, type: int),
          'line_jumper': TableSetting(title: 'Л.Связь', isEditable: true, type: int),
          'univ_jamper': TableSetting(title: 'У.Связь', isEditable: true, type: int),
          'line_pipe': TableSetting(title: 'Л.отверстие', isEditable: true, type: int),
          'pipe_edge': TableSetting(title: 'Т.отверствие', isEditable: true, type: int),
          'job_dopOp': TableSetting(title: null, isEditable: false, type: double),
        };
      case rabotniki:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'familia': TableSetting(title: 'Фамилия', isEditable: true, type: String),
        };
      case clepki:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'tip': TableSetting(title: 'Тип', isEditable: false, type: String),
          'h': TableSetting(title: 'Высота', isEditable: false, type: int),
          'w': TableSetting(title: 'Ширина', isEditable: false, type: int),
          'count': TableSetting(title: 'Количество', isEditable: true, type: int),
        };
      case products:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'product': TableSetting(title: 'Продукт', isEditable: true, type: String),
        };
      case productsWork:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'productId': TableSetting(title: null, isEditable: false, type: String),
          'productName': TableSetting(title: 'Продукция', isEditable: false, type: String),
          'work': TableSetting(title: 'Работа', isEditable: true, type: String),
          'tarif': TableSetting(title: 'Тариф', isEditable: true, type: double),
        };
      case shieldsWidthType:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'key': TableSetting(title: null, isEditable: false, type: String),
          'subKey': TableSetting(title: null, isEditable: false, type: String),
          'name': TableSetting(title: 'Наименование', isEditable: false, type: String),
          'value2': TableSetting(title: 'Ширина', isEditable: true, type: String),
          'value3': TableSetting(title: null, isEditable: false, type: double),
          'value4': TableSetting(title: null, isEditable: false, type: String),
          'value5': TableSetting(title: null, isEditable: true, type: double),
        };
      case bracketMaterials:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'bracketSpendType': TableSetting(
            title: 'труба',
            isEditable: true,
            type: String,
            spinnerKey: 'pipeGroup',
            canBeNull: true,
          ),
          'type': TableSetting(title: 'тип', isEditable: false, type: String, hideConstValue: true),
          'ed': TableSetting(title: 'ед.изм', isEditable: true, type: String),
          'norma':
              TableSetting(title: 'норма расхода', isEditable: true, type: double, canBeNull: true),
          'total': TableSetting(title: 'сумма', isEditable: true, type: double, canBeNull: true),
        };
      case bracketSalary:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'type': TableSetting(title: 'тип', isEditable: false, type: String, hideConstValue: true),
          'ed': TableSetting(title: 'ед.изм', isEditable: true, type: String),
          'norma':
              TableSetting(title: 'норма расхода', isEditable: true, type: double, canBeNull: true),
          'total': TableSetting(title: 'сумма', isEditable: true, type: double, canBeNull: true),
        };
      case bracketOtherCost:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'type': TableSetting(
            title: 'тип',
            isEditable: false,
            type: String,
            hideConstValue: true,
          ),
          'ed': TableSetting(
            title: 'Группа',
            isEditable: true,
            type: String,
            spinnerKey: 'otherCostGroup',
            canBeNull: true,
          ),
          'norma': TableSetting(title: 'Процент', isEditable: true, type: double, canBeNull: true),
          'total':
              TableSetting(title: 'Постоянные', isEditable: true, type: double, canBeNull: true),
        };
      case bracketSpendForm:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'kg_per_mp': TableSetting(title: 'kg_per_mp', isEditable: true, type: double),
          'l_per_ed': TableSetting(title: 'l_per_ed', isEditable: true, type: double),
        };
      case trenogaMaterials:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'trenogaSpendType': TableSetting(
            title: 'труба',
            isEditable: true,
            type: String,
            spinnerKey: 'trenogaPipeGroup',
            canBeNull: true,
          ),
          'type': TableSetting(title: 'тип', isEditable: false, type: String, hideConstValue: true),
          'ed': TableSetting(title: 'ед.изм', isEditable: true, type: String),
          'norma':
              TableSetting(title: 'норма расхода', isEditable: true, type: double, canBeNull: true),
          'total': TableSetting(title: 'сумма', isEditable: true, type: double, canBeNull: true),
        };
      case trenogaSalary:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'type': TableSetting(title: 'тип', isEditable: false, type: String, hideConstValue: true),
          'ed': TableSetting(title: 'ед.изм', isEditable: true, type: String),
          'norma':
              TableSetting(title: 'норма расхода', isEditable: true, type: double, canBeNull: true),
          'total': TableSetting(title: 'сумма', isEditable: true, type: double, canBeNull: true),
        };
      case trenogaOtherCost:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'type': TableSetting(
            title: 'тип',
            isEditable: false,
            type: String,
            hideConstValue: true,
          ),
          'ed': TableSetting(
            title: 'Группа',
            isEditable: true,
            type: String,
            spinnerKey: 'otherCostGroup',
            canBeNull: true,
          ),
          'norma': TableSetting(title: 'Процент', isEditable: true, type: double, canBeNull: true),
          'total':
              TableSetting(title: 'Постоянные', isEditable: true, type: double, canBeNull: true),
        };
      case trenogaSpendForm:
        return {
          'id': TableSetting(title: null, isEditable: false, type: int),
          'name': TableSetting(title: 'Наименование', isEditable: true, type: String),
          'kg_per_mp': TableSetting(title: 'kg_per_mp', isEditable: true, type: double),
          'l_per_ed': TableSetting(title: 'l_per_ed', isEditable: true, type: double),
        };
    }
  }

  bool getIsCanAddNew() {
    switch (this) {
      case TableShowEnum.productsMaterialsConst:
        return false;
      case TableShowEnum.workConst:
        return false;
      case TableShowEnum.otherConst:
        return false;
      case TableShowEnum.shieldsType:
        return true;
      case TableShowEnum.rabotniki:
        return true;
      case TableShowEnum.products:
        return true;
      case TableShowEnum.productsWork:
        return true;
      case TableShowEnum.shieldsWidthType:
        return false;
      case TableShowEnum.bracketMaterials:
        return true;
      case TableShowEnum.bracketSalary:
        return true;
      case TableShowEnum.bracketOtherCost:
        return true;
      case TableShowEnum.bracketSpendForm:
        return true;
      case TableShowEnum.trenogaMaterials:
        return true;
      case TableShowEnum.trenogaSalary:
        return true;
      case TableShowEnum.trenogaOtherCost:
        return true;
      case TableShowEnum.trenogaSpendForm:
        return true;
      case TableShowEnum.clepki:
        return true;
    }
  }
}

class TableSetting {
  String? title;
  bool isEditable;
  bool canBeNull;
  Type type;
  String? spinnerKey;
  String? keyGroup;
  bool hideConstValue;

  TableSetting({
    required this.title,
    required this.isEditable,
    required this.type,
    this.keyGroup,
    this.spinnerKey,
    this.hideConstValue = false,
    this.canBeNull = false,
  });
}
