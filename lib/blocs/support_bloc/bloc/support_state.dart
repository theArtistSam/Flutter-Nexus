part of 'support_bloc.dart';

sealed class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => [];
}

final class SupportInitial extends SupportState {
  final Stream<List<SupportModel>> issues;

  const SupportInitial({this.issues = const Stream.empty()});

  SupportInitial copyWith({Stream<List<SupportModel>>? issues}) {
    return SupportInitial(issues: issues ?? this.issues);
  }

  @override
  List<Object> get props => [issues];
}
