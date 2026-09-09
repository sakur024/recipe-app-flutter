import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

/// Root authentication decision point.
///
/// Automatically switches between [MainShell] (when authenticated)
/// and [LoginScreen] (when unauthenticated) based on [AuthProvider].
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isAuthenticated) {
      return const MainShell();
    }

    return const LoginScreen();
  }
}
