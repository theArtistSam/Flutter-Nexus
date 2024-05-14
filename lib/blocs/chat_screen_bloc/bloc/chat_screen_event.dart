part of 'chat_screen_bloc.dart';

sealed class ChatScreenEvent extends Equatable {
  const ChatScreenEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleView extends ChatScreenEvent {
  bool isLeftSelected;
  ToggleView({required this.isLeftSelected});
}
