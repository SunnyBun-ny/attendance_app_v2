import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class CustomTextfields extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String? labelText;
  String? errorText;
  IconData? prefixIcon;
  IconData? suffixIcon;
  VoidCallback? onTapSuffixIcon;
  bool obscureText;
  bool enabled;

  CustomTextfields({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  State<CustomTextfields> createState() => _CustomTextfieldsState();
}

class _CustomTextfieldsState extends State<CustomTextfields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.labelText == null
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Text(widget.labelText as String,
                          style: CustomFontStyle.paraSMedium(
                              AppColors.neutralGrey700)),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
            TextField(
              controller: widget.controller,
              style: CustomFontStyle.paraMRegular(AppColors.neutralGrey900),
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                  enabled: widget.enabled,
                  contentPadding: const EdgeInsets.only(
                      left: 12, right: 8, top: 8, bottom: 8),
                  hintText: widget.hintText,
                  hintStyle: CustomFontStyle.paraMRegular(
                    AppColors.neutralGrey500,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(widget.prefixIcon as IconData,
                                size: 20, color: AppColors.neutralGrey500),
                            const SizedBox(
                              width: 4,
                            )
                          ],
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: widget.onTapSuffixIcon,
                              child: Icon(widget.suffixIcon as IconData,
                                  size: 20, color: AppColors.neutralGrey900),
                            ),
                          ],
                        )
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: widget.errorText == null
                              ? AppColors.neutralGrey400
                              : AppColors.alertRed,
                          width: 1))),
            )
          ],
        ),
        widget.errorText == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      widget.errorText as String,
                      style: CustomFontStyle.paraSRegular(AppColors.alertRed),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
