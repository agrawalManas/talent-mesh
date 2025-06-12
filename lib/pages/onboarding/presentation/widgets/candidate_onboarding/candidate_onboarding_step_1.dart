import 'package:flutter/services.dart';
import 'package:talent_mesh/common/utils/extensions/context_extensions.dart';
import 'package:talent_mesh/common/utils/extensions/enum_extensions.dart';
import 'package:talent_mesh/common/widgets/date_picker/custom_date_picker_with_label.dart';
import 'package:talent_mesh/common/widgets/textfield/custom_textfield_with_label.dart';
import 'package:talent_mesh/pages/onboarding/domain/candidate/candidate_onboarding_cubit.dart';
import 'package:talent_mesh/pages/onboarding/domain/candidate/candidate_onboarding_state.dart';
import 'package:talent_mesh/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidateOnboardingStep1 extends StatefulWidget {
  const CandidateOnboardingStep1({
    super.key,
  });

  @override
  State<CandidateOnboardingStep1> createState() =>
      _CandidateOnboardingStep1State();
}

class _CandidateOnboardingStep1State extends State<CandidateOnboardingStep1> {
  late CandidateOnboardingCubit _candidateOnboardingCubit;

  @override
  void initState() {
    super.initState();
    _candidateOnboardingCubit = context.read<CandidateOnboardingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's start with your basic information",
            style: AppTextStyles.body2SemiBold16(
              color: context.userRole.accentColor,
            ),
          ),
          32.verticalSpace,

          // First Name
          CustomTextfieldWithLabel(
            isRequired: true,
            labelText: 'Full Name',
            hintText: 'Enter your name here',
            controller: _candidateOnboardingCubit.nameController,
            textInputAction: TextInputAction.next,
          ),
          24.verticalSpace,

          // Headline
          CustomTextfieldWithLabel(
            isRequired: true,
            labelText: 'Current Designation',
            hintText: 'e.g. Senior Software Engineer',
            controller: _candidateOnboardingCubit.designationController,
            textInputAction: TextInputAction.next,
          ),
          24.verticalSpace,

          // Phone Number
          CustomTextfieldWithLabel(
            isRequired: true,
            labelText: 'Phone Number',
            hintText: 'Enter your phone number here',
            controller: _candidateOnboardingCubit.numberController,
            textInputType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          24.verticalSpace,

          // Date of Birth
          BlocBuilder<CandidateOnboardingCubit, CandidateOnboardingState>(
            builder: (context, state) {
              return CustomDatePickerWithLabel(
                label: 'Date of Birth',
                firstDate: DateTime(
                  DateTime.now().year - 50,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                lastDate: DateTime(
                  DateTime.now().year - 10,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                initialValue: state.candidateDOB,
                isRequired: true,
                onChanged: (value) {
                  _candidateOnboardingCubit.onChangeDOB(value);
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
