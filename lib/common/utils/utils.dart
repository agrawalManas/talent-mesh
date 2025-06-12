import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static const _uuid = Uuid();
  static void showToast({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(msg: message, toastLength: toastLength);
  }

  static String getUUID() {
    return _uuid.v1();
  }

  static Future<DateTime?> openDatePicker({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
  }) async {
    return showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
  }

  static String formatToddMMMYYYY(DateTime? dateTime) {
    if (dateTime == null) return "";
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  ///Shows a bottom sheet with the provided child widget.
  static Future<void> showBottomSheet({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    Color backgroundColor = Colors.white,
    double radius = 0,
    double elevation = 0,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      elevation: elevation,
      useSafeArea: true,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      builder: (context) {
        return child;
      },
    );
  }

  static String getExperienceYearsFromTo(
    ExperienceLevel? experience, [
    String separator = 'years to ',
    String suffix = 'years',
  ]) {
    return '${(experience?.yearsFrom ?? 0).toString().padLeft(1, '0')} $separator ${(experience?.yearsTo ?? 0).toString().padLeft(2)} $suffix';
  }
}
