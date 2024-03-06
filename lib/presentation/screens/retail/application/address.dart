import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationAddressScreen extends StatefulWidget {
  const ApplicationAddressScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationAddressScreen> createState() =>
      _ApplicationAddressScreenState();
}

class _ApplicationAddressScreenState extends State<ApplicationAddressScreen> {
  int progress = 1;

  final TextEditingController _countryController =
      TextEditingController(text: "United Arab Emirates");
  final TextEditingController _address1Controller =
      TextEditingController(text: storageAddressLine1 ?? "");
  final TextEditingController _address2Controller =
      TextEditingController(text: storageAddressLine2 ?? "");
  final TextEditingController _cityController =
      TextEditingController(text: storageAddressCity ?? "");
  final TextEditingController _stateController =
      TextEditingController(text: storageAddressState ?? "");
  final TextEditingController _zipController =
      TextEditingController(text: storageAddressPoBox ?? "");

  bool isAddress1Entered = storageAddressLine1 == null ? false : true;
  bool isCitySelected = storageAddressCity == null ? false : true;
  bool isCountrySelected = true;

  int toggles = 0;

  String selectedValue = "Dubai";
  DropDownCountriesModel selectedCountry = DropDownCountriesModel(
    countryFlagBase64: dhabiCountriesWithFlags[uaeIndex].countryFlagBase64,
    countrynameOrCode: dhabiCountriesWithFlags[uaeIndex].countrynameOrCode,
    isEnabled: dhabiCountriesWithFlags[uaeIndex].isEnabled,
  );
  String? selectedCountryName =
      dhabiCountriesWithFlags[uaeIndex].countrynameOrCode;

  int emirateIndex = 0;
  int dhabiCountryIndex = uaeIndex;

  bool isUploading = false;

