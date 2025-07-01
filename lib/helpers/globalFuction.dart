
import 'package:flutter/material.dart';

import 'app_constante.dart';

enum SNACKBAR_TYPE { ERROR, WARNING, SUCCESS, LOADER }
Color getSnackbarColor(SNACKBAR_TYPE type) {
  if (type == SNACKBAR_TYPE.ERROR) {
    return AppColors.errorColor;
  } else if (type == SNACKBAR_TYPE.SUCCESS) {
    return AppColors.accentColor;
  } else if (type == SNACKBAR_TYPE.WARNING) {
    return AppColors.warningColor;
  } else if (type == SNACKBAR_TYPE.LOADER) {
    return AppColors.greyLight;
  } else {
    return AppColors.greyLight;
  }
}
