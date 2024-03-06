import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationIncomeScreen extends StatefulWidget {
  const ApplicationIncomeScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationIncomeScreen> createState() =>
      _ApplicationIncomeScreenState();
}

class _ApplicationIncomeScreenState extends State<ApplicationIncomeScreen> {
  int progress = 2;

  bool isIncomeSourceSelected = storageIncomeSource == null ? false : true;
  bool isIncomeLevelSelected = storageIncomeLevel == null ? false : true;
  int toggles = 0;

  String? selectedValue = storageIncomeSource;
  String? selectedIncomeLevel = storageIncomeLevel;

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Routes.applicationAddress);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, Routes.applicationAddress);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[261]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    ApplicationProgress(progress: progress),
                    const SizeBox(height: 30),
                    Text(
                      labels[270]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      labels[271]["labelText"],
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: buildDropdown,
                    ),
                    const SizeBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Income Range (Per Annum)",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: buildDropdownIncomeLevel,
                    ),
                  ],
                ),
              ),
              BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                builder: buildSubmitButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      title: "Select",
      items: sourceOfIncomeDDs,
      value: selectedValue,
      onChanged: (value) {
        toggles++;
        isIncomeSourceSelected = true;
        selectedValue = value as String;
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isIncomeSourceSelected,
            toggles: toggles,
          ),
        );
      },
    );
  }

  Widget buildDropdownIncomeLevel(
      BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      leading: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: const AssetImage(ImageConstants.usaFlag),
            radius: (10 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "USD",
            style: TextStyles.primary.copyWith(
              fontSize: (14 / Dimensions.designWidth).w,
              color: AppColors.black63,
            ),
          ),
          const SizeBox(width: 10),
          SizedBox(
            height: (20 / Dimensions.designHeight).h,
            child: const VerticalDivider(
              color: AppColors.black63,
              width: 1,
            ),
          ),
          const SizeBox(width: 5),
        ],
      ),
      title: "Select",
      items: incomeLevels,
      value: selectedIncomeLevel,
      onChanged: (value) {
        toggles++;
        isIncomeLevelSelected = true;
        selectedIncomeLevel = value as String;
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isIncomeLevelSelected,
            toggles: toggles,
          ),
        );
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, DropdownSelectedState state) {
    if (isIncomeSourceSelected && isIncomeLevelSelected) {
      return Column(
        children: [
          GradientButton(
            onTap: () async {
              if (!isUploading) {
                final DropdownSelectedBloc showButtonBloc =
                    context.read<DropdownSelectedBloc>();
                isUploading = true;
                showButtonBloc.add(DropdownSelectedEvent(
                    isDropdownSelected: isUploading, toggles: toggles));
                await storage.write(key: "incomeSource", value: selectedValue);
                storageIncomeSource = await storage.read(key: "incomeSource");

                await storage.write(
                    key: "incomeLevel", value: selectedIncomeLevel);
                storageIncomeLevel = await storage.read(key: "incomeLevel");

                if (context.mounted) {
                  Navigator.pushNamed(context, Routes.applicationTaxFATCA);
                }
                isUploading = false;
                showButtonBloc.add(DropdownSelectedEvent(
                    isDropdownSelected: isUploading, toggles: toggles));

                await storage.write(key: "stepsCompleted", value: 6.toString());
                storageStepsCompleted =
                    int.parse(await storage.read(key: "stepsCompleted") ?? "0");
              }
            },
            text: labels[127]["labelText"],
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(onTap: () {}, text: labels[127]["labelText"]),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      );
    }
  }
}
