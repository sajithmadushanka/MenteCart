import 'package:mentecart/features/services/models/service_model.dart';

abstract class ServicesRepository {
  Future<ServiceModel> getServiceById(String id);
  Future<List<ServiceModel>> getServices({String? search, String? category});
}
