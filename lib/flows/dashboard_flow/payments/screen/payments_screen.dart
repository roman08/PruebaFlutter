import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/payments_method/entity/payment_method_entity.dart';
import '../../../../common/widgets/payments_method/payments_method.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../transfer_money/screens/iwt/iwt_screen.dart';
import '../../../transfer_money/screens/owt/owt_screen.dart';
import '../../../transfer_money/request/request_money_screen.dart';
import '../../../transfer_money/send/send_by_contact/contacts_list_flow.dart';
import '../../../transfer_money/send/send_money_screen.dart';
import 'pay_bill_screen.dart';

class _PaymentsScreenStyle {
  final TextStyle titleTextStyle;
  final AppColorsOld colors;

  _PaymentsScreenStyle({
    this.titleTextStyle,
    this.colors,
  });

  factory _PaymentsScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _PaymentsScreenStyle(
      titleTextStyle:
          theme.textStyles.m30.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  final _PaymentsScreenStyle _style =
      _PaymentsScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 89.h),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    AppStrings.PAYMENTS.tr(),
                    textAlign: TextAlign.start,
                    style: _style.titleTextStyle,
                  ),
                ),
              ),
              PaymentsMethod(
                payments: _getPayments(context),
                title: AppStrings.OTHER_SERVICES.tr(),
              ),
              PaymentsMethod(
                payments: _getOtherServices(context),
                title: AppStrings.OTHER_SERVICES.tr(),
              ),
              PaymentsMethod(
                payments: _getIWTOWT(context),
                title: 'IWT / OWT',
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PaymentsMethodEntity> _getPayments(BuildContext context) {
    return [
      PaymentsMethodEntity(
        title: AppStrings.SEND_MONEY.tr(),
        icon: IconsSVG.sendMoney,
        onPressed: () => Get.to(SendMoneyScreen()),
      ),
      PaymentsMethodEntity(
        title: AppStrings.REQUEST_MONEY.tr(),
        icon: IconsSVG.requestMoney,
        onPressed: () => Get.to(RequestMoneyScreen()),
      ),
      PaymentsMethodEntity(
        title: AppStrings.PAY_BILLS.tr(),
        icon: IconsSVG.requestMoney,
        onPressed: () => Get.to(PayBillScreen()),
      ),
      PaymentsMethodEntity(
        title: AppStrings.PAY_INVOICE.tr(),
        icon: IconsSVG.requestMoney,
        isEnable: false,
        onPressed: () => Navigator.of(context).pushNamed(ContactListFlow.route),
      ),
      PaymentsMethodEntity(
        title: AppStrings.SEND_INVOICE.tr(),
        icon: IconsSVG.requestMoney,
        isEnable: false,
        onPressed: () => Navigator.of(context).pushNamed(ContactListFlow.route),
      ),
    ];
  }

  List<PaymentsMethodEntity> _getOtherServices(BuildContext context) {
    return [
      PaymentsMethodEntity(
        title: AppStrings.CURRENCY_SWAP.tr(),
        icon: IconsSVG.sendMoney,
        isEnable: false,
        onPressed: () => Get.to(SendMoneyScreen()),
      ),
      PaymentsMethodEntity(
        title: AppStrings.BUY_INSURANCE.tr(),
        icon: IconsSVG.requestMoney,
        isEnable: false,
        onPressed: () => Get.to(RequestMoneyScreen()),
      ),
      PaymentsMethodEntity(
        title: AppStrings.BUY_STOCKS.tr(),
        icon: IconsSVG.requestMoney,
        isEnable: false,
        onPressed: () => Navigator.of(context).pushNamed(ContactListFlow.route),
      ),
      PaymentsMethodEntity(
        title: AppStrings.OPEN_BANK_ACCOUNT.tr(),
        icon: IconsSVG.requestMoney,
        isEnable: false,
        onPressed: () => Navigator.of(context).pushNamed(ContactListFlow.route),
      ),
    ];
  }

  List<PaymentsMethodEntity> _getIWTOWT(BuildContext context) {
    return [
      PaymentsMethodEntity(
        title: AppStrings.INCOMING_WIRE_TRANSFER.tr(),
        icon: IconsSVG.sendMoney,
        onPressed: () => Get.to(IWTScreen()),
      ),
      PaymentsMethodEntity(
        title: AppStrings.OUTGOING_WIRE_TRANSFER.tr(),
        icon: IconsSVG.requestMoney,
        onPressed: () => Get.to(const OWTScreen()),
      ),
    ];
  }
}
