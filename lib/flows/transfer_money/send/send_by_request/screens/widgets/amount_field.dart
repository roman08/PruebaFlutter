import 'package:Neobank/flows/transfer_money/enities/common/common_preview_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../../app.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../bloc/send_by_request_bloc.dart';

class AmountFieldStyle {
  final TextStyle feeTextStyle;
  final String lockIcon;

  AmountFieldStyle({this.feeTextStyle, this.lockIcon});

  factory AmountFieldStyle.fromOldTheme(AppThemeOld theme) {
    return AmountFieldStyle(
      feeTextStyle: theme.textStyles.r16.copyWith(color: theme.colors.primaryBlue),
      lockIcon: IconsSVG.lock,
    );
  }
}

class AmountField extends StatefulWidget {
  final bool isEnable;
  final bool feeLoadInProgress;
  final ValueChanged<String> onAmountChange;
  final TextEditingController controller;
  final SendByRequestBloc bloc;

  const AmountField({
    this.isEnable,
    this.feeLoadInProgress = false,
    this.onAmountChange,
    this.controller,
    this.bloc,
  });

  @override
  _AmountFieldState createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  AmountFieldStyle _style;

  @override
  void initState() {
    super.initState();
    _style = AmountFieldStyle.fromOldTheme(Provider.of<AppThemeOld>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommonPreviewResponse>(
      stream: widget.bloc?.transactionPreviewObservable,
      builder: (context, snapshot) {
        return Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              onChanged: (String amount) {
                logger.e(amount);
                widget.onAmountChange(amount);
              },
              enabled: widget.isEnable,
              decoration: InputDecoration(labelText: AppStrings.AMOUNT.tr(), suffix: _feeSection(snapshot)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (widget.feeLoadInProgress)
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                          right: 10,
                        ),
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation(
                            AppThemeOld.defaultTheme().colors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _feeSection(snapshot) {
    if (!snapshot.hasData || widget.feeLoadInProgress) {
      return Text('', style: _style.feeTextStyle);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
            '${AppStrings.FEE.tr()} : ${snapshot.data.details.isNotEmpty ? snapshot.data.details[0].amount : '0'} ${snapshot.data.incomingCurrencyCode}',
            style: _style.feeTextStyle),
        SizedBox(width: widget.isEnable ? 0 : 16),
        iconLock(!widget.isEnable),
        SizedBox(width: widget.isEnable ? 0 : 8),
      ],
    );
  }

  Widget iconLock(bool isShowLock) {
    return isShowLock ? SvgPicture.asset(_style.lockIcon) : const SizedBox();
  }
}
