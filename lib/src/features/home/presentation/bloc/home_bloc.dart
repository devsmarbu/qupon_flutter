import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/home_data.dart';
import '../../data/repositories/home_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class HomeEvent {
  const HomeEvent();
}

class FetchHomeData extends HomeEvent {
  const FetchHomeData();
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeData data;
  const HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) {
      emit(const HomeLoading());
    }
    try {
      final data = await _homeRepository.getHomeData();
      emit(HomeLoaded(data));
    } catch (e) {
      final String userFriendlyMessage;
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('socketexception') ||
          errStr.contains('failed host lookup') ||
          errStr.contains('connection') ||
          errStr.contains('network') ||
          errStr.contains('dioexception')) {
        userFriendlyMessage =
            'Failed to load home data. Please check your network connection.';
      } else {
        userFriendlyMessage =
            'Failed to load home data. Please try again.';
      }
      emit(HomeError(userFriendlyMessage));
    }
  }
}
