import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/demand.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/demand_db.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool uploaded = false;
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> setData(Map<String, Object> data) async {
    print(databaseReference.path);
    try {
      DatabaseReference newChildRef = databaseReference.push();
      await newChildRef.set(data);
      print('Data saved successfully at path: ${newChildRef.path}');
    } on FirebaseException catch (error) {
      print('Error saving data: $error');
    }
  }

  final supabase = Supabase.instance.client;
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
              'Opportunity: ${widget.opportunity.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Content: ${widget.opportunity.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (_selectedFile != null) Text(_selectedFile!.path),
            if (_selectedFile == null)
              ElevatedButton(
                onPressed: () async {
                  // Pick a PDF file
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
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
                  String fileName =
                      "${DateTime.now().millisecondsSinceEpoch}.pdf";

                  final String path =
                      await supabase.storage.from('inside').upload(
                            '$fileName',
                            _selectedFile!,
                            fileOptions: const FileOptions(
                                cacheControl: '3600', upsert: false),
                          );
                  widget.opportunity.letter_link = path;

                  // try {
                  //   TaskSnapshot snapshot = await FirebaseStorage.instance
                  //       .ref(
                  //           'pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf')
                  //       .putFile(_selectedFile!);
                  //   String downloadUrl = await snapshot.ref.getDownloadURL();

                  //   widget.opportunity.letter_link = downloadUrl;

                  //   setState(() {
                  //     _uploading = false;
                  //   });
                  // } catch (e) {
                  //   print('Error uploading file: $e');

                  //   // Show an error message if the upload fails
                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //     content: Text('Failed to upload file: $e'),
                  //     backgroundColor: Colors.red,
                  //   ));
                  // }
                  setState(() {
                    _uploading = false;
                    uploaded = true;
                  });
                },
                child: _uploading
                    ? CircularProgressIndicator()
                    : Text('Upload File'),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (uploaded)
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedFile == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('No PDF was picked'),
                        ));
                        return;
                      }
                      try {
                        // Update the status of the opportunity to "Confirmed"

                        await OpportunityDB().updateOpportunityStatus(
                            widget.opportunity.id,
                            'CONFIRMED',
                            widget.opportunity.letter_link!);

                        Map<String, Object> op = new Map<String, Object>();
                        op.putIfAbsent("id", () => widget.opportunity.id);
                        op["title"] = widget.opportunity.title;
                        op["desc"] = widget.opportunity.description;
                        op["r"] = "0";

                        //! fix this nonsense
                        // print('loading');
                        // await setData(op);
                        // print("loaded");
                        await DemandDB().addDemand(Demand(
                          state: "PENDING",
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            opportunityId: widget.opportunity.id,
                            budget: widget.opportunity.budget,
                            dateDA: Timestamp.now()));
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Opportunity confirmed successfully.'),
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
