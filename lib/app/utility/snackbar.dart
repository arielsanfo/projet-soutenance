import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/globalFuction.dart';
import 'package:get/get.dart';

import '../../helpers/app_constante.dart';

CustomSnackBar(String message, SNACKBAR_TYPE type,
    {String? title, Function()? ontap}) {
  Get.showSnackbar(GetSnackBar(
    borderRadius: 25,
    borderColor: getSnackbarColor(type),
    padding: EdgeInsets.all(AppSpacings.xs),
    margin: EdgeInsets.all(AppSpacings.xs),
    borderWidth: 0.7,
    //duration: Duration(milliseconds: 3000),
    progressIndicatorBackgroundColor: AppColors.tagGreenText,
    progressIndicatorValueColor:
        AlwaysStoppedAnimation<Color>(AppColors.tagRedText),
    showProgressIndicator: false,
    titleText: title != null
        ? Text(
            title.toString(),
            style: AppTypography.bodyMedium.apply(
              color: AppColors.backgroundWhite,
            ),
          )
        : null,
    shouldIconPulse: true,
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      message,
      style: AppTypography.bodyMedium.apply(
        color: AppColors.backgroundWhite,
      ),
    ),
    backgroundColor: getSnackbarColor(type),
    mainButton: SnackBarAction(
      label: "OK",
      backgroundColor: AppColors.backgroundWhite,
      textColor: AppColors.greyDark,
      onPressed: ontap != null
          ? ontap
          : () {
              Get.closeAllSnackbars();
            },
    ),
  ));
}
