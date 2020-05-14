import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;


  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    // создаем файл
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    // если пользователь вышел из камеры, не сделав снимок
    if (imageFile == null) return;
    // сразу отображаем его в превью
    setState(() {
      _storedImage = imageFile;
    });
    // путь к директории App Documents
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    // зная путь созданного файла, получаем его имя
    final fileName = path.basename(imageFile.path);
    // копируем созданный файл
    final savedImage = await imageFile.copy('${appDir.path}/$fileName}');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No image taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(height: 10),
        Expanded(
          child: FlatButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera),
            label: Text(
              'Take Picture',
            ),
            textColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
