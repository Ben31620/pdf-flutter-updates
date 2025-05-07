import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../utils/pdf_generator.dart'; // Assurez-vous que le générateur PDF est dans ce chemin

class Controle extends StatefulWidget {
  @override
  _ControleState createState() => _ControleState();
}

class _ControleState extends State<Controle> {
  final TextEditingController titreController = TextEditingController();
  final TextEditingController niveauController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final TextEditingController planController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  bool isCoffrageChecked = false;
  bool isFerraillageChecked = false;
  bool isReservationChecked = false;

  File? imageFile;

  // Fonction pour prendre une photo
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // Fonction pour générer le PDF
  void generatePDF() async {
    if (titreController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez renseigner au minimum le titre et la date.")),
      );
      return;
    }

    await generatePdf(
      titre: titreController.text,
      plan: planController.text,
      niveau: niveauController.text,
      commentaire: commentController.text,
      checkCoffrage: isCoffrageChecked,
      checkFerraillage: isFerraillageChecked,
      checkReservation: isReservationChecked,
      image: imageFile,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ PDF généré avec succès")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contrôle'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champs de saisie
            TextField(
              controller: titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: niveauController,
              decoration: InputDecoration(labelText: 'Niveau du bâtiment'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
            ),
            TextField(
              controller: planController,
              decoration: InputDecoration(labelText: 'Numéro de plan'),
            ),
            SizedBox(height: 20),
            Text('Vérifiez les points suivants :', style: TextStyle(fontSize: 18)),
            CheckboxListTile(
              title: Text('Coffrage conforme'),
              value: isCoffrageChecked,
              onChanged: (val) => setState(() => isCoffrageChecked = val ?? false),
            ),
            CheckboxListTile(
              title: Text('Ferraillage conforme'),
              value: isFerraillageChecked,
              onChanged: (val) => setState(() => isFerraillageChecked = val ?? false),
            ),
            CheckboxListTile(
              title: Text('Réservations conformes'),
              value: isReservationChecked,
              onChanged: (val) => setState(() => isReservationChecked = val ?? false),
            ),
            SizedBox(height: 10),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Commentaire',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            if (imageFile != null) Image.file(imageFile!, height: 150),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.camera_alt),
              label: Text('Prendre une photo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generatePDF,
              child: Text('Valider et générer le PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
