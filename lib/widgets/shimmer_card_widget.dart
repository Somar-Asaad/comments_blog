import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarShimmer(),
            const SizedBox(width: 10),
            Expanded(child: _buildContentShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const CircleAvatar(
        radius: 25,
      ),
    );
  }

  Widget _buildContentShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: _buildVerticalShimmer(),
              flex: 1,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: _buildVerticalShimmer(),
              flex: 2,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: _buildVerticalShimmer(),
              flex: 1,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: _buildVerticalShimmer(),
              flex: 2,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildVerticalShimmer(),
      ],
    );
  }

  Widget _buildVerticalShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        height: 20,
        width: double.infinity,
      ),
    );
  }
}
