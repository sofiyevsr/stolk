import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LogoFileView extends FormField<File> {
  LogoFileView(Function(File?) onSaved)
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
              _LogoFileView(state: state),
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

class _LogoFileView extends StatefulWidget {
  final FormFieldState<File> state;
  _LogoFileView({Key? key, required this.state}) : super(key: key);

  @override
  _LogoFileViewState createState() => _LogoFileViewState();
}

class _LogoFileViewState extends State<_LogoFileView> {
  final _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final file = await _picker.getImage(
          source: ImageSource.gallery,
        );
        if (file != null) {
          File? croppedFile = await ImageCropper.cropImage(
            sourcePath: file.path,
            aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
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
      child: CircleAvatar(
        radius: 70,
        child: _image != null
            ? ClipRRect(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(70),
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
