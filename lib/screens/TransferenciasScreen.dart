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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferencias"),
        backgroundColor: colorPrincipal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "ID de transferencddia",
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: guardarTransferencia,
                child: const Text(
                  "Guardar Transferencia",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transferencias registradas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            // LISTVIEW
            Expanded(
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.snapshot.value;
                  if (data == null) return const Center(child: Text("No hay transferencias"));

                  // Convertir a lista
                  final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
                  final items = map.entries.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final key = items[index].key;
                      final value = items[index].value as Map<dynamic, dynamic>;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          leading: Image.network(
                            value['imagen'] ?? "https://via.placeholder.com/50",
                            width: 50,
                            height: 50,
                          ),
                          title: Text("Monto: \$${value['monto']}"),
                          subtitle: Text("Banco: ${value['banco'] ?? 'Desconocido'}"),
                          onTap: () {
                            mostrarAlerta(
                              context,
                              "Detalles de la transferencia",
                              "ID: ${value['id']}\nDestinatario: ${value['nombre']}\nMonto: \$${value['monto']}\nBanco: ${value['banco'] ?? 'Desconocido'}",
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void guardarTransferencia() {
    final id = idController.text.trim();
    final nombre = nombreController.text.trim();
    final monto = montoController.text.trim();

    if (id.isEmpty || nombre.isEmpty || monto.isEmpty) {
      mostrarAlerta(context, "Alerta", "Complete todos los campos");
      return;
    }

    final nuevaRef = ref.push();
    nuevaRef.set({
      "id": id,
      "nombre": nombre,
      "monto": monto,
      "banco": "Banco Ejemplo",
      "imagen": "https://via.placeholder.com/50",
    });

    idController.clear();
    nombreController.clear();
    montoController.clear();
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
