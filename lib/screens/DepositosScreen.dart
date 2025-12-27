import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DepositosScreen extends StatefulWidget {
  const DepositosScreen({super.key});

  @override
  State<DepositosScreen> createState() => _DepositosScreenState();
}

class _DepositosScreenState extends State<DepositosScreen> {
  List<dynamic> depositos = [];
  final Color colorPrincipal = const Color.fromARGB(255, 69, 156, 19);

  @override
  void initState() {
    super.initState();
    cargarDepositos();
  }

  Future<void> cargarDepositos() async {
    final String response = await rootBundle.loadString(
      'assets/data/depositos.json', 
    );
    final data = json.decode(response);
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
      body: depositos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: depositos.length,
  itemBuilder: (context, index) {
    final deposito = depositos[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Image.network(
          deposito['detalles']['imagen_comprobante'] ??
              "https://via.placeholder.com/50",
          width: 50,
          height: 50,
        ),
        title: Text(
          deposito['banco'] ?? 'Desconocido', // SOLO BANCO
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Monto: \$${deposito['monto'] ?? '0'}", // SOLO MONTO
        ),
        onTap: () {
          mostrarAlerta(
            context,
            "Detalles de la transferencia",
            "De: ${deposito['origen']['nombre']} (${deposito['origen']['tipo_cuenta']})\n"
            "Cuenta: ${deposito['origen']['número_cuenta']}\n\n"
            "A: ${deposito['destino']['nombre']} (${deposito['destino']['tipo_cuenta']})\n"
            "Cuenta: ${deposito['destino']['número_cuenta']}\n\n"
            "Banco: ${deposito['banco']}\n"
            "Monto: \$${deposito['monto']}\n"
            "Método: ${deposito['detalles']['método_pago']}\n"
            "Estado: ${deposito['detalles']['estado']}",
          );
        },
      ),
    );
  },
),

    );
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
