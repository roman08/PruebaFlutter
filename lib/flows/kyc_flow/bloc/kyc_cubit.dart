import 'package:bloc/bloc.dart';
import 'package:network_utils/resource.dart';
import 'package:rxdart/rxdart.dart';

import '../models/current_tier_result.dart';
import '../models/requirement_request.dart';
import '../models/tiers_result.dart';
import '../repository/kyc_repository.dart';
import 'kyc_state.dart';

class KycCubit extends Cubit<KycState> {
  final KycRepository repository;

  KycCubit({this.repository}) : super(KycInitial());

  void fetch() {
    Rx.combineLatest2(
        repository.getCurrentTier(),
        repository.getTiers(),
        (
          Resource<CurrentTier, String> a,
          Resource<List<Tier>, String> b,
        ) =>
            _updateData(
              currentTier: a.data,
              tiers: b.data,
            )).listen((e) {});
  }

  void getTier({int id}) {
    emit(LoadingState());

    Rx.combineLatest3(
        repository.getTier(id: id),
        repository.getCurrentTier(),
        repository.getTiers(),
        (
          Resource<Tier, String> a,
          Resource<CurrentTier, String> b,
          Resource<List<Tier>, String> c,
        ) =>
            _updateData(
              tier: a.data,
              currentTier: b.data,
              tiers: c.data,
            )).listen((e) {});
  }

  void updateRequirement({int id, RequirementRequest requirement}) {
    final tierId = (this.state as SuccessState).tier.id;
    emit(LoadingState());

    repository
        .updateRequirement(
      id: id,
      requirement: requirement,
    )
        .listen(
      (event) {
        getTier(id: tierId);
      },
    );
  }

  void _updateData({CurrentTier currentTier, List<Tier> tiers, Tier tier}) {
    if (tiers == null || currentTier == null) {
      return;
    }
    emit(SuccessState(
      tiers: tiers ?? [],
      tier: tier,
      currentTier: currentTier,
    ));
  }

  void sendRequest({int id}) {
    final tierId = (this.state as SuccessState).tier.id;

    emit(LoadingState());

    repository.sendRequest(id: id).listen(
      (event) {
        getTier(id: tierId);
      },
    );
  }

  void sendPhoneCode() {
    repository.generateNewPhoneCode().listen((event) {});
  }

  void sendEmailCode() {
    repository.generateNewEmailCode().listen((event) {});
  }

  void checkEmailCode({String code}) {
    final tierId = (this.state as SuccessState).tier.id;

    emit(LoadingState());

    repository.checkEmailCode(code: code).listen((event) {
      if (event.status == Status.success) {
        emit(VerifiedState());
      } else if (event.status == Status.error) {
        emit(FailState());
      }

      getTier(id: tierId);
    });
  }

  void checkPhoneCode({String code}) {
    final tierId = (this.state as SuccessState).tier.id;
    emit(LoadingState());
    repository.checkPhoneCode(code: code).listen((event) {
      if (event.status == Status.success) {
        emit(VerifiedState());
      } else if (event.status == Status.error) {
        emit(FailState());
      }

      getTier(id: tierId);
    });
  }
}
