import 'package:flutter/material.dart';
import 'TransferenciasScreen.dart'; // tu pantalla completa de transferencias
import 'DepositosScreen.dart';      // tu pantalla completa de depósitos

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
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flourescent_sharp),
            label: 'Transferencias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Depósitos',
          ),
        ],
      ),
    );
  }
}
