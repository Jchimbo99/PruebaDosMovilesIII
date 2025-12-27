import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login de usuario"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 69, 156, 19),
      ),
      body: const _FormularioLogin(),
    );
  }
}

class _FormularioLogin extends StatefulWidget {
  const _FormularioLogin();

  @override
  State<_FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<_FormularioLogin> {
  final TextEditingController correo = TextEditingController();
  final TextEditingController contrasenia = TextEditingController();

  bool cargando = false;
  final Color colorPrincipal = const Color.fromARGB(255, 69, 156, 19);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login, size: 90, color: colorPrincipal),
          const SizedBox(height: 20),

          TextField(
            controller: correo,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Correo electrónico",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: contrasenia,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Contraseña",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorPrincipal,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: cargando ? null : () => iniciarSesion(context),
              child: cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Iniciar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> iniciarSesion(BuildContext context) async {
    if (correo.text.isEmpty || contrasenia.text.isEmpty) {
      mostrarAlerta(context, "Alerta", "Complete todos los campos");
      return;
    }

    try {
      setState(() => cargando = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correo.text.trim(),
        password: contrasenia.text.trim(),
      );

      
      Navigator.pushReplacementNamed(context, "/bancaria");
    } on FirebaseAuthException catch (e) {
      String mensaje = "Error al iniciar sesión";

      if (e.code == 'user-not-found') {
        mensaje = "Usuario no registrado";
      } else if (e.code == 'wrong-password') {
        mensaje = "Contraseña incorrecta";
      }

      mostrarAlerta(context, "Error", mensaje);
    } finally {
      setState(() => cargando = false);
    }
  }
}

void mostrarAlerta(
  BuildContext context,
  String titulo,
  String mensaje, {
  bool cerrarPantalla = false,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (cerrarPantalla) Navigator.pop(context);
          },
          child: const Text("Aceptar"),
        ),
      ],
    ),
  );
}
