import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../bloc/favorites_bloc.dart';
import '../../bloc/favorites_event.dart';
import '../../bloc/favorites_state.dart';
import '../../../home/presentation/widgets/food_card.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Favorites',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      if (state is FavoritesLoaded &&
                          state.favorites.isNotEmpty) {
                        return TextButton.icon(
                          onPressed: () {
                            _showClearConfirmation(context);
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: AppColors.error,
                          ),
                          label: Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is FavoritesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.favorite_border,
                        title: 'No Favorites Yet',
                        subtitle:
                            'Start adding items to your favorites\nto see them here',
                        actionText: 'Browse Menu',
                        onActionPressed: () {
                          // Navigate to home/menu
                          Get.back();
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<FavoritesBloc>()
                            .add(const LoadFavorites());
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: state.favorites.length,
                        itemBuilder: (context, index) {
                          final item = state.favorites[index];
                          return Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (direction) {
                              context
                                  .read<FavoritesBloc>()
                                  .add(RemoveFavorite(item.id));
                            },
                            child: FoodCard(
                              image: item.imageUrl,
                              name: item.name,
                              price: '\$${item.price.toStringAsFixed(2)}',
                              rating: item.rating.toString(),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear All Favorites?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your favorites?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesBloc>().add(const ClearFavorites());
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
