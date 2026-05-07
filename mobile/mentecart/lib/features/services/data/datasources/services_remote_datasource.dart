import 'package:mentecart/features/services/models/service_model.dart';

import '../../../../app/network/api_client.dart';

class ServicesRemoteDatasource {
  final ApiClient apiClient;

  ServicesRemoteDatasource({required this.apiClient});

  Future<List<ServiceModel>> getServices({
    String? search,
    String? category,
  }) async {
    final response = await apiClient.get(
      '/services',

      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,

        if (category != null && category.isNotEmpty) 'category': category,
      },
    );

    final List services = response.data['data']['services'];

    return services.map((service) => ServiceModel.fromJson(service)).toList();
  }

  Future<ServiceModel> getServiceById(String id) async {
    final response = await apiClient.get('/services/$id');

    return ServiceModel.fromJson(response.data['data']);
  }
}
