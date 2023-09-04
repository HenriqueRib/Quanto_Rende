import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnacCustom {
  static success({String? title, String? message, int? duration}) {
    notificationBase(
      key: 'SnackbarSuccess',
      backgroundColor: Colors.green,
      title: title,
      message: message,
    );
  }

  static error({
    String? title,
    String? message,
  }) {
    notificationBase(
      key: 'SnackbarError',
      backgroundColor: Colors.red,
      title: title,
      message: message,
    );
  }

  static notificationBase({
    String? key,
    Color? backgroundColor,
    String? title,
    String? message,
  }) {
    showStyledToast(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.all(8.sp),
      contentPadding: const EdgeInsets.all(0),
      alignment: const Alignment(0, 0), //posiçao
      child: Dismissible(
        key: ValueKey<String>('$key'),
        child: Container(
          width: 0.9.sw,
          padding: EdgeInsets.all(7.sp),
          margin: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(7.sp),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 25.sp,
                color: Colors.white,
              ),
              SizedBox(
                width: 5.sp,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$title",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$message",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ToastManager.dismissAll();
                },
                iconSize: 25.sp,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      context: ToastProvider.context,
      animationBuilder: (context, animation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
