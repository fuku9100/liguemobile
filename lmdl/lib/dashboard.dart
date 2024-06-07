// dashboard.dart
import 'package:flutter/material.dart';
import 'view_page.dart'; // Import the View page here
import 'edit_page.dart'; // Import the Edit page here
import 'add_page.dart'; // Import the Add page here
import 'delete_page.dart'; // Import the Delete page here

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the View page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewPage(),
                  ),
                );
              },
              child: const Text('Voir'),
            ),
            const SizedBox(height: 16), // Spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to the Edit page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditPage(),
                  ),
                );
              },
              child: const Text('Modifier'),
            ),
            const SizedBox(height: 16), // Spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to the Add page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPage(),
                  ),
                );
              },
              child: const Text('Ajouter'),
            ),
            const SizedBox(height: 16), // Spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to the Delete page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeletePage(),
                  ),
                );
              },
              child: const Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }
}