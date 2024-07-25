part of 'search_bottom_sheet_bloc.dart';

sealed class SearchBottomSheetState extends Equatable {
  const SearchBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class SearchBottomSheetInitial extends SearchBottomSheetState {
  Stream<List<ContentModel>> content;
  SearchBottomSheetInitial({this.content = const Stream.empty()});

  SearchBottomSheetInitial copyWith({Stream<List<ContentModel>>? content}) {
    return SearchBottomSheetInitial(content: content ?? this.content);
  }

  @override
  List<Object> get props => [content];
}
