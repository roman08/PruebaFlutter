import 'dart:math';

import 'package:Neobank/resources/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../resources/fonts/app_fonts.dart';
import '../../../../../../resources/icons/icons_png.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../../transfer_money/payments/screen/payment_category_list_screen.dart';
import '../../../../../transfer_money/send/send_money_screen.dart';

class WalletsTileForm {
  final String balance;
  final String currencyCode;
  final String id;
  final bool isChangeGradientColor;

  /// Round the balance according to required amount of decimal places
  String get balanceRounded =>
      double.tryParse(balance) != null ? double.tryParse(balance).toStringAsFixed(BALANCE_DECIMAL_PLACES) : '0.00';

  WalletsTileForm({
    this.balance,
    this.currencyCode,
    this.id,
    this.isChangeGradientColor,
  });
}

class WalletsTileStyle {
  final TextStyle currencyTextStyle;
  final TextStyle balanceTextStyle;
  final TextStyle currencyBalanceTextStyle;
  final TextStyle buttonTextStyle;
  final TextStyle idTextStyle;

  WalletsTileStyle(
      {this.currencyTextStyle,
      this.balanceTextStyle,
      this.currencyBalanceTextStyle,
      this.buttonTextStyle,
      this.idTextStyle});

  factory WalletsTileStyle.fromOldTheme(AppThemeOld theme) {
    return WalletsTileStyle(
        currencyTextStyle: theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
        balanceTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
        currencyBalanceTextStyle: theme.textStyles.r14.copyWith(color: theme.colors.darkShade),
        buttonTextStyle: theme.textStyles.sm12.copyWith(color: theme.colors.white),
        idTextStyle: theme.textStyles.sr12.copyWith(color: theme.colors.darkShade));
  }
}

class WalletTile extends StatelessWidget {
  final WalletsTileForm form;
  final WalletsTileStyle style;

  const WalletTile({
    Key key,
    this.form,
    this.style,
  }) : super(key: key);

  get paymentsType => null;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(form.isChangeGradientColor ? IconsPNG.cardGradientBlue : IconsPNG.cardGradientGreen),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
              child: Column(
            children: <Widget>[header(context), const Spacer(), footer(context)],
          )),
        )
      ],
    );
  }

  Widget header(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_balance(context), const Spacer(), _infoButton(context)],
      ),
    );
  }

  Widget _balance(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    const screenWidthIPhoneSE = 320;
    final Text balanceText = Text(
      form.balanceRounded,
      style: style.balanceTextStyle,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
    final Text currencyCodeText = Text(
      " ${form.currencyCode}",
      style: style.currencyBalanceTextStyle,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(form.currencyCode, style: style.currencyTextStyle),
            Text(" ${AppStrings.WALLET.tr()}", style: style.currencyTextStyle.copyWith(fontFamily: AppFonts.GRAPHIK)),
          ],
        ),
        const SizedBox(height: 2),

        // Settings for iPhone SE: The optimal width for the balance value without text overflow is 210 (determined experimentally)
        if (currentScreenWidth == screenWidthIPhoneSE)
          SizedBox(
            width: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Flexible(child: balanceText),
                currencyCodeText,
              ],
            ),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              balanceText,
              currencyCodeText,
            ],
          )
      ],
    );
  }

  Widget _infoButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
          width: 20,
          child: IconButton(
            onPressed: () => null,
            icon: Opacity(
              opacity: 0.5,
              child: SvgPicture.asset(IconsSVG.info),
            ),
            padding: const EdgeInsets.all(0),
          ),
        )
      ],
    );
  }

  Widget footer(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[_actionButtonsBlock(context), const Spacer(), _id(context)],
    ));
  }

  Widget _actionButtonsBlock(BuildContext context) {
    return Row(
      children: <Widget>[
        _sendButton(context),
        const SizedBox(width: 10),
        _addFundsButton(context),
        const SizedBox(width: 10),
        _withdrawButton(context)
      ],
    );
  }

  Widget _sendButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(SendMoneyScreen()),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0.75,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
              SvgPicture.asset(IconsSVG.arrowRight),
            ],
          ),
          const SizedBox(height: 9),
          Text(AppStrings.SEND.tr(), style: style.buttonTextStyle)
        ],
      ),
    );
  }

  Widget _addFundsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(PaymentCategoryListScreen(
        currencyCode: form.currencyCode,
        paymentsType: PaymentsType.add_funds,
      )),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0.75,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
              SvgPicture.asset(IconsSVG.plus),
            ],
          ),
          const SizedBox(height: 9),
          Text(AppStrings.ADD_FUNDS.tr(), style: style.buttonTextStyle)
        ],
      ),
    );
  }

  Widget _withdrawButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(PaymentCategoryListScreen(
        currencyCode: form.currencyCode,
        paymentsType: PaymentsType.withdraw,
      )),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0.75,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
              Transform.rotate(
                angle: pi / 2,
                child: SvgPicture.asset(IconsSVG.arrowRight),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(AppStrings.WITHDRAW.tr(), style: style.buttonTextStyle)
        ],
      ),
    );
  }

  Widget _id(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(AppStrings.WALLET_ID.tr(), style: style.idTextStyle),
        const SizedBox(height: 3),
        Text('*${form.id}', style: style.idTextStyle),
      ],
    );
  }
}
