import 'package:talent_mesh/common/models/user_model.dart';
import 'package:talent_mesh/common/utils/extensions/context_extensions.dart';
import 'package:talent_mesh/common/utils/extensions/enum_extensions.dart';
import 'package:talent_mesh/common/utils/extensions/string_extensions.dart';
import 'package:talent_mesh/common/utils/locator.dart';
import 'package:talent_mesh/styles/app_colors.dart';
import 'package:talent_mesh/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextfieldWithLabel extends StatefulWidget {
  const CustomTextfieldWithLabel({
    this.textInputAction,
    this.textInputType,
    this.titleSuffix,
    this.isRequired = false,
    this.readOnly = false,
    this.maxLength,
    this.currentLength,
    this.isElevated = true,
    this.showRequiredWithHint = false,
    this.hintText,
    this.errorText,
    this.suffixIcon,
    this.isPasswordFiled = false,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.enabled,
    this.controller,
    this.initialValue,
    this.autocorrect,
    this.autoFocus,
    this.prefixIcon,
    this.onSaved,
    this.hintStyle,
    this.labelStyle,
    this.textAlignVertical,
    this.fillColor,
    this.maxLines = 1,
    this.minLines,
    this.labelText,
    this.showLabelText,
    this.labelFontSize,
    this.borderRadius,
    this.textStyle,
    this.borderWidth = 1,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.contentPadding,
    this.prefixText,
    this.prefixWidget,
    this.focusedBorderColor,
    this.cursorColor,
    super.key,
  });

  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Widget? titleSuffix;
  final bool isRequired;
  final int? maxLength;
  final int? currentLength;
  final bool isElevated;
  final String? hintText;
  final String? initialValue;
  final String? errorText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPasswordFiled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool? enabled;
  final bool? autocorrect;
  final bool? autoFocus;
  final FormFieldSetter? onSaved;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextAlignVertical? textAlignVertical;
  final Widget? prefixIcon;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final String? labelText;
  final bool? showLabelText;
  final double? labelFontSize;
  final double? borderRadius;
  final double borderWidth;
  final bool showRequiredWithHint;
  final bool readOnly;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final EdgeInsets? contentPadding;
  final String? prefixText;
  final Widget? prefixWidget;
  final Color? focusedBorderColor;
  final Color? cursorColor;

  @override
  State<CustomTextfieldWithLabel> createState() =>
      _CustomTextfieldWithLabelState();
}

class _CustomTextfieldWithLabelState extends State<CustomTextfieldWithLabel> {
  Widget? customSuffixIcon;
  bool fieldIsNotEmpty = true;
  final FocusNode _focusNode = FocusNode();
  Color _focusedBorderColor = AppColors.primary;
  final user = dependencyLocator<UserModel>();
  late ValueNotifier<bool> _passwordFieldNotifier;

  @override
  void initState() {
    super.initState();
    customSuffixIcon = widget.suffixIcon;
    fieldIsNotEmpty = widget.controller?.text.isNotEmpty ?? false;
    _focusedBorderColor = (user.role ?? 'none').userRole.accentColor;
    _passwordFieldNotifier = ValueNotifier<bool>(widget.isPasswordFiled);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText?.isNotEmpty == true) ...[
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Text(
                  widget.labelText!,
                  style: widget.labelStyle ??
                      AppTextStyles.body4Medium12(
                        color: AppColors.textPrimary,
                      ),
                ),
                if (widget.isRequired == true)
                  Text(
                    '*',
                    style: AppTextStyles.body4Medium12(
                      color: AppColors.error,
                    ),
                  ),
                if (widget.titleSuffix != null) ...[
                  const Spacer(),
                  widget.titleSuffix!,
                ],
              ],
            ),
          ),
          6.verticalSpace,
        ],
        ValueListenableBuilder<bool>(
          valueListenable: _passwordFieldNotifier,
          builder: (context, value, child) {
            return TextFormField(
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              style: widget.textStyle ??
                  AppTextStyles.body3Regular14(color: AppColors.textPrimary),
              focusNode: _focusNode,
              onTapOutside: (_) {
                _focusNode.unfocus();
              },
              obscureText: value,
              cursorColor: widget.cursorColor ?? context.userRole.accentColor,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              keyboardType: widget.textInputType,
              textAlignVertical: widget.textAlignVertical,
              textInputAction: widget.textInputAction ?? TextInputAction.next,
              controller: widget.controller,
              enabled: widget.enabled,
              inputFormatters: widget.inputFormatters,
              autofocus: widget.autoFocus ?? false,
              validator: widget.validator,
              initialValue: widget.initialValue,
              onChanged: widget.onChanged,
              autocorrect: widget.autocorrect ?? true,
              onSaved: widget.onSaved,
              textCapitalization: widget.textCapitalization,
              decoration: InputDecoration(
                prefix: widget.prefixWidget,
                prefixText: widget.prefixText,
                prefixIcon: (widget.prefixIcon == null)
                    ? widget.isPasswordFiled
                        ? value
                            ? GestureDetector(
                                onTap: () {
                                  _passwordFieldNotifier.value = false;
                                },
                                child: const Icon(Icons.visibility_off),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _passwordFieldNotifier.value = true;
                                },
                                child: const Icon(Icons.visibility),
                              )
                        : null
                    : widget.prefixIcon,
                fillColor: widget.fillColor ?? AppColors.background,
                filled: true,
                hintText: widget.hintText,
                errorStyle: AppTextStyles.body4Regular12(
                  color: AppColors.error,
                ),
                labelStyle: widget.labelStyle ??
                    AppTextStyles.body3Regular14(
                      color: AppColors.textSecondary,
                    ),
                hintStyle: widget.hintStyle ??
                    AppTextStyles.body4Regular12(
                      color: AppColors.textSecondary,
                    ),
                alignLabelWithHint: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 24.r,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                    width: widget.borderWidth,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.borderRadius ?? 24.r),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.error,
                    width: widget.borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 24.r,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                    width: widget.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 24.r,
                  ),
                  borderSide: BorderSide(
                    color: widget.focusedBorderColor ?? _focusedBorderColor,
                    width: widget.borderWidth,
                  ),
                ),
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                suffixIcon: widget.suffixIcon,
              ),
            );
          },
        ),
        if (widget.errorText?.isNotEmpty == true) ...[
          2.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              widget.errorText!,
              style: AppTextStyles.body4Regular12(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
