import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../favorites/bloc/favorites_state.dart';
import '../../../menu/data/models/menu_item.dart';

class FoodDetailScreen extends StatefulWidget {
  final MenuItem item;

  const FoodDetailScreen({super.key, required this.item});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedSize = 'Medium';
  final List<String> _selectedExtras = [];
  late AnimationController _favoriteController;
  late Animation<double> _favoriteAnimation;

  final List<String> _sizes = ['Small', 'Medium', 'Large'];
  final List<String> _extras = [
    'Extra Shot',
    'Whipped Cream',
    'Caramel Drizzle',
    'Vanilla Syrup'
  ];

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    HapticFeedback.lightImpact();
    _favoriteController.forward().then((_) => _favoriteController.reverse());
    context.read<FavoritesBloc>().add(ToggleFavorite(widget.item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      // ✅ Option 1: Using bottomNavigationBar (Recommended - Simpler)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            _buildContent(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(), // ✅ Use this method
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // ✅ Fixed
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // ✅ Fixed
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              bool isFavorite = false;
              if (state is FavoritesLoaded) {
                isFavorite = state.isFavorite(widget.item.id);
              }
              return ScaleTransition(
                scale: _favoriteAnimation,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.favorite : AppColors.textPrimary,
                    size: 24,
                  ),
                  onPressed: _toggleFavorite,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.1), // ✅ Fixed
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          Hero(
            tag: 'food_${widget.item.id}',
            child: Center(
              child: _buildItemImage(),
            ),
          ),
          Positioned(
            top: 320,
            right: 20,
            child: _buildRatingBadge(),
          ),
        ],
      ),
    );
  }

  // ✅ Added: Safe image loading
  Widget _buildItemImage() {
    return Image.asset(
      widget.item.imageUrl,
      height: 300,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.low, // ✅ Helps with Impeller
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.fastfood,
            size: 100,
            color: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3), // ✅ Fixed
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            widget.item.rating.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.item.description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildSizeSelector(),
          const SizedBox(height: 24),
          _buildExtrasSection(),
          const SizedBox(height: 24),
          _buildQuantitySelector(),
          const SizedBox(height: 20), // ✅ Reduced from 120
        ],
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _sizes.map((size) {
            final isSelected = _selectedSize == size;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedSize = size);
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: size != _sizes.last ? 12 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExtrasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Extras',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _extras.map((extra) {
            final isSelected = _selectedExtras.contains(extra);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedExtras.remove(extra);
                  } else {
                    _selectedExtras.add(extra);
                  }
                });
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.secondaryGradient : null,
                  color: isSelected ? null : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.divider,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                    Text(
                      extra,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuantityButton(
              icon: Icons.remove,
              onTap: () {
                if (_quantity > 1) {
                  setState(() => _quantity--);
                  HapticFeedback.selectionClick();
                }
              },
            ),
            const SizedBox(width: 20),
            Text(
              _quantity.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 20),
            _buildQuantityButton(
              icon: Icons.add,
              onTap: () {
                setState(() => _quantity++);
                HapticFeedback.selectionClick();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3), // ✅ Fixed
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // ✅ Fixed: Bottom bar without BackdropFilter (avoids Impeller crash)
  Widget _buildBottomBar() {
    final totalPrice = widget.item.price * _quantity;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // ✅ Fixed
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                onPressed: _addToCart,
                icon: Icons.shopping_bag_outlined,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _addToCart() {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Added to Cart',
      '${widget.item.name} x$_quantity',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}