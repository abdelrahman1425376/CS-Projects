import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/learning_package_provider.dart';
import '../widgets/learning_packages_header.dart';
import '../widgets/packages_counter.dart';
import '../widgets/level_filter.dart';
import '../widgets/packages_list.dart';

class LearningPackagesPage extends ConsumerStatefulWidget {
  const LearningPackagesPage({super.key});

  @override
  ConsumerState<LearningPackagesPage> createState() =>
      _LearningPackagesPageState();
}

class _LearningPackagesPageState extends ConsumerState<LearningPackagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLevel = 'All';
  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {});
    if (query.isEmpty) {
      ref.read(learningPackageNotifierProvider.notifier).resetToAllPackages();
    } else {
      ref.read(learningPackageNotifierProvider.notifier).searchPackages(query);
    }
  }

  void _onLevelChanged(String? level) {
    if (level != null) {
      setState(() {
        _selectedLevel = level;
      });
      if (level == 'All') {
        ref.read(learningPackageNotifierProvider.notifier).resetToAllPackages();
      } else {
        ref.read(learningPackageNotifierProvider.notifier).filterByLevel(level);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(learningPackageNotifierProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final horizontalPadding = isMobile
        ? 16.0
        : (screenWidth >= 768 ? 32.0 : 24.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            LearningPackagesHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
            ),

            packagesAsync.when(
              data: (allPackages) {
                final publishedPackages = allPackages
                    .where((pkg) => pkg.published)
                    .toList();
                return PackagesCounter(packages: publishedPackages);
              },
              loading: () => SizedBox(
                height: isMobile ? 35 : 40,
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => SizedBox(
                height: isMobile ? 35 : 40,
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),

            LevelFilter(
              selectedLevel: _selectedLevel,
              levels: _levels,
              onChanged: _onLevelChanged,
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                12,
              ),
              color: Colors.grey.shade50,
              child: Text(
                'Learning Packages',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Expanded(
              child: packagesAsync.when(
                data: (allPackages) {
                  final packages = allPackages
                      .where((pkg) => pkg.published)
                      .toList();
                  return PackagesList(packages: packages);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.purple),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading packages',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Retry logic could be added here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
