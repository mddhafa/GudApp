import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/build_context_ext.dart';
import 'package:gudapp/core/extensions/customesncakbar.dart';
import 'package:gudapp/data/model/request/auth/login_request_model.dart';
import 'package:gudapp/presentation/homepage.dart';
import 'package:gudapp/presentation/auth/register_screen.dart';
import 'package:gudapp/presentation/auth/bloc/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      final request = LoginRequestModel(
        email: _emailController.text,
        password: _passwordController.text,
      );
      context.read<LoginBloc>().add(LoginRequested(requestModel: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.error)));
            showCustomSnackBar(
              context,
              state.error,
              backgroundColor: Colors.red,
              icon: Icons.error,
            );
          } else if (state is LoginSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.responseModel.message ?? 'Login berhasil'),
            //   ),
            // );
            showCustomSnackBar(
              context,
              state.responseModel.message ?? 'Login berhasil',
              backgroundColor: Colors.green,
              icon: Icons.check_circle,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warehouse_rounded,
                      size: 72,
                      color: Color(0xFF932520),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selamat Datang di GudApp',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Silakan login untuk melanjutkan',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Email wajib diisi'
                                  : null,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Password wajib diisi'
                                  : null,
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Color(0xFF932520),
                        ),
                        onPressed: state is LoginLoading ? null : _submitLogin,
                        child:
                            state is LoginLoading
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                                : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                ),
                                ),
                      ),
                    ),

                    // const SizedBox(height: 16),
                    // Text('© 2025 GudApp', style: theme.textTheme.bodySmall?.copyWith(
                    //   color: Colors.grey[600],
                    // )
                    // ),

                    const SizedBox(height: 20),
                    Text.rich(TextSpan(
                      text: 'Belum memiliki akun? Silahkan ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                      children: [
                        TextSpan(
                          text: 'Daftar disini!',
                          style: const TextStyle(color: Color(0xFF932520)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(const RegisterScreen());
                            },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
