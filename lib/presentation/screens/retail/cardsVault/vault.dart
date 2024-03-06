import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flip_card/flip_card.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool isFrozen = false;
  final String cardNumber = "4165 9856 9885 6936";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (15 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: SvgPicture.asset(ImageConstants.statement),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (22 / Dimensions.designWidth).w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vault",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 25),
                FlipCard(
                  flipOnTouch: false,
                  key: cardKey,
                  front: Stack(
                    children: [
                      Container(
                        width: (384 / Dimensions.designWidth).w,
                        height: (227.26 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((20 / Dimensions.designWidth).w),
                          ),
                          boxShadow: [BoxShadows.primary],
                          color: Colors.white,
                          image: const DecorationImage(
                            image: AssetImage(ImageConstants.cardBase),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Ternary(
                        condition: isFrozen,
                        truthy: Positioned(
                          left: (25 / Dimensions.designWidth).w,
                          bottom: (25 / Dimensions.designWidth).w,
                          child: Row(
                            children: [
                              Text(
                                "**** ${cardNumber.substring(cardNumber.length - 4, cardNumber.length)}",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.grey40,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const SizeBox(width: 220),
                              SizedBox(
                                width: (42 / Dimensions.designWidth).w,
                                height: (39 / Dimensions.designWidth).w,
                                child: Opacity(
                                  opacity: 0.4,
                                  child: Image.asset(
                                    ImageConstants.mastercardLogo,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        falsy: Positioned(
                          left: (25 / Dimensions.designWidth).w,
                          top: (114 / Dimensions.designWidth).w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Card Number",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark50,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const SizeBox(height: 7),
                              Row(
                                children: [
                                  Text(
                                    cardNumber,
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: const Color(0XFF1A3C40),
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  const SizeBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: cardNumber,
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstants.contentCopy,
                                      width: (17 / Dimensions.designWidth).w,
                                      height: (20 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                              const SizeBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  text: 'AED ',
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0xFF094148),
                                    fontSize: (20 / Dimensions.designWidth).w,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '5,100.00',
                                      style: TextStyles.primary.copyWith(
                                        color: const Color(0xFF094148),
                                        fontSize:
                                            (20 / Dimensions.designWidth).w,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: (25 / Dimensions.designWidth).w,
                        top: (25 / Dimensions.designWidth).w,
                        child: InkWell(
                          onTap: () {
                            if (!isFrozen) {
                              cardKey.currentState!.toggleCard();
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0XFFEEEEEE),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: (12 / Dimensions.designWidth).w,
                              vertical: (3 / Dimensions.designWidth).w,
                            ),
                            child: Text(
                              "Details",
                              style: TextStyles.primaryMedium.copyWith(
                                color: isFrozen
                                    ? AppColors.grey40
                                    : const Color(0XFF1A3C40),
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  back: Stack(
                    children: [
                      Container(
                        width: (384 / Dimensions.designWidth).w,
                        height: (227.26 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((20 / Dimensions.designWidth).w),
                          ),
                          boxShadow: [BoxShadows.primary],
                          color: Colors.white,
                          image: const DecorationImage(
                            image: AssetImage(ImageConstants.cardBase),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        left: (25 / Dimensions.designWidth).w,
                        top: (25 / Dimensions.designWidth).w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              ImageConstants.appBarLogo,
                              width: (68 / Dimensions.designWidth).w,
                              height: (17 / Dimensions.designWidth).w,
                            ),
                            const SizeBox(height: 50),
                            Text(
                              "Card Number",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.dark50,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 7),
                            Row(
                              children: [
                                Text(
                                  cardNumber,
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0XFF1A3C40),
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const SizeBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: cardNumber,
                                      ),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    ImageConstants.contentCopy,
                                    width: (17 / Dimensions.designWidth).w,
                                    height: (20 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                            const SizeBox(height: 30),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Expires",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.dark50,
                                        fontSize:
                                            (14 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    const SizeBox(height: 7),
                                    Text(
                                      "08/25",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: const Color(0XFF1A3C40),
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizeBox(width: 40),
                                Column(
                                  children: [
                                    Text(
                                      "CVV",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.dark50,
                                        fontSize:
                                            (14 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    const SizeBox(height: 7),
                                    Text(
                                      "935",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: const Color(0XFF1A3C40),
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizeBox(width: 180),
                                SizedBox(
                                  width: (42 / Dimensions.designWidth).w,
                                  height: (39 / Dimensions.designWidth).w,
                                  child: Image.asset(
                                    ImageConstants.mastercardLogo,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: (25 / Dimensions.designWidth).w,
                        top: (25 / Dimensions.designWidth).w,
                        child: InkWell(
                          onTap: () {
                            cardKey.currentState!.toggleCard();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0XFFEEEEEE),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: (12 / Dimensions.designWidth).w,
                              vertical: (3 / Dimensions.designWidth).w,
                            ),
                            child: Text(
                              "Hide",
                              style: TextStyles.primaryMedium.copyWith(
                                color: const Color(0XFF1A3C40),
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizeBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DashboardActivityTile(
                      isSelected: isFrozen,
                      iconPath: ImageConstants.acUnit,
                      iconSize: 25,
                      activityText: isFrozen ? "Unfreeze" : "Freeze",
                      onTap: () {},
                    ),
                    const SizeBox(width: 40),
                    DashboardActivityTile(
                      iconPath: ImageConstants.arrowOutward,
                      iconSize: 20,
                      activityText: "Send Money",
                      onTap: () {},
                    ),
                    const SizeBox(width: 40),
                    DashboardActivityTile(
                      iconPath: ImageConstants.settings,
                      iconSize: 25,
                      activityText: "Manage",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.actions);
                      },
                    ),
                  ],
                ),
                const SizeBox(height: 25),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all((18 / Dimensions.designWidth).w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular((10 / Dimensions.designWidth).w)),
                      color: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImageConstants.googleWallet,
                          width: (20 / Dimensions.designWidth).w,
                          height: (20 / Dimensions.designWidth).w,
                        ),
                        const SizeBox(width: 15),
                        Text(
                          "Add to Apple Wallet",
                          style: TextStyles.primaryMedium.copyWith(
                            fontSize: (18 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.34,
            minChildSize: 0.34,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Stack(
                children: [
                  Container(
                    height: 85.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: (10 / Dimensions.designWidth).w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((20 / Dimensions.designWidth).w),
                      ),
                      boxShadow: [BoxShadows.primary],
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 51,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizeBox(height: 50);
                        }
                        return DashboardTransactionListTile(
                          onTap: () {},
                          isCredit: true,
                          title: "Tax non filer debit Tax non filer debit",
                          name: "Alexander Doe",
                          amount: 50.23,
                          currency: "AED",
                          date: "Tue, Apr 1 2022",
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 44.w,
                    top: (10 / Dimensions.designWidth).w,
                    child: IgnorePointer(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: (10 / Dimensions.designWidth).w,
                        ),
                        height: (7 / Dimensions.designWidth).w,
                        width: (50 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((10 / Dimensions.designWidth).w),
                          ),
                          color: const Color(0xFFD9D9D9),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (22 / Dimensions.designWidth).w,
                    top: (25 / Dimensions.designWidth).w,
                    child: IgnorePointer(
                      child: Text(
                        "Recent Transactions",
                        style: TextStyles.primary.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
