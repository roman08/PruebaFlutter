import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/tabbed_app_bar.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../bloc/search/search_cubit.dart';
import '../bloc/search/search_state.dart';
import '../entity/bill_category_entity.dart';
import '../entity/bill_subcategory_entity.dart';
import 'pay_bill_subcategory_screen.dart';

class _PayBillScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle listTitleItem;
  final TextStyle listTitleItemBlue;
  final AppColorsOld colors;

  _PayBillScreenStyle({
    this.titleTextStyle,
    this.listTitleItem,
    this.listTitleItemBlue,
    this.colors,
  });

  factory _PayBillScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _PayBillScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      listTitleItem:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      listTitleItemBlue:
          theme.textStyles.r16.copyWith(color: theme.colors.primaryBlue),
      colors: theme.colors,
    );
  }
}

class PayBillScreen extends StatelessWidget {
  final _PayBillScreenStyle _style =
      _PayBillScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SearchCubit(_billCategory()),
        child: PayBill());
  }

  List<BillCategoryEntity> _billCategory() {
    return [
      BillCategoryEntity(
          title: "Airtime",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Mobile Data",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Cable/TV",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Utilities",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Schools", icon: SvgPicture.asset(IconsSVG.sendMoney)),
      BillCategoryEntity(
          title: "Transportation",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Flight/Hotel",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Taxes/Levies",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
      BillCategoryEntity(
          title: "Other Bills",
          icon: SvgPicture.asset(IconsSVG.sendMoney),
          subcategory: [
            BillSubcategoryEntity(
                title: "Provider 1",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 2",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 3",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
            BillSubcategoryEntity(
                title: "Provider 4",
                icon: SvgPicture.asset(IconsSVG.sendMoney)),
          ]),
    ];
  }
}

class PayBill extends StatelessWidget {
  final _PayBillScreenStyle _style =
      _PayBillScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return TabbedAppBar(
      choices: _billChoice(),
      title: AppStrings.BILLERS_MERCHANTS.tr(),
      leading: CupertinoButton(
        child: SvgPicture.asset(
          IconsSVG.arrowLeftIOSStyle,
          color: Get.theme.colorScheme.onBackground,
        ),
        onPressed: () => Get.back(),
      ),
      onSearchChange: (query) {
        context.read<SearchCubit>().filterList(query);
      },
      body: (choice) {
        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final items = state.list;
            return ListView(
              children: <Widget>[
                ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  padding: EdgeInsets.only(bottom: 8.h),
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index] as BillCategoryEntity;
                    return InkWell(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 21.w, 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: _style.colors.primaryBlue,
                                      shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 16.w),
                                  child: item.icon,
                                ),
                                Text(
                                  item.title,
                                  style: _style.listTitleItem,
                                )
                              ]),
                              SvgPicture.asset(IconsSVG.arrowRightIOSStyle)
                            ],
                          ),
                        ),
                        onTap: () => {Get.to(PayBillSubcategoryScreen(item))});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<TabBarChoice> _billChoice() {
    return <TabBarChoice>[
      TabBarChoice(title: AppStrings.APP_NAME),
      TabBarChoice(title: AppStrings.OTHERS),
    ];
  }
}
