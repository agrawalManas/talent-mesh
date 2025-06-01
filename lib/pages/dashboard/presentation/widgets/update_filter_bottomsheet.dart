import 'package:flutter/services.dart';
import 'package:talent_mesh/common/app_enums.dart';
import 'package:talent_mesh/common/utils/extensions/context_extensions.dart';
import 'package:talent_mesh/common/utils/extensions/enum_extensions.dart';
import 'package:talent_mesh/common/utils/extensions/string_extensions.dart';
import 'package:talent_mesh/common/utils/textfield_input_formatters/currency_formatter.dart';
import 'package:talent_mesh/common/utils/textfield_input_formatters/year_suffix_formatter.dart';
import 'package:talent_mesh/common/widgets/bottomsheet/custom_bottomsheet_header.dart';
import 'package:talent_mesh/common/widgets/button/custom_button.dart';
import 'package:talent_mesh/common/widgets/textfield/custom_textfield_with_label.dart';
import 'package:talent_mesh/common/widgets/textfield/labeled_textfield_with_text_chip.dart';
import 'package:talent_mesh/pages/dashboard/domain/dashboard_cubit.dart';
import 'package:talent_mesh/pages/dashboard/domain/dashboard_state.dart';
import 'package:talent_mesh/styles/app_colors.dart';
import 'package:talent_mesh/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateFilterBottomsheet extends StatelessWidget {
  final String title;
  final String description;
  final bool isSalaryFilter;
  final DashboardCubit cubit;
  UpdateFilterBottomsheet({
    required this.title,
    required this.description,
    required this.cubit,
    this.isSalaryFilter = false,
    super.key,
  });

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBottomsheetHeader(
          title: description,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                _buildContent(title.filterType),
                32.verticalSpace,
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          bottom: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, -8),
                  spreadRadius: 0,
                  color: context.userRole.accentColor.withValues(alpha: 0.3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return CustomButton(
                    width: double.infinity,
                    verticalPadding: 4.h,
                    horizontalPadding: 8.w,
                    wantBorder: false,
                    isLoading: state.addFilterApiStatus == ApiStatus.loading,
                    buttonColor: context.userRole.accentColor,
                    disableElevation: true,
                    onPressed: () {
                      if (state.addFilterApiStatus != ApiStatus.loading) {
                        cubit.updateFilters(
                          filterType: title.filterType,
                          salary: (title.filterType == JobFilters.salaryRange)
                              ? cubit.setSalaryRange(
                                  min: _controller.text.trim(),
                                  max: _controller2.text.trim(),
                                )
                              : null,
                          experienceLevel:
                              (title.filterType == JobFilters.experienceLevels)
                                  ? cubit.setExperience(
                                      position: _controller.text.trim(),
                                      yearsFrom: _controller2.text.trim(),
                                      yearsTo: _controller3.text.trim(),
                                    )
                                  : null,
                          text: (title.filterType ==
                                      JobFilters.experienceLevels ||
                                  title.filterType == JobFilters.salaryRange)
                              ? null
                              : _controller.text.trim(),
                        );
                      }
                    },
                    child: Text(
                      'Update this Filter',
                      style: AppTextStyles.body2Medium16(
                        color: AppColors.surface,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(JobFilters filter) {
    switch (filter) {
      case JobFilters.experienceLevels:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextfieldWithLabel(
              labelText: 'Position',
              isRequired: true,
              hintText: 'eg. Associate',
              controller: _controller,
              fillColor: AppColors.surface,
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextfieldWithLabel(
                    labelText: 'From',
                    isRequired: true,
                    hintText: 'eg. 2',
                    controller: _controller2,
                    fillColor: AppColors.surface,
                    textInputAction: TextInputAction.next,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      YearsSuffixFormatter(),
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomTextfieldWithLabel(
                    labelText: 'To',
                    isRequired: false,
                    hintText: 'eg. 4',
                    controller: _controller3,
                    fillColor: AppColors.surface,
                    textInputAction: TextInputAction.done,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      YearsSuffixFormatter(),
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      case JobFilters.salaryRange:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextfieldWithLabel(
                    labelText: 'Minimum',
                    isRequired: true,
                    hintText: '2,00,000',
                    controller: _controller,
                    fillColor: AppColors.surface,
                    textInputAction: TextInputAction.next,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      CurrencyFormatter(),
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomTextfieldWithLabel(
                    labelText: 'Maximum',
                    isRequired: true,
                    hintText: '5,00,000',
                    controller: _controller2,
                    fillColor: AppColors.surface,
                    textInputAction: TextInputAction.done,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      CurrencyFormatter(),
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return LabeledTextfieldWithTextChip(
          controller: _controller,
          fillColor: AppColors.surface,
          labelText: title,
          hintText: _getHintText(title: title),
          isRequired: true,
          textInputAction:
              isSalaryFilter ? TextInputAction.next : TextInputAction.done,
          enableChips: true,
          onChipsChanged: (chips) {
            cubit.setFilters(chips);
          },
          chipDeleteIconColor: Colors.red,
        );
    }
  }

  String _getHintText({required String title}) {
    switch (title) {
      case 'Domain':
        return 'eg. Marketing, Content Writing';
      case 'Experience Level':
        return 'eg. 2 to 3';
      case 'Skill':
        return 'eg. Flutter, Android';
      case 'Location':
        return 'eg. Gurugram, Banglore';
      case 'Employment Type':
        return 'eg. Full-Time';
      default:
        return 'Type here...';
    }
  }
}
