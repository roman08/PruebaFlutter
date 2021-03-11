import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_bars/search_bar.dart';
import '../../../../common/widgets/info_widgets.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../bloc/search/search_cubit.dart';
import '../bloc/search/search_state.dart';
import '../entity/bill_category_entity.dart';
import '../entity/bill_subcategory_entity.dart';

class _PayBillSubcategoryScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle listTitleItem;
  final AppColorsOld colors;

  _PayBillSubcategoryScreenStyle({
    this.titleTextStyle,
    this.listTitleItem,
    this.colors,
  });

  factory _PayBillSubcategoryScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _PayBillSubcategoryScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      listTitleItem:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class PayBillSubcategoryScreen extends StatelessWidget {
  const PayBillSubcategoryScreen(this._category);

  final BillCategoryEntity _category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(_category.subcategory),
      child: PayBillSubcategory(_category),
    );
  }
}

class PayBillSubcategory extends StatelessWidget {
  PayBillSubcategory(this._category);

  final _PayBillSubcategoryScreenStyle _style =
      _PayBillSubcategoryScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final BillCategoryEntity _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, _category.title),
      body: BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
        return ListView.builder(
          itemCount: state.list.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (BuildContext context, int index) {
            final item = state.list[index] as BillSubcategoryEntity;
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
                onTap: () => {showToast(context, "Will be available soon")});
          },
        );
      }),
    );
  }

  BaseAppBar _appBar(BuildContext context, String title) => BaseAppBar(
        titleString: title,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44.0.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SearchBar(
              onSearchChange: (query) {
                context.read<SearchCubit>().filterList(query);
              },
              margin: EdgeInsets.zero,
            ),
          ),
        ),
      );
}
