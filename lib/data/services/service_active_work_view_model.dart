import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

class ServiceActiveWorkViewModel {
  static AbstractWorkViewModel? _activeViewModel;

  static AbstractWorkViewModel? getActiveWorkViewModel() {
    return _activeViewModel;
  }

  static setActiveWorkViewModel({required AbstractWorkViewModel viewModel}) {
    _activeViewModel = viewModel;
  }
}
