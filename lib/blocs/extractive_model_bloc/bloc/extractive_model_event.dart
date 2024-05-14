part of 'extractive_model_bloc.dart';

sealed class ExtractiveModelEvent extends Equatable {
  const ExtractiveModelEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FetchModelResult extends ExtractiveModelEvent {
  String text;
  FetchModelResult({required this.text});
}
