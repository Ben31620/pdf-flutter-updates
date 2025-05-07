import 'package:flutter/material.dart';
import '../verification/controle/controle.dart';

class HomeScreen extends StatelessWidget {
  Widget buildButton(BuildContext context, String title, IconData icon, Widget page) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 60),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novatec - Contrôle Béton',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildButton(context, 'Voile', Icons.account_balance_wallet_outlined, Controle()),
            SizedBox(height: 20),
            buildButton(context, 'Poteau', Icons.view_column, Controle()),
            SizedBox(height: 20),
            buildButton(context, 'Poutre', Icons.linear_scale, Controle()),
            SizedBox(height: 20),
            buildButton(context, 'Plancher', Icons.view_day, Controle()),
          ],
        ),
      ),
    );
  }
}
