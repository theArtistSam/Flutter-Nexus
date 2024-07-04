part of 'navbar_bloc.dart';

sealed class NavbarState extends Equatable {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class NavbarInitial extends NavbarState {
  int index;
  List<Widget> pages;
  NavbarInitial({this.index = 0, this.pages = const []});

  NavbarInitial copyWith({int? index, List<Widget>? pages}) {
    return NavbarInitial(
        index: index ?? this.index, pages: pages ?? this.pages);
  }

  @override
  List<Object> get props => [index, pages];
}
