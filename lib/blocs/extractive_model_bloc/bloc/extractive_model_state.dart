part of 'extractive_model_bloc.dart';

sealed class ExtractiveModelState extends Equatable {
  const ExtractiveModelState();

  @override
  List<Object> get props => [];
}

final class ExtractiveModelInitial extends ExtractiveModelState {
  final ExtractiveModel? model;
  final ModelStatus status;
  final String message;

  const ExtractiveModelInitial(
      {this.model, this.status = ModelStatus.loading, this.message = ''});

  ExtractiveModelInitial copyWith(
      {ExtractiveModel? model, ModelStatus? status, String? message}) {
    return ExtractiveModelInitial(
        message: message ?? this.message,
        status: status ?? this.status,
        model: model ?? ExtractiveModel());
  }

  @override
  List<Object> get props => [model ?? ExtractiveModel(), status, message];
}
