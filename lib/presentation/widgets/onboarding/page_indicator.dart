// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    Key? key,
    required this.count,
    required this.page,
  }) : super(key: key);

  final int count;
  final int page;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressAnimationController;
  late final Animation _progressLengthAnimation;

  final padding = (PaddingConstants.horizontalPadding / Dimensions.designWidth);
  final borderRadius = (8 / Dimensions.designWidth);
  final space = (10 / Dimensions.designWidth);

  @override
  void initState() {
    super.initState();
    _progressAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _progressLengthAnimation = Tween<double>(
            begin: 0,
            end: (100.w - (2 * padding.w) - (widget.count * space.w)) /
                widget.count)
        .animate(CurvedAnimation(
            parent: _progressAnimationController, curve: Curves.linear));
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: (3 / Dimensions.designHeight).h,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.count,
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: space.w,
                );
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width:
                          (100.w - (2 * padding.w) - (widget.count * space.w)) /
                              widget.count,
                      height: (6 / Dimensions.designHeight).h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(borderRadius),
                        ),
                        color: const Color.fromRGBO(217, 217, 217, 0.5),
                      ),
                    ),
                    index < widget.page
                        ? Container(
                            width: (100.w -
                                    (2 * padding.w) -
                                    (widget.count * space.w)) /
                                widget.count,
                            height: (6 / Dimensions.designHeight).h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius),
                              ),
                              color: const Color.fromRGBO(217, 217, 217, 1),
                            ),
                          )
                        : index == widget.page
                            ? Container(
                                width: _progressLengthAnimation.value,
                                height: (6 / Dimensions.designHeight).h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(borderRadius),
                                  ),
                                  color: const Color.fromRGBO(217, 217, 217, 1),
                                ),
                              )
                            : Container(
                                width: (100.w -
                                        (2 * padding.w) -
                                        (widget.count * space.w)) /
                                    widget.count,
                                height: (6 / Dimensions.designHeight).w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(borderRadius),
                                  ),
                                  color: Colors.transparent,
                                ),
                              ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }
}
