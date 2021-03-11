import 'package:Neobank/flows/sign_up_flow/screens/sign_up_screen/sign_up_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/utils/launcher_utils.dart';
import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../common/widgets/app_buttons/button.dart';
import '../../../networking/api_constants.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/app_text_theme.dart';

class TermsPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(),
            SizedBox(height: 24.h),
            _subTitle(),
            const Spacer(),
            _termsPrivacyBlock(context),
            SizedBox(height: 48.h),
            _button()
          ],
        ),
      ),
    );
  }

  Widget _appBar() => const BaseAppBar();

  Widget _title() => Text(
        AppStrings.LEGAL.tr(),
        style: Get.theme.textTheme.headline1Bold.copyWith(
          color: Get.theme.colorScheme.onSecondary,
        ),
      );

  Widget _subTitle() => Text(
        AppStrings.TERMS_AND_PRIVACY_REVIEW.tr(),
        style: Get.theme.textTheme.headline5.copyWith(
          color: Get.theme.colorScheme.onSecondary,
        ),
      );

  Widget _termsPrivacyBlock(BuildContext context) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.w)),
        border: Border.all(
          width: 1.0.h,
          color: Get.theme.colorScheme.extraLightShade,
        ),
      ),
      child: Column(
        // children: [
        //   ListTile(
        //     contentPadding: EdgeInsets.fromLTRB(24.w, 12.h, 28.w, 12.h),
        //     title: Text(
        //       AppStrings.TERMS_OF_SERVICE.tr(),
        //       style: Get.textTheme.headline5Bold.copyWith(
        //         color: Get.theme.colorScheme.onBackground,
        //       ),
        //     ),
        //     onTap: () => launchUrl(PublicApi.TERMS),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(16.w),
        //         topRight: Radius.circular(16.w),
        //       ),
        //     ),
        //     trailing: SvgPicture.asset(
        //       IconsSVG.arrowRightIOSStyle,
        //       width: 8.w,
        //       height: 13.h,
        //       color: Get.theme.colorScheme.boldShade,
        //     ),
        //   ),
        //   Divider(
        //     color: Get.theme.colorScheme.extraLightShade,
        //     thickness: 1.h,
        //     height: 1.h,
        //   ),
        //   ListTile(
        //     contentPadding: EdgeInsets.fromLTRB(24.w, 12.h, 28.w, 12.h),
        //     title: Text(
        //       AppStrings.PRIVACY_POLICY.tr(),
        //       style: Get.textTheme.headline5Bold.copyWith(
        //         color: Get.theme.colorScheme.onBackground,
        //       ),
        //     ),
        //     onTap: () => launchUrl(PublicApi.PRIVACY),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(16.w),
        //         bottomRight: Radius.circular(16.w),
        //       ),
        //     ),
        //     trailing: SvgPicture.asset(
        //       IconsSVG.arrowRightIOSStyle,
        //       width: 8.w,
        //       height: 13.h,
        //       color: Get.theme.colorScheme.boldShade,
        //     ),
        //   ),
        // ],
      ));

  Widget _button() => Button(
      title: AppStrings.ACCEPT.tr(), onPressed: () => Get.to(SignUpScreen()));
}
