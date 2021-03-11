import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/widgets/info_widgets.dart';
import '../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/app_text_theme.dart';
import '../../../../bloc/dashboard_bloc.dart';

class AppBarOverview extends StatelessWidget {
  const AppBarOverview();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DashboardBloc>(context);
    final hello = AppStrings.HELLO.tr();
    return StreamBuilder<String>(
        stream: bloc.nicknameObservable,
        builder: (context, snapshot) {
          String nickName = '';
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isNotEmpty) {
            nickName = snapshot.data;
          }
          return Row(
            children: <Widget>[
              const Spacer(),
              _avatar(context, nickName),
              const SizedBox(width: 10),
              Text('$hello, ',
                  style: Get.textTheme.headline5
                      .copyWith(color: Get.theme.colorScheme.onBackground)),
              Text('$nickName!',
                  style: Get.textTheme.headline5Bold
                      .copyWith(color: Get.theme.colorScheme.onBackground)),
              const Spacer(),
              // _overflowButton(context),
            ],
          );
        });
  }

  Widget _avatar(BuildContext context, String username) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.extraLightShade, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        username.isNotEmpty ? username[0] : "?",
        style: Get.textTheme.headline5Bold.copyWith(
          color: Get.theme.colorScheme.boldShade,
          height: 1,
        ),
      ),
    );
  }

  Widget _overflowButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        showToast(context, "Will be available soon");
      },
      child: SvgPicture.asset(IconsSVG.overflow),
      color: Colors.transparent,
      padding: const EdgeInsets.all(0),
    );
  }
}
