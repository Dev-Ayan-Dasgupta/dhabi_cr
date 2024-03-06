// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<CustomExpansionTileModel> faqList = [];

  @override
  void initState() {
    super.initState();
    populateFaqs();
  }

  void populateFaqs() {
    faqList.clear();
    for (var faq in faqs) {
      faqList.add(
        CustomExpansionTileModel(
          isExpanded: false,
          titleText: faq["question"],
          childrenText: faq["answer"],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              "FAQs",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  CustomExpansionTileModel item = faqList[index];
                  return BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomExpansionTile(
                        index: index,
                        isExpanded: item.isExpanded,
                        titleText: item.titleText,
                        childrenText: item.childrenText,
                        onExpansionChanged: (val) {
                          item.isExpanded = val;
                          showButtonBloc.add(
                            ShowButtonEvent(show: item.isExpanded),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
