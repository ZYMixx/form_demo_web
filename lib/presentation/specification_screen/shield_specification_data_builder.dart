import 'package:flutter/material.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/view_models/shield_data_view_model.dart';
import 'package:form_demo_web/presentation/view_models/specification_view_model.dart';
import 'package:provider/provider.dart';

class ShieldSpecificationDataBuilder extends StatelessWidget {
  const ShieldSpecificationDataBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setUpViewModel();
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: const SpecificationChooseDataBlock(),
    );
  }
}

setUpViewModel() {
  viewModel = SpecificationViewModel.instance;
}

class SpecificationChooseDataBlock extends ChooseDataBlock {
  const SpecificationChooseDataBlock({super.key});

  @override
  Widget setUpBottomWidget(String? tip, int? shieldHeight, int? clepki) {
    return Column(
      children: [
        Flexible(child: super.setUpBottomWidget(tip, shieldHeight, clepki)),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: AddShieldButton(),
        ),
      ],
    );
  }
}

class AddShieldButton extends StatelessWidget {
  const AddShieldButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool readyAddShield =
        context.select((ShieldDataViewModel vm) => (vm as SpecificationViewModel).readyAddShield);
    return MyWidgetButton(
        onPressed: readyAddShield
            ? () {
                SpecificationViewModel.instance.onAddShieldPressed();
              }
            : () {},
        name: "Добавить Щит",
        color: readyAddShield ? Colors.blue : Colors.grey);
  }
}
