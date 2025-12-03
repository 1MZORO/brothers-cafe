import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import '../widgets/banner_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.secondary.withValues(alpha: 0.05),
              AppColors.background.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                     padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                     decoration: BoxDecoration(
                       color: AppColors.white,
                       borderRadius: BorderRadius.circular(8.r),
                       boxShadow: [
                         BoxShadow(
                           color: AppColors.primary.withAlpha(30),
                           spreadRadius: 5,
                           blurRadius: 5,
                         )
                       ]
                     ),
                     child:  Icon(
                        Icons.notification_add_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchSection(),
                      SizedBox(height: 24.h),
                      const BannerWidget(),
                      SizedBox(height: 24.h),
                      _buildCategoriesSection(),
                      SizedBox(height: 24.h),
                      _buildFoodSection(),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: const SearchBarWidget(),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 40.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              CategoryChip(title: 'All', isSelected: true),
              CategoryChip(title: 'Coffee'),
              CategoryChip(title: 'Breakfast'),
              CategoryChip(title: 'Lunch'),
              CategoryChip(title: 'Dessert'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Food',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              FoodCard(
                image: 'assets/app-images/img.png',
                name: 'Cappuccino',
                price: '\$4.50',
                rating: '4.8',
              ),
              FoodCard(
                image: 'assets/app-images/img_1.png',
                name: 'Croissant',
                price: '\$3.20',
                rating: '4.6',
              ),
              FoodCard(
                image: 'assets/app-images/img_2.png',
                name: 'Sandwich',
                price: '\$5.80',
                rating: '4.9',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
