import 'package:equatable/equatable.dart';
import 'package:mentecart/features/services/models/service_model.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceModel> services;

  const ServicesLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ServicesFailure extends ServicesState {
  final String message;

  const ServicesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
