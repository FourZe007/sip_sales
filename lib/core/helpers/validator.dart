import 'dart:developer';

import 'package:sip_sales_clean/core/helpers/formatter.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  ValidationResult.valid() : isValid = true, errorMessage = null;
  ValidationResult.invalid(this.errorMessage) : isValid = false;
}

class Validator {
  // Function to validate email
  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // No error
  }

  // Function to validate id
  static String? idValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Id is required';
    } else if (value.length < 16) {
      return 'Id must be at least 16 characters long';
    }
    return null; // No error
  }

  // Function to validate name
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    } else if (value.length < 6) {
      return 'Name must be at least 6 characters long';
    }
    return null; // No error
  }

  // Function to validate username
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (value.length < 6) {
      return 'Username must be at least 6 characters long';
    } else if (!RegExp(r'^[A-Z]{2,4}\d{3,5}$').hasMatch(value)) {
      return 'Invalid username format.';
    }
    return null; // No error
  }

  // Function to validate password
  static String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null; // No error
  }

  static ValidationResult morningBriefing({
    required bool isDescEmpty,
    required bool isImgInvalid,
  }) {
    final errors = <String>[];

    if (isDescEmpty) errors.add('deskripsi');
    if (isImgInvalid) errors.add('foto');

    if (errors.isNotEmpty) {
      String message;
      if (errors.length == 1) {
        message = '${errors[0]} tidak boleh kosong';
      } else {
        final allButLast = errors.sublist(0, errors.length - 1).join(', ');
        message = '$allButLast, dan ${errors.last} tidak boleh kosong';
      }

      return ValidationResult.invalid('$message.');
    }

    return ValidationResult.valid();
  }

  static ValidationResult visitMarket({
    required bool isActEmpty,
    required bool isUnitDisplayEmpty,
    required bool isUnitTestEmpty,
    required bool isImgInvalid,
  }) {
    final errors = <String>[];

    if (isActEmpty) errors.add('jenis aktivitas');
    if (isUnitDisplayEmpty) errors.add('unit display');
    if (isUnitTestEmpty) errors.add('unit test');
    if (isImgInvalid) errors.add('foto');

    if (errors.isNotEmpty) {
      log(errors.toString());
      String message;
      if (errors.length == 1) {
        message = '${Formatter.toTitleCase(errors[0])} tidak boleh kosong';
      } else if (errors.length == 2) {
        message =
            '${Formatter.toTitleCase(errors[0])} dan ${errors[1]} tidak boleh kosong';
      } else {
        final allButFirst = errors.first;
        final all = errors.sublist(1, errors.length - 1).join(', ');
        final allButLast = errors.last;
        message =
            '${Formatter.toTitleCase(allButFirst)}, $all, dan $allButLast tidak boleh kosong';
      }

      return ValidationResult.invalid('$message.');
    }

    return ValidationResult.valid();
  }

  static ValidationResult recruitment({
    required bool isMediaEmpty,
    required bool isPositionEmtpy,
    required bool isImgInvalid,
  }) {
    final errors = <String>[];

    if (isMediaEmpty) errors.add('media');
    if (isPositionEmtpy) errors.add('posisi');
    if (isImgInvalid) errors.add('foto');

    if (errors.isNotEmpty) {
      log(errors.toString());
      String message;
      if (errors.length == 1) {
        message = '${Formatter.toTitleCase(errors[0])} tidak boleh kosong';
      } else if (errors.length == 2) {
        message =
            '${Formatter.toTitleCase(errors[0])} dan ${errors[1]} tidak boleh kosong';
      } else {
        final allButFirst = errors.first;
        final all = errors.sublist(1, errors.length - 1).join(', ');
        final allButLast = errors.last;
        message =
            '${Formatter.toTitleCase(allButFirst)}, $all, dan $allButLast tidak boleh kosong';
      }

      return ValidationResult.invalid('$message.');
    }

    return ValidationResult.valid();
  }

  static ValidationResult interview({
    required bool isImgInvalid,
  }) {
    final errors = <String>[];

    if (isImgInvalid) errors.add('foto');

    if (errors.isNotEmpty) {
      log(errors.toString());
      String message = '${Formatter.toTitleCase(errors[0])} tidak boleh kosong';

      return ValidationResult.invalid('$message.');
    }

    return ValidationResult.valid();
  }
}

// final allButLast = errors.sublist(0, errors.length - 1).join(', ');
