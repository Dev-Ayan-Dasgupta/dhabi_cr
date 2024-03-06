import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SelectEntityForOnboardingPersistence extends StatefulWidget {
  const SelectEntityForOnboardingPersistence({super.key});

  @override
  State<SelectEntityForOnboardingPersistence> createState() =>
      _SelectEntityForOnboardingPersistenceState();
}

class _SelectEntityForOnboardingPersistenceState
    extends State<SelectEntityForOnboardingPersistence> {
  bool isPersonalFocussed = false;
  bool isBusinessFocussed = false;
  int toggles = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                    .w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[215]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please select the type of account you wish to continue onboarding with",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                    builder: buildPersonalButton,
                  ),
                  const SizeBox(height: 30),
                  BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                    builder: buildBusinessButton,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPersonalButton(BuildContext context, ButtonFocussedState state) {
    return SolidButton(
      onTap: () {
        onButtonTap(true, false);
      },
      color: Colors.white,
      borderColor: isPersonalFocussed
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      boxShadow: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(
            (3 / Dimensions.designWidth).w,
            (4 / Dimensions.designHeight).h,
          ),
          blurRadius: (3 / Dimensions.designWidth).w,
        ),
      ],
      fontColor: AppColors.primary,
      text: labels[217]["labelText"],
    );
  }

  Widget buildBusinessButton(BuildContext context, ButtonFocussedState state) {
    return SolidButton(
      onTap: () {
        onButtonTap(false, true);
      },
      color: Colors.white,
      borderColor: isBusinessFocussed
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      boxShadow: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(
            (3 / Dimensions.designWidth).w,
            (4 / Dimensions.designHeight).h,
          ),
          blurRadius: (3 / Dimensions.designWidth).w,
        ),
      ],
      fontColor: AppColors.primary,
      text: labels[218]["labelText"],
    );
  }

  void onButtonTap(bool isPersonal, bool isBusiness) {
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isPersonalFocussed = isPersonal;
    isBusinessFocussed = isBusiness;
    toggles++;
    buttonFocussedBloc.add(
      ButtonFocussedEvent(
        isFocussed: isPersonal ? isPersonalFocussed : isBusinessFocussed,
        toggles: toggles,
      ),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isPersonal ? isPersonalFocussed : isBusinessFocussed,
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isPersonalFocussed || isBusinessFocussed) {
      return GradientButton(
        onTap: () async {
          Navigator.pushNamed(
            context,
            Routes.loginPassword,
            arguments: LoginPasswordArgumentModel(
              emailId: storageEmail ?? "",
              userId: -1,
              userTypeId: isPersonalFocussed ? 1 : 2,
              companyId: storageCompanyId ?? 0,
              isSwitching: false,
            ).toMap(),
          );
        },
        text: labels[31]["labelText"],
      );
    } else {
      return SolidButton(onTap: () {}, text: labels[31]["labelText"]);
    }
  }
}
