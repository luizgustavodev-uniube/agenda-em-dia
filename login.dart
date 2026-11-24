import 'package:flutter/material.dart';

import 'calendario.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final campoEmail = TextEditingController();
  final campoSenha = TextEditingController();

  // Cada e-mail é a chave usada para encontrar a senha de teste.
  final Map<String, String> contas = {};
  bool cadastrando = false;

  void mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void confirmar() {
    final email = campoEmail.text.trim().toLowerCase();
    final senha = campoSenha.text;

    if (email.isEmpty || senha.trim().isEmpty) {
      mostrarMensagem('Preencha o e-mail e a senha.');
      return;
    }

    if (cadastrando) {
      if (contas.containsKey(email)) {
        mostrarMensagem('Esse e-mail já está cadastrado.');
        return;
      }

      contas[email] = senha;
      campoSenha.clear();
      setState(() {
        cadastrando = false;
      });
      mostrarMensagem('Conta criada! Digite a senha para entrar.');
    } else if (contas[email] == senha) {
      campoSenha.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TelaCalendario()),
      );
    } else {
      mostrarMensagem('E-mail ou senha incorretos.');
    }
  }

  @override
  void dispose() {
    campoEmail.dispose();
    campoSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      appBar: AppBar(
        title: const Text('Agenda em Dia'),
        backgroundColor: const Color(0xFFF3E8FF),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6D28D9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.event_available,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  cadastrando ? 'Criar conta' : 'Entrar na agenda',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: campoEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: campoSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senhaa',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFBE185D),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: confirmar,
                  child: Text(cadastrando ? 'Cadastrar' : 'Entrar'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () {
                    campoSenha.clear();
                    setState(() {
                      cadastrando = !cadastrando;
                    });
                  },
                  child: Text(cadastrando ? 'Voltar ao login' : 'Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
