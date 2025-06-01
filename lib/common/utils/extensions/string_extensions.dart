import 'package:talent_mesh/common/app_enums.dart';

extension StringExtensions on String {
  Role get userRole {
    switch (toLowerCase()) {
      case 'admin':
        return Role.admin;
      case 'candidate':
        return Role.candidate;
      case 'recruiter':
        return Role.recruiter;
      default:
        return Role.none;
    }
  }

  ApplicationStatus get applicationStatus {
    switch (toLowerCase()) {
      case 'pending':
        return ApplicationStatus.applied;
      case 'hired':
        return ApplicationStatus.hired;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'interview':
        return ApplicationStatus.interview;
      case 'review':
        return ApplicationStatus.review;
      case 'shortlisted':
        return ApplicationStatus.shortlisted;
      default:
        return ApplicationStatus.applied;
    }
  }

  JobFilters get filterType {
    switch (this) {
      case 'Domain':
        return JobFilters.domains;
      case 'Experience Level':
        return JobFilters.experienceLevels;
      case 'Skill':
        return JobFilters.skills;
      case 'Location':
        return JobFilters.locations;
      case 'Salary Range':
        return JobFilters.salaryRange;
      case 'Employment Type':
        return JobFilters.employmentType;
      default:
        return JobFilters.none;
    }
  }

  JobStatus get jobStatus {
    switch (toLowerCase()) {
      case 'draft':
        return JobStatus.draft;
      case 'active':
        return JobStatus.active;
      case 'filled':
        return JobStatus.filled;
      case 'closed':
        return JobStatus.closed;
      default:
        return JobStatus.draft;
    }
  }

  String toPascalCase() {
    if (isEmpty) {
      return '';
    }

    // Handle camelCase by splitting on uppercase letters
    String processedString = replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    // Split the string by non-alphanumeric characters and spaces
    List<String> words = processedString
        .split(
          RegExp(r'[^a-zA-Z0-9]'),
        )
        .where((word) => word.isNotEmpty)
        .toList();

    // Capitalize first letter of each word and join them with spaces
    return words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() +
          (word.length > 1 ? word.substring(1).toLowerCase() : '');
    }).join(' ');
  }

  String? toCurrency() {
    // First, try to parse the string as an integer
    final intValue =
        int.tryParse(replaceAll(',', '')); // Remove commas if present
    if (intValue == null) {
      return this; // Return the original string if parsing fails
    }

    // Format the integer with commas and append ₹ symbol
    return '₹ ${intValue.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')}';
  }

  String toCapitalized() {
    return length > 0
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '';
  }

  String getDaysAgo() {
    // Parse the ISO string to DateTime
    final dateTime = DateTime.parse(this);
    final now = DateTime.now();

    // Calculate the difference in days
    final difference = now.difference(dateTime).inDays;

    // Return appropriate string based on the difference
    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference < 30) {
      return "$difference days ago";
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return months == 1 ? "1 month ago" : "$months months ago";
    } else {
      final years = (difference / 365).floor();
      return years == 1 ? "1 year ago" : "$years years ago";
    }
  }

  /// Converts a time string in 12-hour format (e.g., "2:30 pm") to 24-hour format (e.g., "14:30:00")
  /// The [end] parameter determines whether to convert the start or end time.
  /// If [end] is true, it converts the end time; otherwise, it converts the start time.
  /// Returns the converted time in "HH:MM:00" format.
  /// If the input format is invalid, it returns "Invalid time format".
  String getTimeIn24HourFormat({bool end = false}) {
    try {
      // Split the time string at "to" to get start and end times
      List<String> times = toLowerCase().split(' to ');
      if (times.length != 2) {
        return "Invalid time format";
      }

      // Extract the time based on whether we want start or end time
      String timeToConvert = end ? times[1].trim() : times[0].trim();

      // Parse the time
      bool isPM = timeToConvert.contains('pm');
      String time =
          timeToConvert.replaceAll('am', '').replaceAll('pm', '').trim();
      List<String> timeParts = time.split(':');

      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);

      // Convert to 24-hour format
      if (isPM && hours < 12) {
        hours += 12;
      } else if (!isPM && hours == 12) {
        hours = 0;
      }

      // Format and return as HH:MM:00
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:00";
    } catch (e) {
      return "Invalid time format";
    }
  }

  String toCommaSeparatedFormat({bool addSpace = false}) {
    // Convert to string first
    String numStr = toString();

    // For numbers with decimal parts
    if (numStr.contains('.')) {
      List<String> parts = numStr.split('.');
      String integerPart = parts[0];
      String decimalPart = parts[1];

      return '${_formatIntegerPart(integerPart, addSpace: addSpace)}.$decimalPart/-';
    } else {
      // For whole numbers
      return _formatIntegerPart(numStr, addSpace: addSpace);
    }
  }

  String _formatIntegerPart(String numStr, {bool addSpace = false}) {
    // Handle negative numbers
    bool isNegative = numStr.startsWith('-');
    if (isNegative) {
      numStr = numStr.substring(1);
    }

    // Format according to Indian number system
    int len = numStr.length;

    if (len <= 3) {
      return isNegative ? '-₹$numStr' : '₹$numStr';
    }

    // First part (rightmost 3 digits)
    String result = numStr.substring(len - 3);
    int remaining = len - 3;
    int pos = remaining;

    // Rest in groups of 2
    while (pos > 0) {
      if (pos >= 2) {
        result = '${numStr.substring(pos - 2, pos)},$result';
        pos -= 2;
      } else {
        result = '${numStr.substring(0, pos)},$result';
        pos = 0;
      }
    }

    return isNegative
        ? '-₹$result'
        : addSpace
            ? '₹ $result'
            : '₹$result';
  }
}
