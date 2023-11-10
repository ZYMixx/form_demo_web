import 'package:form_demo_web/data/services/service_active_work_view_model.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

class CopyableDataRepository {
  static CopyableDataRepository get instance => _instance ??= CopyableDataRepository();
  static CopyableDataRepository? _instance;

  static CopyableDataInterface? get copyableDataInterface => _getActiveCopyableInterface();

  static CopyableDataInterface? _getActiveCopyableInterface() {
    AbstractWorkViewModel? viewModel = ServiceActiveWorkViewModel.getActiveWorkViewModel();
    if (viewModel != null && viewModel is CopyableDataInterface) {
      return viewModel as CopyableDataInterface;
    } else {
      return null;
    }
  }

  List<List<String>>? getListData() {
    return copyableDataInterface?.getCopyableDataList();
  }

  List<String>? getListTitle() {
    if (copyableDataInterface == null) {
      return null;
    }
    return copyableDataInterface?.getCopyableTitleList();
  }
}