  bool isPoValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DropdownSelectedBloc residenceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
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
              labels[28]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          labels[264]["labelText"],
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
                      builder: (context, state) {
                        return CustomDropdownCountries(
                          title: "Select a country",
                          items: dhabiCountriesWithFlags,
                          value: selectedCountry,
                          onChanged: (value) {
                            toggles++;
                            isCountrySelected = true;
                            selectedCountry = value as DropDownCountriesModel;
                            selectedCountryName =
                                selectedCountry.countrynameOrCode;
                            dhabiCountryIndex =
                                dhabiCountryNames.indexOf(selectedCountryName!);
                            // emirateIndex = emirates.indexOf(selectedValue!);
                            residenceSelectedBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected:
                                    // isEmirateSelected &&
                                    isCountrySelected &&
                                        (isAddress1Entered
                                        // && isCityEntered
                                        ),
                                toggles: toggles,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // CustomTextField(
                    //   controller: _countryController,
                    //   onChanged: (p0) {},
                    //   enabled: false,
                    //   color: const Color(0xFFF9F9F9),
                    //   fontColor: const Color(0xFFAAAAAA),
                    // ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          labels[265]["labelText"],
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address1Controller,
                      onChanged: (p0) {
                        if (_address1Controller.text.isEmpty) {
                          isAddress1Entered = false;
                        } else {
                          isAddress1Entered = true;
                        }
                        ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        residenceSelectedBloc.add(
                          DropdownSelectedEvent(
                            isDropdownSelected:
                                // isResidenceYearSelected &&
                                (isAddress1Entered
                                // && isCityEntered
                                ),
                            toggles: toggles,
                          ),
                        );
                        showButtonBloc
                            .add(ShowButtonEvent(show: isAddress1Entered));
                      },
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      labels[266]["labelText"],
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address2Controller,
                      onChanged: (p0) {},
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "City",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _cityController,
                      onChanged: (p0) {
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        if (p0.isEmpty) {
                          isCitySelected = false;
                        } else {
                          isCitySelected = true;
                        }
                        showButtonBloc.add(
                          ShowButtonEvent(show: isCitySelected),
                        );
                      },
                      hintText: "City",
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "State/Province",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        // const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _stateController,
                      onChanged: (p0) {},
                      hintText: "State/Province",
                    ),
                    // BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    //   builder: (context, state) {
                    //     return CustomDropDown(
                    //       title: "Select from the list",
                    //       items: emirates,
                    //       value: selectedValue,
                    //       onChanged: (value) {
                    //         toggles++;
                    //         isEmirateSelected = true;
                    //         selectedValue = value as String;
                    //         emirateIndex = emirates.indexOf(selectedValue!);
                    //         residenceSelectedBloc.add(
                    //           DropdownSelectedEvent(
                    //             isDropdownSelected: isEmirateSelected &&
                    //                 isCountrySelected &&
                    //                 (isAddress1Entered
                    //                 // && isCityEntered
                    //                 ),
                    //             toggles: toggles,
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    const SizeBox(height: 20),
                    Text(
                      labels[269]["labelText"],
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        return CustomTextField(
                          controller: _zipController,
                          // keyboardType: TextInputType.numberWithOptions(decimal: true),
                          borderColor: const Color(0xFFEEEEEE),
                          onChanged: (p0) {},
                          // hintText: "0000",
                        );
                      },
                    ),
                    // const SizeBox(height: 7),
                    // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    //   builder: (context, state) {
                    //     return Ternary(
                    //       condition: (isPoValid || _zipController.text.isEmpty),
                    //       truthy: const SizeBox(),
                    //       falsy: Row(
                    //         children: [
                    //           Icon(
                    //             Icons.error_rounded,
                    //             color: AppColors.red100,
                    //             size: (13 / Dimensions.designWidth).w,
                    //           ),
                    //           const SizeBox(width: 5),
                    //           Text(
                    //             "Must be 4 digits",
                    //             style: TextStyles.primaryMedium.copyWith(
                    //               color: AppColors.red100,
                    //               fontSize: (12 / Dimensions.designWidth).w,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),

                    const SizeBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizeBox(height: 20),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (
                    // isEmirateSelected &&
                    isAddress1Entered && isCountrySelected && isCitySelected) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          if (!isUploading) {
                            final DropdownSelectedBloc showButtonBloc =
                                context.read<DropdownSelectedBloc>();
                            isUploading = true;
                            showButtonBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected: isUploading,
                                toggles: toggles,
                              ),
                            );
                            await storage.write(
                                key: "addressCountry",
                                value: _countryController.text);
                            storageAddressCountry =
                                await storage.read(key: "addressCountry");
                            await storage.write(
                                key: "addressLine1",
                                value: _address1Controller.text);
                            storageAddressLine1 =
                                await storage.read(key: "addressLine1");
                            await storage.write(
                                key: "addressLine2",
                                value: _address2Controller.text);
                            storageAddressLine2 =
                                await storage.read(key: "addressLine2");
                            await storage.write(
                                key: "addressCity",
                                value: _cityController.text);
                            storageAddressCity =
                                await storage.read(key: "addressCity");
                            await storage.write(
                                key: "addressState",
                                value: _stateController.text);
                            storageAddressState =
                                await storage.read(key: "addressState");
                            await storage.write(
                                key: "addressEmirate", value: selectedValue);
                            storageAddressEmirate =
                                await storage.read(key: "addressEmirate");
                            await storage.write(
                                key: "poBox", value: _zipController.text);
                            storageAddressPoBox =
                                await storage.read(key: "poBox");

                            if (context.mounted) {
                              if (dhabiCountries[dhabiCountryIndex]["isEnabled"]
                                  // dhabiCountryIndex == uaeIndex
                                  ) {
                                Navigator.pushNamed(
                                    context, Routes.applicationIncome);
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  Routes.notAvailable,
                                  arguments: NotAvailableArgumentModel(
                                    country: dhabiCountries[dhabiCountryIndex]
                                        ["countryName"],
                                  ).toMap(),
                                );
                              }
                            }
                            isUploading = false;
                            showButtonBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected: isUploading,
                                toggles: toggles,
                              ),
                            );
                            await storage.write(
                                key: "stepsCompleted", value: 5.toString());
                            storageStepsCompleted = int.parse(
                                await storage.read(key: "stepsCompleted") ??
                                    "5");
                          }
                        },
                        text: labels[127]["labelText"],
                        auxWidget:
                            isUploading ? const LoaderRow() : const SizeBox(),
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
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }
}
