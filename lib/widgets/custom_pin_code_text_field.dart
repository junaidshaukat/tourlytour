import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/app_export.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.length = 6,
  });

  final int length;

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  final Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget)
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget {
    return PinCodeTextField(
      autoDisposeControllers: false,
      autoDismissKeyboard: true,
      appContext: context,
      controller: controller,
      length: length,
      keyboardType: TextInputType.number,
      textStyle: textStyle,
      hintStyle: hintStyle,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      enableActiveFill: true,
      pinTheme: PinTheme(
        fieldHeight: 60.h,
        fieldWidth: 50.h,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(14.h),
        inactiveFillColor: appTheme.blue5001,
        activeFillColor: appTheme.blue5001,
        inactiveColor: Colors.transparent,
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,
        selectedFillColor: appTheme.blue5001,
      ),
      onChanged: (value) => onChanged(value),
      validator: validator,
    );
  }
}
