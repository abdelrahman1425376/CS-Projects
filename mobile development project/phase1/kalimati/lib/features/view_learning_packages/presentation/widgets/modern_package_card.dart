import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/learning_package.dart';
import 'download_button.dart';

class ModernPackageCard extends ConsumerWidget {
  final LearningPackage package;
  final bool isTablet;

  const ModernPackageCard({
    super.key,
    required this.package,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 0 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Row(
      children: [
        _buildPackageIcon(),
        const SizedBox(width: 16),

        Expanded(child: _buildPackageContent()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildPackageIcon(),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getLevelColor(package.level),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                package.level,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                package.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                package.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              _buildPackageInfo(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: DownloadButton(package: package),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPackageIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: package.iconUrl.isNotEmpty
            ? Image.network(
                package.iconUrl,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _getFallbackIcon(package.title, package.category),
                    size: 30,
                    color: Colors.white,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              )
            : Icon(
                _getFallbackIcon(package.title, package.category),
                size: 30,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildPackageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                package.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getLevelColor(package.level),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                package.level,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          package.description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildPackageInfo(),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: DownloadButton(package: package),
        ),
      ],
    );
  }

  Widget _buildPackageInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'by ${package.author}',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                package.category,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${package.words.length} words',
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getFallbackIcon(String title, String category) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('places') || lowerTitle.contains('town')) {
      return Icons.location_on;
    }
    if (lowerTitle.contains('corona') || lowerTitle.contains('health')) {
      return Icons.coronavirus;
    }
    if (lowerTitle.contains('fruit') ||
        lowerTitle.contains('apple') ||
        lowerTitle.contains('grapes')) {
      return Icons.apple;
    }
    if (lowerTitle.contains('vocabulary') || lowerTitle.contains('english')) {
      return Icons.lightbulb;
    }
    if (lowerTitle.contains('shop') || lowerTitle.contains('store')) {
      return Icons.store;
    }

    switch (category.toLowerCase()) {
      case 'travel':
        return Icons.place;
      case 'health and fitness':
        return Icons.health_and_safety;
      case 'food':
        return Icons.restaurant;
      case 'education':
        return Icons.school;
      case 'technology':
        return Icons.computer;
      case 'business':
        return Icons.business;
      default:
        return Icons.library_books;
    }
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
