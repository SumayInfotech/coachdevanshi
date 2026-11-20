// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';

class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Greeting Banner Skeleton
        _buildShimmerSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(height: 12, width: 140, borderRadius: 6),
              const SizedBox(height: 8),
              _buildShimmerBox(height: 24, width: 220, borderRadius: 6),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 2. Your Plan Card Skeleton
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: _buildShimmerSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(height: 22, width: 90, borderRadius: 12),
                    _buildShimmerBox(height: 22, width: 70, borderRadius: 12),
                  ],
                ),
                const SizedBox(height: 16),
                _buildShimmerBox(height: 18, width: 180, borderRadius: 6),
                const SizedBox(height: 8),
                _buildShimmerBox(height: 18, width: 120, borderRadius: 6),
                const SizedBox(height: 16),
                _buildShimmerBox(height: 8, width: double.infinity, borderRadius: 4),
                const SizedBox(height: 12),
                _buildShimmerBox(height: 12, width: 160, borderRadius: 6),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Today's Overview Grid Skeleton
        _buildShimmerSection(
          child: _buildShimmerBox(height: 20, width: 160, borderRadius: 6),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMetricCardSkeleton()),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCardSkeleton()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCheckInCardSkeleton()),
            const SizedBox(width: 12),
            Expanded(child: _buildCheckInCardSkeleton()),
          ],
        ),
        const SizedBox(height: 16),

        // 4. Today's Actions Skeleton
        _buildShimmerSection(
          child: Column(
            children: [
              _buildShimmerBox(height: 48, width: double.infinity, borderRadius: 30),
              const SizedBox(height: 10),
              _buildShimmerBox(height: 48, width: double.infinity, borderRadius: 30),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 5. Quick Access Grid Skeleton
        _buildShimmerSection(
          child: _buildShimmerBox(height: 20, width: 130, borderRadius: 6),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildQuickAccessCardSkeleton()),
            const SizedBox(width: 10),
            Expanded(child: _buildQuickAccessCardSkeleton()),
            const SizedBox(width: 10),
            Expanded(child: _buildQuickAccessCardSkeleton()),
          ],
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildMetricCardSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildShimmerSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(height: 12, width: 90, borderRadius: 6),
            const SizedBox(height: 6),
            _buildShimmerBox(height: 12, width: 60, borderRadius: 6),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildShimmerBox(height: 36, width: 36, shape: BoxShape.circle),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(height: 16, width: 50, borderRadius: 4),
                      const SizedBox(height: 6),
                      _buildShimmerBox(height: 12, width: 40, borderRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildShimmerSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerBox(height: 32, width: 32, shape: BoxShape.circle),
                _buildShimmerBox(height: 18, width: 45, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 10),
            _buildShimmerBox(height: 13, width: 90, borderRadius: 4),
            const SizedBox(height: 6),
            _buildShimmerBox(height: 11, width: 65, borderRadius: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 85,
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildShimmerSection(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildShimmerBox(height: 30, width: 30, shape: BoxShape.circle),
            const SizedBox(height: 8),
            _buildShimmerBox(height: 11, width: 60, borderRadius: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerSection({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }

  Widget _buildShimmerBox({
    required double height,
    double? width,
    double borderRadius = 8,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius) : null,
      ),
    );
  }
}
