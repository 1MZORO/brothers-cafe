import 'package:equatable/equatable.dart';
import '../../menu/data/models/menu_item.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<MenuItem> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];

  bool isFavorite(String itemId) {
    return favorites.any((item) => item.id == itemId);
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
