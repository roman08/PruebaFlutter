import 'package:Neobank/common/widgets/app_bars/base_app_bar.dart';
import 'package:Neobank/flows/sign_up_flow/screens/sign_up_screen/widgets/sign_up_form.dart';
import 'package:Neobank/resources/strings/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleString: AppStrings.SIGN_UP.tr()),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                child: SignUpForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
