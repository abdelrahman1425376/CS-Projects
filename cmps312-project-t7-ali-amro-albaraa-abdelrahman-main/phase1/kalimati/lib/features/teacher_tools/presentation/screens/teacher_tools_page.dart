import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:class_manager/features/auth/presentaion/providers/auth_provider.dart';
import 'package:class_manager/features/view_learning_packages/presentation/providers/learning_package_provider.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';

import 'package:class_manager/features/teacher_tools/presentation/screens/create_package_screen.dart';
import 'package:class_manager/features/teacher_tools/presentation/widgets/summary_card.dart';
import 'package:class_manager/features/teacher_tools/presentation/widgets/package_card.dart';

class TeacherToolsPage extends ConsumerWidget {
  const TeacherToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserNotifierProvider);
    final currentUser = authState.value;
    final packagesAsync = ref.watch(learningPackageNotifierProvider);

    // Filter packages by current teacher's email
    final teacherPackages = packagesAsync.when(
      data: (packages) =>
          packages.where((pkg) => pkg.author == currentUser?.email).toList(),
      loading: () => <LearningPackage>[],
      error: (_, __) => <LearningPackage>[],
    );

    final totalPackages = teacherPackages.length;
    final publishedPackages = teacherPackages
        .where((pkg) => pkg.published)
        .length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top header with Home
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black54),
                    onPressed: () {
                      ref.read(currentUserNotifierProvider.notifier).logout();
                      context.go('/login');
                    },
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Packages',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your learning content',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.library_books,
                          iconColor: const Color(0xFF3498DB),
                          value: totalPackages.toString(),
                          label: 'Total Packages',
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: SummaryCard(
                          icon: Icons.visibility,
                          iconColor: Colors.green.shade400,
                          value: publishedPackages.toString(),
                          label: 'Published',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Learning Packages',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            final email = currentUser?.email ?? '';
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CreatePackageScreen(
                                  currentUserEmail: email,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Create'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: packagesAsync.when(
                      data: (allPackages) {
                        if (teacherPackages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.library_books_outlined,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No packages yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Create your first learning package',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 1;
                                if (constraints.maxWidth > 600) {
                                  crossAxisCount = 2;
                                }
                                if (constraints.maxWidth > 900) {
                                  crossAxisCount = 3;
                                }
                                if (constraints.maxWidth > 1200) {
                                  crossAxisCount = 4;
                                }

                                return GridView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 1.8,
                                      ),
                                  itemCount: teacherPackages.length,
                                  itemBuilder: (context, index) {
                                    final package = teacherPackages[index];
                                    return PackageCard(package: package);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
