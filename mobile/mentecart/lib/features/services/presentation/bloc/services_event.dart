import 'package:equatable/equatable.dart';

abstract class ServicesEvent
    extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class ServicesFetched
    extends ServicesEvent {
  final String? search;

  final String? category;

  const ServicesFetched({
    this.search,
    this.category,
  });

  @override
  List<Object?> get props => [
        search,
        category,
      ];
}