import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:flutter/material.dart';

enum ButtonSize { large, medium, small }

enum ButtonVarient { filled, outlined }

enum ButtonWidth { max, min }

class CustomButtons extends StatefulWidget {
  VoidCallback onTap;
  String text;
  ButtonSize buttonSize;
  ButtonVarient buttonVarient;
  bool enabled;
  IconData? prefixIcon;
  IconData? suffixIcon;
  ButtonWidth buttonWidth;
  bool isLoading;
  CustomButtons({
    super.key,
    required this.onTap,
    required this.text,
    this.buttonSize = ButtonSize.medium,
    this.buttonVarient = ButtonVarient.filled,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonWidth = ButtonWidth.min,
    this.isLoading = false,
  });

  @override
  State<CustomButtons> createState() => _CustomButtonsState();
}

class _CustomButtonsState extends State<CustomButtons> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.buttonWidth == ButtonWidth.max ? 1 : 0,
      child: InkResponse(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.amber,
        child: Container(
            padding: widget.buttonSize == ButtonSize.large
                ? const EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                : widget.buttonSize == ButtonSize.medium
                    ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                    : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  widget.buttonVarient == ButtonVarient.filled && widget.enabled
                      ? AppColors.buttonColor
                      : widget.buttonVarient == ButtonVarient.filled &&
                              !widget.enabled
                          ? AppColors.buttonColorDisabled
                          : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: widget.enabled
                      ? AppColors.buttonColor
                      : AppColors.buttonColorDisabled,
                  width: 1),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 18, width: 18, child: CircularProgressIndicator())
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.prefixIcon != null
                          ? Row(
                              children: [
                                Icon(
                                  widget.prefixIcon,
                                  color: widget.buttonVarient ==
                                              ButtonVarient.outlined &&
                                          widget.enabled
                                      ? AppColors.buttonColor
                                      : widget.buttonVarient ==
                                                  ButtonVarient.outlined &&
                                              !widget.enabled
                                          ? AppColors.buttonColorDisabled
                                          : Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                            )
                          : const SizedBox.shrink(),
                      Text(
                        widget.text,
                        style: CustomFontStyle.paraMSemi(
                          widget.buttonVarient == ButtonVarient.outlined &&
                                  widget.enabled
                              ? AppColors.buttonColor
                              : widget.buttonVarient ==
                                          ButtonVarient.outlined &&
                                      !widget.enabled
                                  ? AppColors.buttonColorDisabled
                                  : Colors.white,
                        ),
                      ),
                      widget.suffixIcon != null
                          ? Row(
                              children: [
                                const SizedBox(width: 8),
                                Icon(
                                  widget.suffixIcon,
                                  color: widget.buttonVarient ==
                                              ButtonVarient.outlined &&
                                          widget.enabled
                                      ? AppColors.buttonColor
                                      : widget.buttonVarient ==
                                                  ButtonVarient.outlined &&
                                              !widget.enabled
                                          ? AppColors.buttonColorDisabled
                                          : Colors.white,
                                  size: 20,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  )),
      ),
    );
  }
}
