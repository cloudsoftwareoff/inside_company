import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> requestStoragePermissions() async {
  PermissionStatus status = await Permission.storage.request();

  while (!status.isGranted) {
    // Permission denied, request again
    status = await Permission.storage.request();
  }
}

Future<void> downloadFile(Opportunity op, BuildContext context) async {
  String? path = op.letter_link;
  if (path == null) {
    print('Error: No file path provided');
    return;
  }

  List<String> parts = path.split('/');
  String fileName = parts.isNotEmpty ? parts.last : '';
  if (fileName.isEmpty) {
    print('Error: Invalid file name');
    return;
  }

  try {
    await requestStoragePermissions();

    final res =
        Supabase.instance.client.storage.from('inside').getPublicUrl(fileName);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Downloading...")));
    FileDownloader.downloadFile(
        url: res,
        name: fileName, //(optional)

        onDownloadCompleted: (String path) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Downloaded!")));
        },
        onDownloadError: (String error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("error : $error")));
        });
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("error : $e")));
  }
}
