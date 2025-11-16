import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);

    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = cred.user;
      if (user != null) {
        if (!user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Email não verificado. Verifique sua caixa de entrada.'),
            duration: Duration(seconds: 4),
          ));
        }

        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao logar: ${e.message}';
      if (e.code == 'user-not-found') message = 'Usuário não encontrado.';
      if (e.code == 'wrong-password') message = 'Senha incorreta.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendPasswordReset() async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o email para reset.')));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email de reset enviado.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (v) => email = v ?? '',
                validator: (v) => v != null && v.contains('@') ? null : 'Insira um email válido',
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                onSaved: (v) => senha = v ?? '',
                validator: (v) => v != null && v.length >= 6 ? null : 'Senha inválida',
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Entrar'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.cadastro),
                          child: const Text('Criar conta'),
                        ),
                        TextButton(
                          onPressed: _sendPasswordReset,
                          child: const Text('Esqueci minha senha'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
