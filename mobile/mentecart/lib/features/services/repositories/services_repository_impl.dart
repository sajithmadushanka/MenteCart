import 'package:mentecart/features/services/data/datasources/services_remote_datasource.dart';
import 'package:mentecart/features/services/domain/repositories/services_repository.dart';

import '../models/service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource remoteDatasource;

  ServicesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ServiceModel>> getServices({String? search, String? category}) {
    return remoteDatasource.getServices(search: search, category: category);
  }

  @override
  Future<ServiceModel> getServiceById(String id) {
    return remoteDatasource.getServiceById(id);
  }
}
