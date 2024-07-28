import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/repositories/community_repository.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(const CommunityInitial()) {
    on<FetchPosts>(fetchPosts);
  }

  FutureOr<void> fetchPosts(FetchPosts event, Emitter<CommunityState> emit) {
    final currentState = state as CommunityInitial;

    try {
      Stream<List<PostModel>> postList =
          CommunityRepository().getAllPosts(queryBuilder: (query) {
        return query.where('permissions.is_private', isEqualTo: false);
      });

      emit(currentState.copyWith(posts: postList));

      print('LOADING ... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD POSTS...");
    }
  }
}
