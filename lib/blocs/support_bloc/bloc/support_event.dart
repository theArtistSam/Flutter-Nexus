part of 'support_bloc.dart';

sealed class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object> get props => [];
}

class FetchIssues extends SupportEvent {}
