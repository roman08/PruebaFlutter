import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../app.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../bloc/dashboard_bloc.dart';
import '../../../../entities/wallet_list_wrapper.dart';
import 'wallet_tile.dart';

class WalletsStyle {
  final TextStyle titleTextStyle;
  final Color primaryBlueColor;
  final Color slideIndicatorSelectedColor;
  final WalletsTileStyle walletTileStyle;
  final AppColorsOld colors;

  WalletsStyle({
    this.titleTextStyle,
    this.primaryBlueColor,
    this.slideIndicatorSelectedColor,
    this.walletTileStyle,
    this.colors,
  });

  factory WalletsStyle.fromOldTheme(AppThemeOld theme) {
    return WalletsStyle(
        titleTextStyle:
            theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
        primaryBlueColor: theme.colors.primaryBlue,
        slideIndicatorSelectedColor: theme.colors.boldShade.withOpacity(0.5),
        walletTileStyle: WalletsTileStyle.fromOldTheme(theme),
        colors: theme.colors);
  }
}

class Wallets extends StatefulWidget {
  final WalletsStyle style;

  const Wallets({this.style});

  @override
  WalletsState createState() => WalletsState();
}

class WalletsState extends State<Wallets> {
  final CarouselController _pageController = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DashboardBloc>(context);
    return Column(
      children: <Widget>[
        _title(context),
        StreamBuilder<List<Wallet>>(
            stream: bloc.walletListObservable,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    _walletSlider(context, snapshot.data),
                    _sliderIndicator(snapshot.data),
                  ],
                );
              } else {
                // TODO: Better to use shimmering loading. Need to discuss with team
                logger.i("Wallet list loading");
                return const SizedBox();
              }
            }),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 20, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(AppStrings.WALLETS.tr(), style: widget.style.titleTextStyle),
          GestureDetector(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: widget.style.colors.lightShade,
                  shape: BoxShape.circle),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                IconsSVG.plus,
                color: Get.theme.colorScheme.onPrimary,
              ),
            ),
            onTap: () => null,
          )
        ],
      ),
    );
  }

  Widget _walletSlider(BuildContext context, List<Wallet> forms) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        CarouselSlider.builder(
          options: CarouselOptions(
              height: 178,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 0.87,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          carouselController: _pageController,
          itemCount: forms.length,
          itemBuilder: (context, index) {
            return _walletTile(forms[index],
                isChangeGradientColor: index % 2 == 0);
          },
        ),
      ],
    );
  }

  Widget _sliderIndicator(List<dynamic> list) {
    const double dotSize = 5.0;
    const double dotsSpacing = 7.0;
    const double scaleFactor = 1.6;
    if (list.length > 1) {
      return Column(
        children: <Widget>[
          const SizedBox(height: 21),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map((item) {
              final int index = list.indexOf(item);
              return Container(
                width: _current == index ? dotSize * scaleFactor : dotSize,
                height: _current == index ? dotSize * scaleFactor : dotSize,
                margin: const EdgeInsets.symmetric(horizontal: dotsSpacing),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? widget.style.primaryBlueColor
                      : widget.style.slideIndicatorSelectedColor,
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  // isChangeGradientColor - managing card gradient colors for even and odd indices
  Widget _walletTile(dynamic wallet, {bool isChangeGradientColor}) {
    return WalletTile(
      form: WalletsTileForm(
          balance: wallet.balance,
          currencyCode: wallet.type.currencyCode,
          id: wallet.getShortNumberString(),
          isChangeGradientColor: isChangeGradientColor),
      style: widget.style.walletTileStyle,
    );
  }
}
