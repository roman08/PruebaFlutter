import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class PaymentsTileForm {
  bool isEnable;
  final String text;
  final String icon;

  PaymentsTileForm({this.isEnable, this.text, this.icon}) {
    this.isEnable = isEnable ?? true;
  }
}

class PaymentsTileStyle {
  final TextStyle titleTextStyle;
  final TextStyle disableTitleTextStyle;
  final Color iconBackgroundColor;
  final Color disableIconBackgroundColor;
  final BoxShadow shadow;

  PaymentsTileStyle(
      {this.titleTextStyle,
      this.disableTitleTextStyle,
      this.iconBackgroundColor,
      this.disableIconBackgroundColor,
      this.shadow});

  factory PaymentsTileStyle.fromOldTheme(AppThemeOld theme) {
    return PaymentsTileStyle(
      titleTextStyle:
          theme.textStyles.sm12.copyWith(color: theme.colors.darkShade),
      disableTitleTextStyle:
          theme.textStyles.sm12.copyWith(color: theme.colors.boldShade),
      iconBackgroundColor: theme.colors.primaryBlue,
      disableIconBackgroundColor: theme.colors.lightShade,
      shadow: BoxShadow(
          color: theme.colors.darkShade.withOpacity(0.15),
          offset: const Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 1),
    );
  }
}

class MostPopularPaymentsTile extends StatelessWidget {
  final PaymentsTileForm form;
  final PaymentsTileStyle style;
  final GestureTapCallback onPress;

  const MostPopularPaymentsTile({Key key, this.form, this.style, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [style.shadow],
          borderRadius: BorderRadius.circular(16)),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          splashColor:
              !form.isEnable ? Colors.transparent : Colors.grey.shade500,
          highlightColor:
              !form.isEnable ? Colors.transparent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
          onTap: () => form.isEnable ? onPress.call() : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[_icon(context), _text(context)],
          ),
        ),
      ),
    );
  }

  Widget _icon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: form.isEnable
            ? style.iconBackgroundColor
            : style.disableIconBackgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      child: SvgPicture.asset(
        form.icon,
      ),
    );
  }

  Widget _text(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Text(
        form.text,
        style:
            form.isEnable ? style.titleTextStyle : style.disableTitleTextStyle,
        maxLines: 2,
      ),
    );
  }
}
