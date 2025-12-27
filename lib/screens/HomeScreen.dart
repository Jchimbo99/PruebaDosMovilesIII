import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(color: Colors.black54),

          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 16),

                const Text(
                  "Bienvenido a tu Sistema de Transacciones Jch",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Controla tu dinero de manera segura",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: 220,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 18, 201, 233),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    child: const Text("Iniciar sesión"),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/registro"),
                  child: const Text(
                    "Crear cuenta",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.4),
        child: const Text(
          "Evaluación realizada por:\nJorge Chimbo\nGitHub: Jchimbo99",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
