import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/services_repository.dart';

import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository servicesRepository;

  ServicesBloc({required this.servicesRepository}) : super(ServicesInitial()) {
    on<ServicesFetched>(_onServicesFetched);
  }

  Future<void> _onServicesFetched(
    ServicesFetched event,
    Emitter<ServicesState> emit,
  ) async {
    try {
      emit(ServicesLoading());

      final services = await servicesRepository.getServices(
        search: event.search,
        category: event.category,
      );

      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesFailure(e.toString()));
    }
  }
}
