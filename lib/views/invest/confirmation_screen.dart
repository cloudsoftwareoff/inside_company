import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:firebase_storage/firebase_storage.dart';
class ConfirmationScreen extends StatefulWidget {
  final Opportunity opportunity;

  const ConfirmationScreen({Key? key, required this.opportunity})
      : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  File? _selectedFile;
  bool _uploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Opportunity: ${widget.opportunity.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Content: ${widget.opportunity.content}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
          
            ElevatedButton(
              onPressed: () async {
                // Pick a PDF file from device
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result != null) {
                  setState(() {
                    _selectedFile = File(result.files.single.path!);
                  });
                }
              },
              child: const Text('Pick PDF'),
            ),
              if (_selectedFile != null)
            ElevatedButton(
              onPressed: () async {
                // Upload the selected file to Firebase Storage
                setState(() {
                  _uploading = true;
                });
                try {
                  TaskSnapshot snapshot = await FirebaseStorage.instance
                      .ref('pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf')
                      .putFile(_selectedFile!);
                  String downloadUrl = await snapshot.ref.getDownloadURL();
                  
                  widget.opportunity.letter_link = downloadUrl;
                  
                  setState(() {
                    _uploading = false;
                  });
                } catch (e) {
                  print('Error uploading file: $e');
                  setState(() {
                    _uploading = false;
                  });
                  // Show an error message if the upload fails
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to upload file: $e'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: _uploading ? CircularProgressIndicator() : Text('Upload File'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Update the status of the opportunity to "Confirmed"
                      await OpportunityDB().updateOpportunityStatus(
                          widget.opportunity.id, 'CONFIRMED');

                      if (mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Opportunity confirmed successfully.'),
                        ));

                        Navigator.pop(context);
                      }
                    } catch (e) {
                      // Show an error message if updating the status fails
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Failed to confirm the opportunity: $e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Cancel confirmation and navigate back
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
