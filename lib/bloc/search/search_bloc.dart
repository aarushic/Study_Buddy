import 'package:Study_Buddy/bloc/search/bloc.dart';
import 'package:Study_Buddy/models/user.dart';
import 'package:Study_Buddy/repositories/searchRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository _searchRepository;

  SearchBloc({@required SearchRepository searchRepository})
      : assert(searchRepository != null),
        _searchRepository = searchRepository;

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId,
          name: event.name,
          photoUrl: event.photoUrl);
    }
    if (event is PassUserEvent) {
      yield* _mapPassToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
      );
    }
    if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(currentUserId: event.userId);
    }
  }

  Stream<SearchState> _mapSelectToState(
      {String currentUserId,
      String selectedUserId,
      String name,
      String photoUrl}) async* {
    yield LoadingState();

    User user = await _searchRepository.chooseUser(
        currentUserId, selectedUserId, name, photoUrl);

    User currentUser = await _searchRepository.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapPassToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();
    User user = await _searchRepository.passUser(currentUserId, selectedUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapLoadUserToState({String currentUserId}) async* {
    yield LoadingState();
    User user = await _searchRepository.getUser(currentUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }
}