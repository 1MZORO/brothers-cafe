import 'package:equatable/equatable.dart';
import '../../menu/data/models/menu_item.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class ToggleFavorite extends FavoritesEvent {
  final MenuItem item;

  const ToggleFavorite(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFavorite extends FavoritesEvent {
  final String itemId;

  const RemoveFavorite(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearFavorites extends FavoritesEvent {
  const ClearFavorites();
}
