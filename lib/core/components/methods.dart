import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';


class Methods {
  SnackBar errorSnackBar(String state) {
    return SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          contentType: ContentType.failure,
          title: "oh snap",
          message: state,
        ));
  }

  SnackBar successSnackBar(String msg) {
    return SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          contentType: ContentType.success,
          title: "Done",
          message: msg,
        ));
  }
}
