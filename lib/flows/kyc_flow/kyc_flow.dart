import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/kyc_cubit.dart';
import 'repository/kyc_repository.dart';
import 'screens/account_level_screen.dart';

class KycFlow extends StatefulWidget {
  static const String ROUTE = '/kyc';

  const KycFlow({Key key}) : super(key: key);

  @override
  _KycFlowState createState() => _KycFlowState();
}

class _KycFlowState extends State<KycFlow> {
  KycCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = KycCubit(
      repository: context.repository<KycRepository>(),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: AccountLevelScreen(),
    );
  }
}
