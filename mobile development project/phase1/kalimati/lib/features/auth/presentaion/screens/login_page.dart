import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:class_manager/core/widgets/app_button.dart';
import 'package:class_manager/core/widgets/app_input_field.dart';
import 'package:class_manager/features/auth/presentaion/providers/auth_provider.dart';
import 'package:class_manager/features/auth/domain/enums/user_role.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final success = await ref
          .read(currentUserNotifierProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          final authState = ref.read(currentUserNotifierProvider);
          final currentUser = authState.value;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );

          if (currentUser?.role == UserRole.student) {
            context.go('/learning_packages');
          } else if (currentUser?.role == UserRole.teacher) {
            context.go('/teacher_tools');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unknown user role'),
                backgroundColor: Colors.red,
              ),
            );
            ref.read(currentUserNotifierProvider.notifier).logout();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _fillDemoAccount(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(currentUserNotifierProvider);
    final isLoading = _isLoading || authState.isLoading;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.purple),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_outlined,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Kalimati',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Learn Words, Build Knowledge',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isMobile ? 0 : 32,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),

                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 32),

                              AppInputField(
                                label: 'Email',
                                hint: 'Enter your email',
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              AppInputField(
                                label: 'Password',
                                hint: 'Enter your password',
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),

                              AppButton(
                                text: 'Login',
                                onPressed: _handleLogin,
                                isLoading: isLoading,
                              ),
                              const SizedBox(height: 24),

                              const SizedBox(height: 40),

                              const Text(
                                'Demo Accounts:',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),

                              const Text(
                                'Student Account:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _DemoAccountItem(
                                label: 'Homer Simpson (Student)',
                                email: 'a4@test.com',
                                onTap: () =>
                                    _fillDemoAccount('a4@test.com', 'pass123'),
                              ),
                              const SizedBox(height: 16),

                              const Text(
                                'Teacher Accounts:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _DemoAccountItem(
                                label: 'Homer Simpson (Teacher)',
                                email: 'a1@test.com',
                                onTap: () =>
                                    _fillDemoAccount('a1@test.com', 'pass123'),
                              ),
                              const SizedBox(height: 8),
                              _DemoAccountItem(
                                label: 'Sponge Bob',
                                email: 'a2@test.com',
                                onTap: () =>
                                    _fillDemoAccount('a2@test.com', 'pass123'),
                              ),
                              const SizedBox(height: 8),
                              _DemoAccountItem(
                                label: 'Bugs Bunny',
                                email: 'a3@test.com',
                                onTap: () =>
                                    _fillDemoAccount('a3@test.com', 'pass123'),
                              ),
                              const SizedBox(height: 16),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class _DemoAccountItem extends StatelessWidget {
  final String label;
  final String email;
  final VoidCallback onTap;

  const _DemoAccountItem({
    required this.label,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Text(
                email,
                style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
