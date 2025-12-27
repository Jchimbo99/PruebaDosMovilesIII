import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TransferenciasScreen extends StatefulWidget {
  const TransferenciasScreen({super.key});

  @override
  State<TransferenciasScreen> createState() => _TransferenciasScreenState();
}

class _TransferenciasScreenState extends State<TransferenciasScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController montoController = TextEditingController();

  final DatabaseReference ref = FirebaseDatabase.instance.ref("transferencias");
  final Color colorPrincipal = const Color.fromARGB(255, 69, 156, 19);
  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferencias"),
        backgroundColor: colorPrincipal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "ID de transferencia",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre destinatario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monto a transferir",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: cargando ? null : guardarTransferencia,
                child: cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Guardar Transferencia",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void guardarTransferencia() async {
    final id = idController.text.trim();
    final nombre = nombreController.text.trim();
    final monto = montoController.text.trim();

    if (id.isEmpty || nombre.isEmpty || monto.isEmpty) {
      mostrarAlerta(context, "Alerta", "Complete todos los campos");
      return;
    }

    setState(() => cargando = true);

    try {
      final nuevaRef = ref.push();
      await nuevaRef.set({
        "id transferencia": id,
        "nombre destinatario": nombre,
        "monto a transferir": monto,
      });

      idController.clear();
      nombreController.clear();
      montoController.clear();

      mostrarAlerta(context, "Éxito", "Transferencia guardada correctamente");
    } catch (e) {
      mostrarAlerta(context, "Error", "No se pudo guardar la transferencia");
    } finally {
      setState(() => cargando = false);
    }
  }

  void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }
}
