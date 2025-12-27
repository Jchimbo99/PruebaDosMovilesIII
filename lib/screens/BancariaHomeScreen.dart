import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BancariaHome extends StatefulWidget {
  const BancariaHome({super.key});

  @override
  State<BancariaHome> createState() => _BancariaHomeState();
}

class _BancariaHomeState extends State<BancariaHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TransferenciasScreen(),
    const DepositosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 69, 156, 19),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Transferencias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Depósitos',
          ),
        ],
      ),
    );
  }
}

// ------------------ Transferencias ------------------

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferencias"),
        backgroundColor: const Color.fromARGB(255, 69, 156, 19),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORMULARIO
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "ID de transferencia"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre destinatario"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Monto a transferir"),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 69, 156, 19),
                ),
                onPressed: guardarTransferencia,
                child: const Text("Guardar Transferencia"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transferencias registradas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // LISTVIEW
            Expanded(
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final data = snapshot.data!.snapshot.value;
                  if (data == null) return const Center(child: Text("No hay transferencias"));

                  final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
                  final items = map.entries.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final value = items[index].value as Map<dynamic, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
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


class DepositosScreen extends StatelessWidget {
  const DepositosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Depósitos"),
        backgroundColor: const Color.fromARGB(255, 69, 156, 19),
      ),
      body: const Center(
        child: Text(
          "Pantalla de Depósitos",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
