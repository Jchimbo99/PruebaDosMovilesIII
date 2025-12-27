import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de usuario"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 69, 156, 19),
      ),
      body: const _FormularioRegistro(),
    );
  }
}

class _FormularioRegistro extends StatefulWidget {
  const _FormularioRegistro();

  @override
  State<_FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<_FormularioRegistro> {
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
          Icon(Icons.person_add, size: 90, color: colorPrincipal),
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
              onPressed: cargando ? null : () => registrarUsuario(context),
              child: cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Registrar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= REGISTRO =================
  Future<void> registrarUsuario(BuildContext context) async {
    if (correo.text.isEmpty || contrasenia.text.isEmpty) {
      mostrarAlerta(context, "Alerta", "Complete todos los campos");
      return;
    }

    try {
      setState(() => cargando = true);

      UserCredential credencial =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo.text.trim(),
        password: contrasenia.text.trim(),
      );

      User user = credencial.user!;

      DatabaseReference ref =
          FirebaseDatabase.instance.ref("usuarios/${user.uid}");

      await ref.set({
        "correo": correo.text.trim(),
      });

      mostrarAlerta(
        context,
        "Registro exitoso",
        "Usuario registrado correctamente",
        cerrarPantalla: true,
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = "Error al registrar";

      if (e.code == 'email-already-in-use') {
        mensaje = "El correo ya está registrado";
      } else if (e.code == 'weak-password') {
        mensaje = "La contraseña es muy débil";
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
