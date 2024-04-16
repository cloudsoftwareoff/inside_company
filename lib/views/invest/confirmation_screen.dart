import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';

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
  bool _uploaded = false;
  final supabase = Supabase.instance.client;

  Future<void> _pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      _uploading = true;
    });

    try {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.pdf";
      final String path = await supabase.storage.from('inside').upload(
            '$fileName',
            _selectedFile!,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );
      widget.opportunity.letter_link = path;
      setState(() {
        _uploading = false;
        _uploaded = true;
      });
    } catch (error) {
      print('Error uploading file: $error');
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Opportunity: ${widget.opportunity.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Content: ${widget.opportunity.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _selectedFile != null
                ? Text(_selectedFile!.path)
                : ElevatedButton(
                    onPressed: _pickPDFFile,
                    child: const Text('Pick PDF'),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploading ? null : _uploadFile,
              child: _uploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload File'),
            ),
            const SizedBox(height: 16),
            _uploaded
                ? ElevatedButton(
                    onPressed: () async {
                      if (_selectedFile == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('No PDF was picked'),
                        ));
                        return;
                      }
                      try {
                        final databaseRef = FirebaseDatabase.instance.ref().child(
                            'notification/dir_info/${widget.opportunity.id}/');
                        await databaseRef.set({
                          "title": widget.opportunity.title,
                          "r": "0",
                          "id": widget.opportunity.id
                        });
                        await OpportunityDB().updateOpportunityStatus(
                            widget.opportunity.id,
                            'CONFIRMED',
                            widget.opportunity.letter_link!);
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Opportunity confirmed successfully.'),
                          ));
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Failed to confirm the opportunity: $e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: const Text('Confirm'),
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
