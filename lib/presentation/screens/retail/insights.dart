import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final TextEditingController _currencyController =
      TextEditingController(text: "Select Currency");

  int currencies = 1;
  bool isCurrencyChosen = false;

  @override
  Widget build(BuildContext context) {
    final CurrencyPickerBloc currencyPickerBloc =
        context.read<CurrencyPickerBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Insights",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 10),
                currencies > 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Currencies",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red100,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: (120 / Dimensions.designWidth).w,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            (23 / Dimensions.designWidth).w),
                                        topRight: Radius.circular(
                                            (23 / Dimensions.designWidth).w),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizeBox(height: 10),
                                        Container(
                                          width:
                                              (54 / Dimensions.designWidth).w,
                                          height:
                                              (6 / Dimensions.designWidth).w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  (100 / Dimensions.designWidth)
                                                      .w),
                                            ),
                                            color: AppColors.dark30,
                                          ),
                                        ),
                                        const SizeBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: 2,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  isCurrencyChosen = true;
                                                  _currencyController.text =
                                                      "AED";
                                                  Navigator.pop(context);
                                                  currencyPickerBloc.add(
                                                    CurrencyPickerEvent(
                                                      isPicked:
                                                          isCurrencyChosen,
                                                      index: index,
                                                    ),
                                                  );
                                                  showButtonBloc.add(
                                                    ShowButtonEvent(
                                                        show: isCurrencyChosen),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: (22 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                    vertical: (10 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: (41 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        height: (21 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        child: Image.network(
                                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Flag_of_the_United_Arab_Emirates.svg/2560px-Flag_of_the_United_Arab_Emirates.svg.png",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      SizeBox(
                                                          width: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w),
                                                      Text(
                                                        "AED",
                                                        style: TextStyles
                                                            .primary
                                                            .copyWith(
                                                          color:
                                                              AppColors.primary,
                                                          fontSize: (18 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizeBox(
                                                          width: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w),
                                                      Text(
                                                        "United Arab Emirates Dirham",
                                                        style: TextStyles
                                                            .primaryMedium
                                                            .copyWith(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              0, 0, 0, 0.5),
                                                          fontSize: (18 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: BlocBuilder<CurrencyPickerBloc,
                                CurrencyPickerState>(
                              builder: (context, state) {
                                return CustomTextField(
                                  controller: _currencyController,
                                  onChanged: (p0) {},
                                  enabled: false,
                                  fontColor: Color.fromRGBO(
                                    34,
                                    34,
                                    34,
                                    _currencyController.text ==
                                            "Select Currency"
                                        ? 0.5
                                        : 1,
                                  ),
                                  suffix: SvgPicture.asset(
                                    ImageConstants.arrowForwardIos,
                                    width: (9.81 / Dimensions.designWidth).w,
                                    height: (16.67 / Dimensions.designWidth).w,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizeBox(height: 10),
                        ],
                      )
                    : const SizeBox(),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (currencies == 1 || isCurrencyChosen) {
                      return Text(
                        "Spending",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (24 / Dimensions.designWidth).w,
                        ),
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
                ),
              ],
            ),
            currencies > 1
                ? BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (isCurrencyChosen) {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: (24 / Dimensions.designWidth).w,
                                        height: index % 2 == 0
                                            ? (132 / Dimensions.designWidth).w
                                            : (66 / Dimensions.designWidth).w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                (100 / Dimensions.designWidth)
                                                    .w),
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF1A3C40),
                                              Color(0xFF236269),
                                              Color(0xFF1A3C40),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizeBox(height: 8),
                                      Text(
                                        "Jan",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: const Color(0XFFA1A1A1),
                                          fontSize:
                                              (14 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizeBox(width: 8),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizeBox();
                      }
                    },
                  )
                : SizedBox(
                    height: 40.w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: (24 / Dimensions.designWidth).w,
                                  height: index % 2 == 0
                                      ? (132 / Dimensions.designWidth).w
                                      : (66 / Dimensions.designWidth).w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          (100 / Dimensions.designWidth).w),
                                    ),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF1A3C40),
                                        Color(0xFF236269),
                                        Color(0xFF1A3C40),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizeBox(height: 8),
                                Text(
                                  "Jan",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0XFFA1A1A1),
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                            const SizeBox(width: 8),
                          ],
                        );
                      },
                    ),
                  ),
            const SizeBox(height: 20),
            currencies > 1
                ? BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (isCurrencyChosen) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AED 4.18",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (24 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const SizeBox(height: 5),
                                Text(
                                  "Avg monthly spend",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0XFFA1A1A1),
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "AED 232.18",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (24 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const SizeBox(height: 5),
                                Text(
                                  "Spent this month",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0XFFA1A1A1),
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const SizeBox();
                      }
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AED 4.18",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (24 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 5),
                          Text(
                            "Avg monthly spend",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0XFFA1A1A1),
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "AED 232.18",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (24 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 5),
                          Text(
                            "Spent this month",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0XFFA1A1A1),
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizeBox(height: 10),
            currencies > 1
                ? BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (isCurrencyChosen) {
                        return Expanded(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: (5 / Dimensions.designWidth).w),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: (40 / Dimensions.designWidth).w,
                                        height: (40 / Dimensions.designWidth).w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                (7 / Dimensions.designWidth).w),
                                          ),
                                          color: const Color.fromRGBO(
                                              34, 97, 105, 0.1),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            ImageConstants.phoneAndroid,
                                            width:
                                                (20 / Dimensions.designWidth).w,
                                            height:
                                                (20 / Dimensions.designWidth).w,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.primary,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizeBox(width: 15),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Cash",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: (18 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                const SizeBox(height: 10),
                                                Container(
                                                  width: index % 2 != 0
                                                      ? (147 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w
                                                      : (73.5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                  height: (5 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular((5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w),
                                                    ),
                                                    color: AppColors.primary,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizeBox(width: 15),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "AED 50.23",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: (18 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                const SizeBox(height: 10),
                                                Text(
                                                  "64%",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: const Color.fromRGBO(
                                                        1, 1, 1, 0.4),
                                                    fontSize: (14 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizeBox();
                      }
                    },
                  )
                : Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: (5 / Dimensions.designWidth).w),
                            child: Row(
                              children: [
                                Container(
                                  width: (40 / Dimensions.designWidth).w,
                                  height: (40 / Dimensions.designWidth).w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          (7 / Dimensions.designWidth).w),
                                    ),
                                    color:
                                        const Color.fromRGBO(34, 97, 105, 0.1),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      ImageConstants.phoneAndroid,
                                      width: (20 / Dimensions.designWidth).w,
                                      height: (20 / Dimensions.designWidth).w,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizeBox(width: 15),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Cash",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: AppColors.primary,
                                              fontSize:
                                                  (18 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          const SizeBox(height: 10),
                                          Container(
                                            width: index % 2 != 0
                                                ? (147 / Dimensions.designWidth)
                                                    .w
                                                : (73.5 /
                                                        Dimensions.designWidth)
                                                    .w,
                                            height:
                                                (5 / Dimensions.designWidth).w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    (5 / Dimensions.designWidth)
                                                        .w),
                                              ),
                                              color: AppColors.primary,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizeBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "AED 50.23",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: AppColors.primary,
                                              fontSize:
                                                  (18 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          const SizeBox(height: 10),
                                          Text(
                                            "64%",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: const Color.fromRGBO(
                                                  1, 1, 1, 0.4),
                                              fontSize:
                                                  (14 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
