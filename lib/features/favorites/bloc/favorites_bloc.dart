import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import '../data/repositories/favorites_repository.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository repository;

  FavoritesBloc({required this.repository}) : super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<ClearFavorites>(_onClearFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(const FavoritesLoading());
      await repository.init();
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final isFav = await repository.isFavorite(event.item.id);

        if (isFav) {
          await repository.removeFavorite(event.item.id);
        } else {
          await repository.addFavorite(event.item);
        }

        final updatedFavorites = await repository.getFavorites();
        emit(FavoritesLoaded(updatedFavorites));
      }
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.removeFavorite(event.itemId);
      final updatedFavorites = await repository.getFavorites();
      emit(FavoritesLoaded(updatedFavorites));
    } catch (e) {
      emit(FavoritesError('Failed to remove favorite: ${e.toString()}'));
    }
  }

  Future<void> _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.clearFavorites();
      emit(const FavoritesLoaded([]));
    } catch (e) {
      emit(FavoritesError('Failed to clear favorites: ${e.toString()}'));
    }
  }
}
