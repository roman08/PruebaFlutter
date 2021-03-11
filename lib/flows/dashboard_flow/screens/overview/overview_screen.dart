import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/loader/loading_header.dart';
import '../../../../common/widgets/payments_method/entity/payment_method_entity.dart';
import '../../../../common/widgets/payments_method/payments_method.dart';
import '../../../../resources/colors/custom_color_scheme.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../kyc_flow/bloc/kyc_cubit.dart';
import '../../../kyc_flow/bloc/kyc_state.dart';
import '../../../kyc_flow/index.dart';
import '../../../kyc_flow/repository/kyc_repository.dart';
import '../../../transfer_money/request/request_money_screen.dart';
import '../../../transfer_money/send/send_by_contact/contacts_list_flow.dart';
import '../../../transfer_money/send/send_money_screen.dart';
import '../../bloc/bottom_navigation/bottom_navigation_bloc.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../destination_view.dart';
import '../../payments/screen/pay_bill_screen.dart';
import 'widgets/app_bar/app_bar_overview.dart';
import 'widgets/wallets/wallets.dart';
import 'widgets/whats_new/whats_new.dart';

class _OverviewScreenStyle {
  final TextStyle kycAlertTextStyle;
  final TextStyle kycAlertBoldTextStyle;
  final AppColorsOld colors;
  final AppTextStylesOld textStyles;

  _OverviewScreenStyle({
    this.kycAlertTextStyle,
    this.kycAlertBoldTextStyle,
    this.colors,
    this.textStyles,
  });

  factory _OverviewScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _OverviewScreenStyle(
      colors: theme.colors,
      kycAlertTextStyle: theme.textStyles.r14.copyWith(color: theme.colors.darkShade),
      kycAlertBoldTextStyle: theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
      textStyles: theme.textStyles,
    );
  }
}

class OverviewScreen extends StatefulWidget {
  const OverviewScreen();

  @override
  OverviewScreenState createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverviewScreen> {
  DashboardBloc _dashboardBloc;
  KycCubit _kycCubit;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _OverviewScreenStyle _style = _OverviewScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  void initState() {
    super.initState();
    _kycCubit = KycCubit(
      repository: context.repository<KycRepository>(),
    );
    _kycCubit.fetch();
    _dashboardBloc = Provider.of<DashboardBloc>(context, listen: false);
    _dashboardBloc.loadWallets();
    _dashboardBloc.getUserData();
  }

  @override
  void dispose() {
    _kycCubit.close();
    super.dispose();
  }

  void _onRefresh() async {
    _kycCubit.fetch();
    _dashboardBloc.loadWallets();
    _dashboardBloc.getUserData();
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppThemeOld>(context, listen: false);
    return Scaffold(
      backgroundColor: appTheme.colors.white,
      appBar: _appBar(context),
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          header: LoadingHeader(),
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _renderKYCAlert(),
                    _title(),
                    Wallets(style: WalletsStyle.fromOldTheme(appTheme)),
                    PaymentsMethod(
                      payments: _getMostPopularPayments(),
                      title: AppStrings.MOST_POPULAR_PAYMENTS.tr(),
                      actionTitle: AppStrings.ALL.tr(),
                      onPressed: () {
                        context.read<BottomNavigationCubit>().navigateTo(Navigation.payments);
                      },
                    ),
                    WhatsNew(style: WhatsNewStyle.fromOldTheme(appTheme)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) => BaseAppBar(
        toolbarHeight: 48.h,
        titleWidget: const AppBarOverview(),
        backgroundColor: Get.theme.colorScheme.primaryLight,
        isShowBack: false,
      );

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, top: 34),
      child: Text(AppStrings.OVERVIEW.tr(), style: _style.textStyles.m30.copyWith(color: _style.colors.darkShade)),
    );
  }

  Widget _renderKYCAlert() {
    return BlocBuilder(
      cubit: _kycCubit,
      builder: (context, state) {
        if (state is SuccessState) {
          return state.currentTier.level > 0
              ? const SizedBox()
              : CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    KYC().openAccountLevel(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      height: 69,
                      color: Get.theme.colorScheme.warning.withAlpha(25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(IconsSVG.info, color: Get.theme.colorScheme.warning),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: KYCStrings.ALERT_1.tr(),
                                        style: _style.kycAlertTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' ' + KYCStrings.ALERT_2.tr() + ' ',
                                            style: _style.kycAlertBoldTextStyle,
                                          ),
                                          TextSpan(
                                            text: KYCStrings.ALERT_3.tr(),
                                            style: _style.kycAlertTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              IconsSVG.arrowRightIOSStyle,
                              color: Get.theme.colorScheme.midShade,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  List<PaymentsMethodEntity> _getMostPopularPayments() {
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
}
