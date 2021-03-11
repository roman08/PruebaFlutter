import 'dart:io';
import 'dart:typed_data';

import 'package:api_error_parser/api_error_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../networking/api_providers/file_provider.dart';
import '../models/current_tier_result.dart';
import '../models/requirement_request.dart';
import '../models/tiers_result.dart';
import '../providers/kyc_provider.dart';

class KycRepository {
  final KycProvider _apiProvider;
  final FileProvider _fileProvider;
  final ApiParser<String> _apiParser;

  KycRepository(
    this._apiParser,
    this._apiProvider,
    this._fileProvider,
  );

  factory KycRepository.create(
    ApiParser<String> _apiParser,
    KycProvider kycProvider,
    FileProvider fileProvider,
  ) {
    return KycRepository(
      _apiParser,
      kycProvider,
      fileProvider,
    );
  }

  Stream<Resource<List<Tier>, String>> getTiers() {
    final networkClient = NetworkBoundResource<List<Tier>, List<Tier>, String>(
        _apiParser, saveCallResult: (List<Tier> items) async {
      return items;
    }, createCall: () {
      return _apiProvider.getTiers();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<CurrentTier, String>> getCurrentTier() {
    final networkClient =
        NetworkBoundResource<CurrentTier, CurrentTier, String>(_apiParser,
            saveCallResult: (CurrentTier item) async {
      return item;
    }, createCall: () {
      return _apiProvider.getCurrentTier();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> sendRequest({int id}) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.sendRequest(id: id);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<Tier, String>> getTier({int id}) {
    final networkClient = NetworkBoundResource<Tier, Tier, String>(_apiParser,
        saveCallResult: (Tier item) async {
      for (var i = 0; i < item.requirements.length; i++) {
        final requirement = item.requirements[i];

        for (var j = 0; j < requirement.elements.length; j++) {
          final element = requirement.elements[j];
          if (element.index == ElementIndex.selfiePhoto ||
              element.index == ElementIndex.scannedIdentification ||
              element.index == ElementIndex.scanned) {
            if (element.value != 'null' && element.value.isNotEmpty) {
              final id = int.parse(element.value);

              final list = await _fileProvider.getBin(id: id);
              final bytes = Uint8List.fromList(list);

              element.bytes = bytes;

              item.requirements[i].elements[j] = element;
            }
          }
        }
      }

      return item;
    }, createCall: () {
      return _apiProvider.getTier(id: id);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> updateRequirement({
    RequirementRequest requirement,
    int id,
  }) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      for (var i = 0; i < requirement.values.length; i++) {
        final value = requirement.values[i];
        if (value.index == ElementIndex.selfiePhoto ||
            value.index == ElementIndex.scannedIdentification ||
            value.index == ElementIndex.scanned) {
          final file = File(value.value);

          if (file.isAbsolute) {
            final info = await _fileProvider.uploadFile(path: value.value);

            requirement.values[i] = ElementValue(
              index: value.index,
              value: info.data.id.toString(),
            );
          }
        }
      }

      return _apiProvider.updateRequirement(
        id: id,
        requirement: requirement,
      );
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> generateNewPhoneCode() {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.generateNewPhoneCode();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> generateNewEmailCode() {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.generateNewEmailCode();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkEmailCode({
    String code,
  }) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.checkEmailCode(code: code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkPhoneCode({
    String code,
  }) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.checkPhoneCode(code: code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }
}
