import 'package:brew_brother_cafe/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_fab.dart';
import '../search/search_page.dart';
import '../favorites/presentation/pages/favorites_page.dart';
import '../profile/presentation/pages/profile_page.dart';
import '../cart/cart_page.dart';
import 'animated_bottom_nav.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchPage(),
    const FavoritesPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _pages[_selectedIndex],
          // Floating Action Button
          Positioned(
            bottom: 110,
            right: 20,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: SpeedDialFAB(
                icon: Icons.add_shopping_cart,
                activeIcon: Icons.close,
                children: [
                  SpeedDialChild(
                    icon: Icons.local_cafe,
                    label: 'Quick Order',
                    backgroundColor: AppColors.primary,
                    onTap: () {
                      // Handle quick order
                    },
                  ),
                  SpeedDialChild(
                    icon: Icons.favorite,
                    label: 'Favorites',
                    backgroundColor: AppColors.favorite,
                    onTap: () {
                      setState(() => _selectedIndex = 2);
                    },
                  ),
                  SpeedDialChild(
                    icon: Icons.search,
                    label: 'Search',
                    backgroundColor: AppColors.secondary,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Glassy Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBottomNav(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
                // Restart FAB animation on navigation
                _fabController.reset();
                _fabController.forward();
              },
            ),
          ),
        ],
      ),
    );
  }
}
