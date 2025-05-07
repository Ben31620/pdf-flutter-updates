import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePdf({
  required String titre,
  required String plan,
  required String niveau,
  required String commentaire,
  required bool checkCoffrage,
  required bool checkFerraillage,
  required bool checkReservation,
  File? image,
}) async {
  final pdf = pw.Document();

  try {
    // Chargement du logo depuis les assets
    final logoBytes = await rootBundle.load('assets/icons/app_icon.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Préparer l'image de l'utilisateur (si fournie)
    pw.MemoryImage? imageProvider;
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      imageProvider = pw.MemoryImage(imageBytes);
    }

    // Création de la page PDF
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Logo seul en haut à gauche
            pw.Row(
              children: [
                pw.Image(logoImage, width: 60),
              ],
            ),

            // Titre centré
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                "Rapport de Contrôle",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 30),

            // Informations
            pw.Text("Titre : $titre"),
            pw.Text("Plan : $plan"),
            pw.Text("Niveau : $niveau"),
            pw.Text("Date : ${DateTime.now().toIso8601String().split('T')[0]}"),
            pw.SizedBox(height: 20),

            // Contrôles cochés
            pw.Text("Vérifiez les points suivants :"),
            if (checkCoffrage) pw.Bullet(text: 'Coffrage conforme'),
            if (checkFerraillage) pw.Bullet(text: 'Ferraillage conforme'),
            if (checkReservation) pw.Bullet(text: 'Réservations conformes'),
            pw.SizedBox(height: 10),

            // Commentaire
            pw.Text("Commentaire :"),
            pw.Text(commentaire),
            pw.SizedBox(height: 20),

            // Image ajoutée par l'utilisateur
            if (imageProvider != null) pw.Image(imageProvider, height: 200),
          ],
        ),
      ),
    );

    // Enregistrement dans un répertoire externe accessible
    final directory = await getExternalStorageDirectory();
    final fileName = "$titre-${DateTime.now().millisecondsSinceEpoch}.pdf";
    final filePath = "${directory!.path}/$fileName";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    // Aperçu ou partage du PDF
    await Printing.sharePdf(bytes: await file.readAsBytes(), filename: "$titre.pdf");

    print("✅ PDF généré avec succès : $filePath");

  } catch (e) {
    print("❌ Erreur lors de la génération du PDF : $e");
  }
}
