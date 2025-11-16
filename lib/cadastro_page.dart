import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  String nome = '';
  String email = '';
  String senha = '';
  bool _loading = false;

  void _mostrarDados() {
    print("dados cadastro");
    print('Nome: $nome');
    print('Email: $email');
    print('Senha: $senha');
  }

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    _mostrarDados();

    setState(() => _loading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = cred.user;

      if (user != null) {
        await user.updateDisplayName(nome);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'nome': nome,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await user.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cadastro realizado! Verifique seu email para ativar a conta.'),
        ));

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao registrar: ${e.message}';
      if (e.code == 'email-already-in-use') {
        message = 'Esse email já está em uso.';
      } else if (e.code == 'weak-password') {
        message = 'Senha muito fraca.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => nome = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Por favor, insira seu nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value ?? '',
                validator: (value) => value != null && value.contains('@') ? null : 'Por favor, insira um email válido',
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                onSaved: (value) => senha = value ?? '',
                validator: (value) => value != null && value.length >= 7 ? null : 'A senha deve ter pelo menos 7 caracteres',
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      onPressed: _registrarUsuario,
                      child: const Text('Cadastrar', style: TextStyle(fontSize: 18)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
