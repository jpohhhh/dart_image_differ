import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

Future<Uint8List?> onOpenFile() async {
  final fileFormats = [Formats.png, Formats.jpeg, Formats.webp];
  final extensions = ['png', 'jpg', 'jpeg', 'webp'];
  final uniformTypeIdentifiers = <String>[];
  for (final fileFormat in fileFormats) {
    if (fileFormat.uniformTypeIdentifiers != null) {
      uniformTypeIdentifiers.addAll(fileFormat.uniformTypeIdentifiers!);
    }
  }
  XTypeGroup xTypeGroup = XTypeGroup(
    label: extensions.map((e) => '.$e').join(', '),
    extensions: extensions,
    // UTIs are required for iOS.
    uniformTypeIdentifiers: uniformTypeIdentifiers,
  );
  final XFile? file = await openFile(acceptedTypeGroups: [xTypeGroup]);
  if (file == null) {
    return null;
  }

  final bytes = await file.readAsBytes();
  if (bytes.isEmpty) {
    return null;
  }
  return bytes;
}
