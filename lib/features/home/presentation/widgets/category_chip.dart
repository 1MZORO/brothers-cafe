import 'package:brew_brother_cafe/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryItem {
  final String title;
  final String? emoji;
  final IconData? icon;

  CategoryItem({
    required this.title,
    this.emoji,
    this.icon,
  });
}

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int _selectedIndex = 0;

  final List<CategoryItem> _categories = [
    CategoryItem(title: 'All', emoji: '✨'),
    CategoryItem(title: 'Coffee', emoji: '☕'),
    CategoryItem(title: 'Breakfast', emoji: '🥐'),
    CategoryItem(title: 'Lunch', emoji: '🍔'),
    CategoryItem(title: 'Dessert', emoji: '🍰'),
    CategoryItem(title: 'Drinks', emoji: '🧃'),
    CategoryItem(title: 'Healthy', emoji: '🥗'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_categories.length} categories available',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // View All Button
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return CategoryChip(
                title: _categories[index].title,
                emoji: _categories[index].emoji,
                icon: _categories[index].icon,
                isSelected: _selectedIndex == index,
                onTap: () => setState(() => _selectedIndex = index),
              );
            },
          ),
        ),

        // Selection Indicator
        const SizedBox(height: 8), // Reduced from 12 since we have more space now
        _buildSelectionIndicator(),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _categories.length,
              (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: _selectedIndex == index ? 24 : 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: _selectedIndex == index
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryChip extends StatefulWidget {
  final String title;
  final IconData? icon;
  final String? emoji;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;

  const CategoryChip({
    super.key,
    required this.title,
    this.icon,
    this.emoji,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(CategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger a subtle bounce when selected
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.selectedColor ?? AppColors.primary;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = widget.isSelected
              ? _bounceAnimation.value
              : _scaleAnimation.value;

          return Transform.scale(
            scale: _isPressed ? _scaleAnimation.value : scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(right: 12),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSelected ? 20 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
              colors: [
                selectedColor,
                selectedColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: widget.isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : AppColors.background.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              if (widget.isSelected) ...[
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.4),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.2),
                  spreadRadius: -2,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ] else ...[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji or Icon
              if (widget.emoji != null) ...[
                Text(
                  widget.emoji!,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
              ] else if (widget.icon != null) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    widget.icon,
                    size: 18,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Title
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight:
                  widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: widget.isSelected ? 0.3 : 0,
                ),
                child: Text(widget.title),
              ),
              // Selected indicator dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: widget.isSelected ? 8 : 0,
                height: widget.isSelected ? 8 : 0,
                margin: EdgeInsets.only(left: widget.isSelected ? 10 : 0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alternative
/*
class PillCategoriesSection extends StatefulWidget {
  const PillCategoriesSection({super.key});

  @override
  State<PillCategoriesSection> createState() => _PillCategoriesSectionState();
}

class _PillCategoriesSectionState extends State<PillCategoriesSection> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'title': 'All', 'icon': Icons.apps_rounded, 'color': Color(0xFF6366F1)},
    {'title': 'Coffee', 'icon': Icons.coffee_rounded, 'color': Color(0xFF8B5A2B)},
    {'title': 'Breakfast', 'icon': Icons.breakfast_dining_rounded, 'color': Color(0xFFF59E0B)},
    {'title': 'Lunch', 'icon': Icons.lunch_dining_rounded, 'color': Color(0xFFEF4444)},
    {'title': 'Dessert', 'icon': Icons.cake_rounded, 'color': Color(0xFFEC4899)},
    {'title': 'Drinks', 'icon': Icons.local_bar_rounded, 'color': Color(0xFF10B981)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return IconCategoryChip(
                title: category['title'],
                icon: category['icon'],
                accentColor: category['color'],
                isSelected: _selectedIndex == index,
                onTap: () => setState(() => _selectedIndex = index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class IconCategoryChip extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback? onTap;

  const IconCategoryChip({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.accentColor = const Color(0xFF6366F1),
    this.onTap,
  });

  @override
  State<IconCategoryChip> createState() => _IconCategoryChipState();
}

class _IconCategoryChipState extends State<IconCategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _iconRotation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(IconCategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                  colors: [
                    widget.accentColor,
                    widget.accentColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: widget.isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.transparent
                      : AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  if (widget.isSelected)
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _iconRotation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _iconRotation.value,
                    child: child,
                  );
                },
                child: Icon(
                  widget.icon,
                  size: 28,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Title
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: widget.isSelected
                    ? widget.accentColor
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight:
                widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(widget.title),
            ),

            // Selection Dot
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widget.isSelected ? 6 : 0,
              height: widget.isSelected ? 6 : 0,
              decoration: BoxDecoration(
                color: widget.accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
