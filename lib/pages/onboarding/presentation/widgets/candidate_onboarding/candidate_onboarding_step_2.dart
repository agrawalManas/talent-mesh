import 'package:talent_mesh/common/utils/extensions/context_extensions.dart';
import 'package:talent_mesh/common/utils/extensions/enum_extensions.dart';
import 'package:talent_mesh/common/utils/utils.dart';
import 'package:talent_mesh/common/widgets/chip/chip_selector.dart';
import 'package:talent_mesh/common/widgets/textfield/custom_textfield_with_label.dart';
import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart';
import 'package:talent_mesh/pages/onboarding/domain/candidate/candidate_onboarding_cubit.dart';
import 'package:talent_mesh/pages/onboarding/domain/onboarding_cubit.dart';
import 'package:talent_mesh/pages/onboarding/domain/onboarding_state.dart';
import 'package:talent_mesh/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidateOnboardingStep2 extends StatefulWidget {
  const CandidateOnboardingStep2({
    super.key,
  });

  @override
  State<CandidateOnboardingStep2> createState() =>
      _CandidateOnboardingStep2State();
}

class _CandidateOnboardingStep2State extends State<CandidateOnboardingStep2> {
  late CandidateOnboardingCubit _candidateOnboardingCubit;

  @override
  void initState() {
    super.initState();
    _candidateOnboardingCubit = context.read<CandidateOnboardingCubit>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tell us about your professional background",
            style: AppTextStyles.body2SemiBold16(
              color: context.userRole.accentColor,
            ),
          ),
          24.verticalSpace,

          //-------Summary
          CustomTextfieldWithLabel(
            isRequired: true,
            labelText: 'Professional Summary',
            controller: _candidateOnboardingCubit.summaryController,
            maxLines: 5,
            hintText:
                'Write a brief summary about your professional background, experience, and career goals.',
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
          ),
          24.verticalSpace,

          //----------Experience Level
          Text(
            "Experience Level",
            style: AppTextStyles.body3SemiBold14(),
          ),
          12.verticalSpace,
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final candidateOnboardingState = _candidateOnboardingCubit.state;
              return ChipSelector<ExperienceLevel?>(
                isMultiSelect: false,
                initiallySelectedOptions: [
                  candidateOnboardingState.candidateExperienceLevel
                ],
                borderRadius: 8.r,
                options: state.filters?.experienceLevels ?? [],
                getText: (value) {
                  return value?.name ?? '--';
                },
                getDescription: (value) {
                  return Utils.getExperienceYearsFromTo(value, 'to', 'years');
                },
                onSelectOption: (value) {
                  _candidateOnboardingCubit.onSelectCandidateExperienceLevel(
                    value.first,
                  );
                },
              );
            },
          ),
          // 12.verticalSpace,

          24.verticalSpace,

          //----------Preferred Domains
          Text(
            "Preferred Domains",
            style: AppTextStyles.body3SemiBold14(),
          ),
          12.verticalSpace,
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final candidateOnboardingState = _candidateOnboardingCubit.state;
              return ChipSelector<Filter>(
                initiallySelectedOptions:
                    candidateOnboardingState.candidatePreferredDomains ?? [],
                isMultiSelect: true,
                options: state.filters?.domains ?? [],
                getText: (value) {
                  return value.name ?? '-';
                },
                onSelectOption: (value) {
                  _candidateOnboardingCubit.onSelectCandidatePreferredDomains(
                    value,
                  );
                },
              );
            },
          ),
          40.verticalSpace,
        ],
      ),
    );
  }
}
