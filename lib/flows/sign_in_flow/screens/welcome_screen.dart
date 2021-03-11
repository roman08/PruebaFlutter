import 'package:Neobank/flows/sign_in_flow/screens/sign_in_screen/sign_in_screen.dart';
import 'package:Neobank/flows/sign_up_flow/screens/terms_policy_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../../common/widgets/app_buttons/button.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_png.dart';
import '../../../resources/strings/app_strings.dart';

class WelcomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(
          bottom: ScreenUtil.screenHeight <= 600 ? 40.h : 60.h,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
                children: [
                  PageContentWidget(
                    imagePath: IconsPNG.welcome,
                    title: AppStrings.WELCOME_SLOGAN.tr(),
                  ),
                  PageContentWidget(
                    imagePath: IconsPNG.welcome_2,
                    title: AppStrings.WELCOME_SLOGAN.tr(),
                  ),
                  PageContentWidget(
                    imagePath: IconsPNG.welcome_3,
                    title: AppStrings.WELCOME_SLOGAN.tr(),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.screenHeight <= 600 ? 16.h : 32.h),
            CirclePageIndicator(
              itemCount: 3,
              dotColor: Get.theme.colorScheme.boldShade.withOpacity(0.5),
              dotSpacing: 12.w,
              size: 5.w,
              selectedSize: 8.w,
              selectedDotColor: Get.theme.colorScheme.primary,
              currentPageNotifier: _currentPageNotifier,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  24.w, ScreenUtil.screenHeight <= 600 ? 24.h : 40.h, 24.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Button(
                      title: AppStrings.SIGN_IN.tr(),
                      onPressed: () => Get.to(SignInScreen()),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Button(
                      title: AppStrings.SIGN_UP.tr(),
                      color: Get.theme.colorScheme.onPrimary,
                      onPressColor: Get.theme.colorScheme.primaryExtraLight,
                      shadowColor: Get.theme.colorScheme.primaryLight,
                      textColor: Get.theme.colorScheme.primary,
                      onPressed: () => Get.to(TermsPolicyScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageContentWidget extends StatelessWidget {
  const PageContentWidget({this.imagePath, this.title});

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Image.asset(imagePath),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Get.textTheme.headline5.copyWith(
              color: Get.theme.colorScheme.boldShade,
            ),
          ),
        ),
      ],
    ),
  );
}
