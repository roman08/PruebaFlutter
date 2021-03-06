import 'package:Neobank/common/bloc/loader_bloc.dart';
import 'package:Neobank/common/repository/user_repository.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../common/session/cubit/session_cubit.dart';
import '../common/session/session_repository.dart';
import '../common/utils/validator.dart';
import '../networking/api_providers/accounts_api_provider.dart';
import '../networking/api_providers/auth_api_provider.dart';
import '../networking/api_providers/file_provider.dart';
import '../networking/api_providers/notifications_api_provider.dart';
import '../networking/environments.dart';
import '../networking/interceptors/interceptor_refresh.dart';
import '../networking/network_client.dart';
import '../resources/errors/app_errors.dart';
import '../resources/strings/app_strings.dart';
import '../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'biometric_flow/cubit/biometric_cubit.dart';
import 'dashboard_flow/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'dashboard_flow/bloc/dashboard_bloc.dart';
import 'dashboard_flow/more/profile/cubit/profile_cubit.dart';
import 'dashboard_flow/repository/dashboard_repository.dart';
import 'in_app_notifications/repository/notifications_repository.dart';
import 'kyc_flow/providers/kyc_provider.dart';
import 'kyc_flow/repository/kyc_repository.dart';
import 'transfer_money/cubit/iwt/iwt_cubit.dart';
import 'transfer_money/cubit/owt/owt_cubit.dart';
import 'transfer_money/cubit/tbu/tbu_cubit.dart';
import 'transfer_money/cubit/tbu_request/tbu_request_cubit.dart';
import 'transfer_money/repository/iwt_repository.dart';
import 'transfer_money/repository/owt_repository.dart';
import 'transfer_money/repository/tbu_repository.dart';
import 'transfer_money/repository/tbu_request_repository.dart';
import 'transfer_money/repository/transfers_repository.dart';
import 'transfer_money/request/request_by_qr/bloc/request_by_qr/request_money_qr_cubit.dart';

final ApiParser<String> _apiParser = ApiParser<String>(
  errorMessages: AppError.errors,
  defaultErrorMessage: ErrorStrings.SOMETHING_WENT_WRONG,
  fieldErrorMessages: AppError.fieldErrors,
);

class AppFlow extends StatelessWidget {
  const AppFlow({Key key, this.child, this.sessionRepository})
      : super(key: key);

  final Widget child;
  final SessionRepository sessionRepository;

  final List<Locale> supportedLocales = const [Locale('en'), Locale('ru')];

  @override
  Widget build(BuildContext context) {
    final SessionCubit sessionBloc = SessionCubit(sessionRepository);
    final refreshInterceptor =
        RefreshInterceptor(sessionRepository, sessionBloc);

    final networkClient = NetworkClient(
      Environments.current.baseUrl,
      sessionRepository,
      sessionBloc,
    );

    final KycProvider kycProvider =
        KycProvider(sessionRepository, networkClient);
    final FileProvider fileProvider =
        FileProvider(sessionRepository, networkClient);

    final AccountsApiProvider accountsApiProvider =
        AccountsApiProvider(networkClient);
    final AuthApiProvider authApiProvider =
        AuthApiProvider(sessionRepository, networkClient);

    final DashboardRepository dashboardRepository =
        DashboardRepository(_apiParser, accountsApiProvider);
    final UserRepository userRepository = UserRepository(
      _apiParser,
      authApiProvider,
      fileProvider,
      sessionRepository,
    );
    sessionBloc.userRepository = userRepository;

    return EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: supportedLocales.first,
      useOnlyLangCode: true,
      assetLoader: CsvAssetLoader(),
      path: "assets/strings/langs.csv",
      child: MultiProvider(
        providers: [
          Provider<AppThemeOld>(
              create: (context) => AppThemeOld.defaultTheme()),
          Provider<Validator>(create: (context) => Validator()),
          Provider<SessionRepository>(create: (context) => sessionRepository),
          Provider<UserRepository>(create: (context) => userRepository),
          Provider<TransfersRepository>(
              create: (context) => TransfersRepository(
                    _apiParser,
                    accountsApiProvider,
                  )),
          Provider<NotificationsRepository>(
              create: (context) => NotificationsRepository(
                    _apiParser,
                    NotificationsApiProvider(
                      networkClient,
                    ),
                  )),
          Provider<DashboardRepository>(
            create: (context) => dashboardRepository,
          ),
          Provider<TbuRepository>(
            create: (context) => TbuRepository(_apiParser, accountsApiProvider),
          ),
          Provider<TbuRequestRepository>(
            create: (context) =>
                TbuRequestRepository(_apiParser, accountsApiProvider),
          ),
          Provider<KycRepository>(
              create: (context) => KycRepository.create(
                    _apiParser,
                    kycProvider,
                    fileProvider,
                  )),
          Provider<DashboardBloc>(
              create: (context) => DashboardBloc(
                    dashboardRepository,
                    sessionRepository,
                    userRepository,
                  )),
          Provider<OwtRepository>(
            create: (context) => OwtRepository(_apiParser, accountsApiProvider),
          ),
          Provider<IwtRepository>(
            create: (context) => IwtRepository(_apiParser, accountsApiProvider),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LoaderBloc>(
              create: (BuildContext context) => LoaderBloc(),
            ),
            BlocProvider<SessionCubit>(
              create: (BuildContext context) => sessionBloc,
            ),
            BlocProvider<BottomNavigationCubit>(
              create: (BuildContext context) => BottomNavigationCubit(),
            ),
            BlocProvider<ProfileCubit>(
              create: (BuildContext context) => ProfileCubit(
                context.read<SessionRepository>(),
                context.read<UserRepository>(),
              ),
            ),
            BlocProvider<RequestByQrCubit>(
              create: (BuildContext context) => RequestByQrCubit(
                context.read<SessionRepository>(),
                context.read<TransfersRepository>(),
              ),
            ),
            BlocProvider<BiometricCubit>(
              create: (BuildContext context) => BiometricCubit(
                context.read<SessionRepository>(),
              ),
            ),
            BlocProvider<OwtCubit>(
              create: (context) => OwtCubit(
                context.read<OwtRepository>(),
                context.read<SessionRepository>(),
              )..loadCountriesAndCurrencies(),
            ),
            BlocProvider<IwtCubit>(
              create: (context) => IwtCubit(context.read<IwtRepository>()),
            ),
            BlocProvider<TbuCubit>(
              create: (context) => TbuCubit(
                context.read<TbuRepository>(),
              ),
            ),
            BlocProvider<TbuRequestCubit>(
              create: (context) => TbuRequestCubit(
                context.read<TbuRequestRepository>(),
              ),
            ),
          ],
          child: child,
        ),
      ),
    );
  }
}
