part of 'navbar_bloc.dart';

sealed class NavbarState extends Equatable {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class NavbarInitial extends NavbarState {
  int index;

  NavbarInitial({this.index = 0});

  NavbarInitial copyWith({int? index, bool? isTranslateSelected}) {
    return NavbarInitial(
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [index];
}
