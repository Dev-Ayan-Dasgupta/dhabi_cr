import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_bloc.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_event.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_state.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PrivacyStatementScreen extends StatefulWidget {
  const PrivacyStatementScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyStatementScreen> createState() => _PrivacyStatementScreenState();
}

class _PrivacyStatementScreenState extends State<PrivacyStatementScreen> {
  final ScrollController _scrollController = ScrollController();
  bool scrollDown = true;

  @override
  void initState() {
    super.initState();
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients) {
          if (_scrollController.offset >
              (_scrollController.position.maxScrollExtent -
                      _scrollController.position.minScrollExtent) /
                  2) {
            scrollDown = false;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          } else {
            scrollDown = true;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Privacy Policy",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: 1,
                                itemBuilder: (context, _) {
                                  return SizedBox(
                                    width: 100.w,
                                    child: HtmlWidget(statement),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizeBox(height: PaddingConstants.bottomPadding),
              ],
            ),
            BlocBuilder<ScrollDirectionBloc, ScrollDirectionState>(
              builder: (context, state) {
                return Positioned(
                  right: 0,
                  bottom: (50 / Dimensions.designWidth).w -
                      MediaQuery.of(context).viewPadding.bottom,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      if (!scrollDown) {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          scrollDown = true;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      } else {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          scrollDown = false;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      }
                    },
                    child: Container(
                      width: (50 / Dimensions.designWidth).w,
                      height: (50 / Dimensions.designWidth).w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          !scrollDown
                              ? ImageConstants.arrowUpward
                              : ImageConstants.arrowDownward,
                          // : ImageConstants.arrowDownward,
                          width: (16 / Dimensions.designWidth).w,
                          height: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
