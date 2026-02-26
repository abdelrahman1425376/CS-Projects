import 'package:flutter/material.dart';
import '../../domain/entities/learning_package.dart';
import 'modern_package_card.dart';

class PackagesList extends StatelessWidget {
  final List<LearningPackage> packages;

  const PackagesList({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isMobile = screenWidth < 600;
    final horizontalPadding = isMobile ? 16.0 : (isTablet ? 32.0 : 24.0);

    if (packages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No packages found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (isTablet) {
      int crossAxisCount = 2;
      if (screenWidth >= 1200) {
        crossAxisCount = 4;
      } else if (screenWidth >= 1000) {
        crossAxisCount = 3;
      } else if (screenWidth >= 768) {
        crossAxisCount = 2;
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: crossAxisCount > 3 ? 0.9 : 1.2,
          ),
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return ModernPackageCard(package: package, isTablet: true);
          },
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          return ModernPackageCard(package: package, isTablet: false);
        },
      );
    }
  }
}
