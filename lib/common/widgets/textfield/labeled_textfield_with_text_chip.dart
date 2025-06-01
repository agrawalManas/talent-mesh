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

class LabeledTextfieldWithTextChip extends StatefulWidget {
  const LabeledTextfieldWithTextChip({
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
    this.enableChips = false,
    this.onChipsChanged,
    this.chipStyle,
    this.chipDeleteIconColor,
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
  final bool enableChips;
  final Function(List<String>)? onChipsChanged;
  final TextStyle? chipStyle;
  final Color? chipDeleteIconColor;

  @override
  State<LabeledTextfieldWithTextChip> createState() =>
      _LabeledTextfieldWithTextChipState();
}

class _LabeledTextfieldWithTextChipState
    extends State<LabeledTextfieldWithTextChip> {
  Widget? customSuffixIcon;
  bool fieldIsNotEmpty = true;
  final FocusNode _focusNode = FocusNode();
  Color _focusedBorderColor = AppColors.primary;
  final user = dependencyLocator<UserModel>();
  late ValueNotifier<List<String>> _chipsNotifier;
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    customSuffixIcon = widget.suffixIcon;
    fieldIsNotEmpty = widget.controller?.text.isNotEmpty ?? false;
    _focusedBorderColor = (user.role ?? 'none').userRole.accentColor;
    _chipsNotifier = ValueNotifier<List<String>>([]);

    // Use provided controller or create internal one
    _internalController = widget.controller ?? TextEditingController();

    // Initialize chips from initial value if provided
    if (widget.initialValue?.isNotEmpty == true && widget.enableChips) {
      final initialChips = widget.initialValue!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _chipsNotifier.value = initialChips;
      _internalController.clear();
    }
  }

  @override
  void dispose() {
    _chipsNotifier.dispose();
    // Only dispose internal controller if we created it
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged(String value) {
    if (widget.enableChips && value.contains(',')) {
      final parts = value.split(',');
      final newChipText = parts.first.trim();

      if (newChipText.isNotEmpty) {
        // Add new chip with case-insensitive duplicate check
        final currentChips = List<String>.from(_chipsNotifier.value);
        final chipExistsIgnoreCase = currentChips.any(
          (chip) => chip.toLowerCase() == newChipText.toLowerCase(),
        );

        if (!chipExistsIgnoreCase) {
          currentChips.add(newChipText);
          _chipsNotifier.value = currentChips;
          widget.onChipsChanged?.call(currentChips);
        }
      }

      // Clear the text field or set remaining text
      final remainingText = parts.length > 1 ? parts.sublist(1).join(',') : '';
      _internalController.text = remainingText;
      _internalController.selection = TextSelection.fromPosition(
        TextPosition(offset: remainingText.length),
      );
    }

    // Call original onChanged callback
    widget.onChanged?.call(value);
  }

  void _removeChip(int index) {
    final currentChips = List<String>.from(_chipsNotifier.value);
    currentChips.removeAt(index);
    _chipsNotifier.value = currentChips;
    widget.onChipsChanged?.call(currentChips);
  }

  Widget _buildChipsWidget() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _chipsNotifier,
      builder: (context, chips, child) {
        if (chips.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.only(top: 8.h),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: chips.asMap().entries.map((entry) {
              final index = entry.key;
              final chip = entry.value;

              return Chip(
                label: Text(
                  chip,
                  style: widget.chipStyle ??
                      AppTextStyles.body4SemiBold12(
                        color: user.role?.userRole.accentColor,
                      ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: 16.r,
                  color: widget.chipDeleteIconColor ?? AppColors.textSecondary,
                ),
                onDeleted: () => _removeChip(index),
                backgroundColor:
                    user.role?.userRole.accentColor.withValues(alpha: 0.1),
                side: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        );
      },
    );
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
        TextFormField(
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          style: widget.textStyle ??
              AppTextStyles.body3Regular14(color: AppColors.textPrimary),
          focusNode: _focusNode,
          onTapOutside: (_) {
            _focusNode.unfocus();
          },
          cursorColor: widget.cursorColor ?? context.userRole.accentColor,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          keyboardType: widget.textInputType,
          textAlignVertical: widget.textAlignVertical,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          controller: _internalController,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autoFocus ?? false,
          validator: widget.validator,
          initialValue: widget.controller != null ? null : widget.initialValue,
          onChanged: _handleTextChanged,
          autocorrect: widget.autocorrect ?? true,
          onSaved: widget.onSaved,
          textCapitalization: widget.textCapitalization,
          decoration: InputDecoration(
            prefix: widget.prefixWidget,
            prefixText: widget.prefixText,
            prefixIcon: widget.prefixIcon,
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
        ),
        if (widget.enableChips) _buildChipsWidget(),
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
