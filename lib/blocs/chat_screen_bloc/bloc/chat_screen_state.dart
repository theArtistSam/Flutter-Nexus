part of 'chat_screen_bloc.dart';

sealed class ChatScreenState extends Equatable {
  const ChatScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class ChatScreenInitial extends ChatScreenState {
  bool isLeftSelected;
  ChatScreenInitial({this.isLeftSelected = true});

  ChatScreenInitial copyWith({bool? isLeftSelected}) {
    return ChatScreenInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected);
  }

  @override
  List<Object> get props => [isLeftSelected];
}
