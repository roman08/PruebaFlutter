import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';

import '../../../app.dart';
import '../../../common/session/session_repository.dart';
import '../../../networking/api_constants.dart';
import '../../../networking/network_client.dart';
import '../models/current_tier_result.dart';
import '../models/requirement_request.dart';
import '../models/tiers_result.dart';

class KycProvider {
  final NetworkClient networkClient;
  final SessionRepository sessionRepository;
  final ApiConstants apiConstants = ApiConstants();

  KycProvider(
    this.sessionRepository,
    this.networkClient,
  );

  Future<ApiResponseEntity<List<Tier>>> getTiers() async {
    try {
      final Response response = await networkClient.dio.get(
        apiConstants.kyc.tiers,
      );

      return ApiResponseEntity<List<Tier>>.fromJson(
          response.data as Map<String, dynamic>, Tier.listFromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<List<Tier>>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<void>> sendRequest({int id}) async {
    try {
      await networkClient.dio.post(
        apiConstants.kyc.requests,
        data: {
          'tierId': id,
        },
      );

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<CurrentTier>> getCurrentTier() async {
    try {
      final Response response = await networkClient.dio.get(
        apiConstants.kyc.current,
      );

      return ApiResponseEntity<CurrentTier>.fromJson(
          response.data as Map<String, dynamic>, CurrentTier.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<CurrentTier>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<Tier>> getTier({int id}) async {
    try {
      final Response response = await networkClient.dio.get(
        apiConstants.kyc.tier(id: id),
      );

      return ApiResponseEntity<Tier>.fromJson(
          response.data as Map<String, dynamic>, Tier.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<Tier>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<void>> updateRequirement({
    RequirementRequest requirement,
    int id,
  }) async {
    try {
      await networkClient.dio.put(
        apiConstants.kyc.requirement(id: id),
        data: requirement,
      );

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<void>> generateNewEmailCode() async {
    try {
      await networkClient.dio.post(
        apiConstants.verifications.generateNewEmailCode,
      );

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<void>> generateNewPhoneCode() async {
    try {
      await networkClient.dio.post(
        apiConstants.verifications.generateNewPhoneCode,
      );

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<void>> checkEmailCode({String code}) async {
    try {
      await networkClient.dio.put(
        apiConstants.verifications.checkEmailCode,
        data: {
          'code': code,
        },
      );

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<ApiResponseEntity<void>> checkPhoneCode({String code}) async {
    try {
      await networkClient.dio.put(
        apiConstants.verifications.checkPhoneCode,
        data: {
          'code': code,
        },
      );

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }
}
