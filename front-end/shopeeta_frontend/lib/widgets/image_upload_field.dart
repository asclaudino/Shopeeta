import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUploadWithHttp extends StatelessWidget {
  const FileUploadWithHttp({
    super.key,
    required this.objFile,
    required this.chooseFileUsingFilePicker,
    required this.imageBytes,
  });

  final PlatformFile? objFile;
  final Function chooseFileUsingFilePicker;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: imageBytes == null
                ? Center(
                    child: TextButton(
                      child: const Text("Escolher Imagem"),
                      onPressed: () => chooseFileUsingFilePicker(),
                    ),
                  )
                : Image.memory(imageBytes!, fit: BoxFit.contain),
          ),
        ),
        if (objFile != null)
          TextButton(
            child: const Text("Trocar Imagem"),
            onPressed: () => chooseFileUsingFilePicker(),
          ),
        //------Show file name when file is selected
        if (objFile != null) Text("File name : ${objFile!.name}"),
        //------Show file size when file is selected
        if (objFile != null) Text("File size : ${objFile!.size} bytes"),
      ],
    );
  }
}
