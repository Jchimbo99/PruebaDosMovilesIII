import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DepositosScreen extends StatefulWidget {
  const DepositosScreen({super.key});

  @override
  State<DepositosScreen> createState() => _DepositosScreenState();
}

class _DepositosScreenState extends State<DepositosScreen> {
  final TextEditingController cuentaController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  bool cargando = false;
  final Color colorPrincipal = const Color.fromARGB(255, 69, 156, 19);

  List<dynamic> depositos = [];

  @override
  void initState() {
    super.initState();
    cargarDepositos();
  }

  Future<void> cargarDepositos() async {
    final String response = await rootBundle.loadString('assets/data/depositos.json');
    final data = await json.decode(response);
    setState(() {
      depositos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Depósitos"),
        backgroundColor: colorPrincipal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORMULARIO DE DEPÓSITO
            TextField(
              controller: cuentaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Número de cuenta",
                prefixIcon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monto a depositar",
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: cargando ? null : () => realizarDeposito(context),
                child: cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Depositar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Depósitos registrados",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // LISTVIEW DE DEPÓSITOS
            Expanded(
              child: depositos.isEmpty
                  ? const Center(child: Text("No hay depósitos"))
                  : ListView.builder(
                      itemCount: depositos.length,
                      itemBuilder: (context, index) {
                        final deposito = depositos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Image.network(
                              deposito['imagen'] ?? "https://via.placeholder.com/50",
                              width: 50,
                              height: 50,
                            ),
                            title: Text("Monto: \$${deposito['monto']}"),
                            subtitle: Text("Banco: ${deposito['banco'] ?? 'Desconocido'}"),
                            onTap: () {
                              mostrarAlerta(
                                context,
                                "Detalles del depósito",
                                "Cuenta: ${deposito['cuenta']}\nMonto: \$${deposito['monto']}\nBanco: ${deposito['banco'] ?? 'Desconocido'}",
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void realizarDeposito(BuildContext context) {
    if (cuentaController.text.isEmpty || montoController.text.isEmpty) {
      mostrarAlerta(context, "Alerta", "Complete todos los campos");
      return;
    }

    setState(() => cargando = true);

    // Simulación de guardado local / backend
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => cargando = false);
      depositos.add({
        "cuenta": cuentaController.text.trim(),
        "monto": montoController.text.trim(),
        "banco": "Banco Ejemplo",
        "imagen": "https://via.placeholder.com/50"
      });
      cuentaController.clear();
      montoController.clear();
      mostrarAlerta(context, "Éxito", "Depósito realizado correctamente");
    });
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
