import 'package:equatable/equatable.dart';

import '../models/current_tier_result.dart';
import '../models/tiers_result.dart';

abstract class KycState extends Equatable {
  const KycState();
}

class KycInitial extends KycState {
  @override
  List<Object> get props => [];
}

class LoadingState extends KycState {
  @override
  List<Object> get props => [];
}

class VerifiedState extends KycState {
  @override
  List<Object> get props => [];
}

class SuccessState extends KycState {
  final CurrentTier currentTier;
  final List<Tier> tiers;
  final Tier tier;

  const SuccessState({
    this.tiers,
    this.currentTier,
    this.tier,
  });

  @override
  List<Object> get props => [
        currentTier,
        tiers,
        tier,
      ];
}

class FailState extends KycState {
  @override
  List<Object> get props => [];
}
