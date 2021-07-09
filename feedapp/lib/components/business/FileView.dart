import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FileView extends FormField<File> {
  FileView(Function(File?) onSaved)
      : super(
          onSaved: onSaved,
          validator: (file) {
            if (file == null) {
              return tr("choose_image");
            }
            return null;
          },
          builder: (state) => Column(
            children: [
              _FileView(state: state),
              if (state.errorText != null)
                Text(
                  state.errorText!,
                  style:
                      Theme.of(state.context).inputDecorationTheme.errorStyle,
                ),
            ],
          ),
        );
}

class _FileView extends StatefulWidget {
  final FormFieldState<File> state;
  _FileView({Key? key, required this.state}) : super(key: key);

  @override
  _FileViewState createState() => _FileViewState();
}

class _FileViewState extends State<_FileView> {
  final _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        final file = await _picker.getImage(
          source: ImageSource.gallery,
        );
        if (file != null) {
          File? croppedFile = await ImageCropper.cropImage(
            sourcePath: file.path,
            aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
            aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
            androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              showCropGrid: true,
              cropGridColor: Colors.black,
              cropGridStrokeWidth: 1,
            ),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          );
          widget.state.didChange(croppedFile);
          setState(() {
            _image = croppedFile;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        height: (size.width - 56) * 9 / 16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            const Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.blue,
            width: 7,
          ),
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
                child: Image.file(
                  _image!,
                  fit: BoxFit.contain,
                ),
              )
            : Center(
                child: Icon(
                  Icons.image_sharp,
                  size: 44,
                ),
              ),
      ),
    );
  }
}
