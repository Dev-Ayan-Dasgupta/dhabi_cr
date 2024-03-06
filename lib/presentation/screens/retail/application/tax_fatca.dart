// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ApplicationTaxFATCAScreen extends StatefulWidget {
  const ApplicationTaxFATCAScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationTaxFATCAScreen> createState() =>
      _ApplicationTaxFATCAScreenState();
}

class _ApplicationTaxFATCAScreenState extends State<ApplicationTaxFATCAScreen> {
  int progress = 3;
  bool isUSCitizen = false;
  bool isUSResident = false;
  bool isPPonly = true;
  bool isEmirateID = false;
  bool isTINvalid = false;
  bool isCRS = false;
  bool hasTIN = false;
  bool isShowButton = false;

  bool usResidentYes = false;
  bool usResidentNo = false;

  int toggles = 0;

  bool isShowTCCHelp = false;

  final TextEditingController _tinssnController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Routes.applicationIncome);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.applicationIncome);
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  labels[273]["labelText"],
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                // const SizeBox(width: 10),
                                // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                //   builder: buildTitleTooltip,
                                // ),
                              ],
                            ),
                            const SizeBox(height: 20),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion1,
                            ),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: (context, state) {
                                if (isUSCitizen) {
                                  return const SizeBox(height: 10);
                                } else {
                                  return const SizeBox(height: 10);
                                }
                              },
                            ),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion1Buttons,
                            ),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: (context, state) {
                                if (isUSCitizen) {
                                  return const SizeBox(height: 0);
                                } else {
                                  return const SizeBox(height: 20);
                                }
                              },
                            ),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildTinTextField,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  if (isShowButton) {
                    return Column(
                      children: [
                        const SizeBox(height: 20),
                        GradientButton(
                          onTap: () async {
                            if (isEmirateID || isUSCitizen) {
                              Navigator.pushNamed(
                                context,
                                Routes.applicationAccount,
                                arguments: ApplicationAccountArgumentModel(
                                  isInitial: true,
                                  isRetail: true,
                                  savingsAccountsCreated: 0,
                                  currentAccountsCreated: 0,
                                ).toMap(),
                              );
                            } else {
                              Navigator.pushNamed(
                                context,
                                Routes.applicationTaxCRS,
                                arguments: TaxCrsArgumentModel(
                                  isUSFATCA: isUSCitizen,
                                  ustin: _tinssnController.text,
                                ).toMap(),
                              );
                            }
                            await storage.write(
                                key: "isUSFatca",
                                value: usResidentYes.toString());
                            storageIsUSFATCA =
                                await storage.read(key: "isUSFatca") == "true";
                            await storage.write(
                                key: "usTin", value: _tinssnController.text);
                            storageUsTin = await storage.read(key: "usTin");

                            await storage.write(
                                key: "stepsCompleted", value: 7.toString());
                            storageStepsCompleted = int.parse(
                                await storage.read(key: "stepsCompleted") ??
                                    "0");
                          },
                          text: labels[127]["labelText"],
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
                        SolidButton(
                            onTap: () {}, text: labels[127]["labelText"]),
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
      ),
    );
  }

  Widget buildQuestion1Buttons(
      BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen) {
      return const SizeBox();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: usResidentYes
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isUSResident = true;
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = true;
                      usResidentNo = false;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: usResidentNo,
                          toggles: ++toggles,
                        ),
                      );
                      if (!isTINvalid) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: usResidentNo
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isUSResident = false;
                      storageUsTin = "";
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = false;
                      usResidentNo = true;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: usResidentNo,
                          toggles: ++toggles,
                        ),
                      );
                      isShowButton = true;
                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildTinTextField(BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen || isUSResident) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labels[276]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomTextField(
            controller: _tinssnController,
            keyboardType: TextInputType.number,
            borderColor:
                !isTINvalid ? AppColors.red100 : const Color(0xFFEEEEEE),
            onChanged: (p0) {
              if (_tinssnController.text.length == 9) {
                isTINvalid = true;
                applicationTaxBloc.add(
                  ApplicationTaxEvent(
                      isUSCitizen: isUSCitizen,
                      isUSResident: isUSResident,
                      isPPonly: isPPonly,
                      isTINvalid: isTINvalid,
                      isCRS: isCRS,
                      hasTIN: hasTIN),
                );
                isShowButton = true;
                showButtonBloc.add(ShowButtonEvent(show: isShowButton));
              } else {
                isTINvalid = false;
                applicationTaxBloc.add(
                  ApplicationTaxEvent(
                      isUSCitizen: isUSCitizen,
                      isUSResident: isUSResident,
                      isPPonly: isPPonly,
                      isTINvalid: isTINvalid,
                      isCRS: isCRS,
                      hasTIN: hasTIN),
                );
                isShowButton = false;
                showButtonBloc.add(ShowButtonEvent(show: isShowButton));
              }
            },
            hintText: "000000000",
          ),
          const SizeBox(height: 7),
          Ternary(
            condition: isTINvalid,
            truthy: const SizeBox(),
            falsy: Row(
              children: [
                Icon(
                  Icons.error_rounded,
                  color: AppColors.red100,
                  size: (13 / Dimensions.designWidth).w,
                ),
                const SizeBox(width: 5),
                Text(
                  "Must be 9 digits",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.red100,
                    fontSize: (12 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTitleTooltip(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomTooltip(
      tooltiptap: () {
        isShowTCCHelp = false;
        showButtonBloc.add(ShowButtonEvent(show: isShowTCCHelp));
      },
      content: labels[273]["labelText"],
      show: isShowTCCHelp,
      onTap: () {
        isShowTCCHelp = !isShowTCCHelp;
        showButtonBloc.add(ShowButtonEvent(show: isShowTCCHelp));
      },
    );
  }

  Widget buildQuestion1(BuildContext context, ApplicationTaxState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Are you a U.S. citizen or resident for tax purposes?",
              style: TextStyles.primary.copyWith(
                color: AppColors.dark80,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const Asterisk(),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tinssnController.dispose();
    super.dispose();
  }
}
