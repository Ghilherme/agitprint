import 'dart:io';
import 'dart:typed_data';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSource extends StatefulWidget {
  const ImagePickerSource(
      {Key key,
      this.image,
      this.callback,
      this.isAvatar = false,
      this.imageQuality,
      this.heightImageNetwork,
      this.widthImageNetwork,
      this.isRunningWeb = false})
      : super(key: key);
  final String image;
  final bool isAvatar;
  final int imageQuality;
  final double heightImageNetwork;
  final double widthImageNetwork;
  final bool isRunningWeb;

  final Function(String, Uint8List) callback;

  @override
  _ImagePickerSourceState createState() => _ImagePickerSourceState(image);
}

class _ImagePickerSourceState extends State<ImagePickerSource> {
  _ImagePickerSourceState(this.image);
  final String image;
  XFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;
  bool kIsWeb = true;

  @override
  void initState() {
    super.initState();
    if (this.image != null && this.image.isNotEmpty)
      _imageFile = XFile(this.image);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAvatar
        ? Column(children: [
            CircleAvatar(
              child: IconButton(
                iconSize: 40,
                color: Colors.grey[600],
                icon: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo,
                      )
                    : Icon(Icons.add_a_photo, color: Colors.transparent),
                onPressed: () {
                  showModal(context);
                },
              ),
              radius: 60,
              backgroundImage: _imageFile == null
                  ? Image.asset(
                      'assets/icons/avatar_placeholder.png',
                    ).image
                  : _previewImage(),
            ),
            _imageFile == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _imageFile == null
                          ? Container()
                          : IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 35,
                                color: textLightColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                            ),
                      Container(width: 20),
                      IconButton(
                        iconSize: 40,
                        color: Colors.blue,
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () {
                          showModal(context);
                        },
                      )
                    ],
                  ),
          ])
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _imageFile == null
                  ? Container(
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300)),
                        label: Text(
                          'Comprovante',
                          style: GoogleTextStyles.customTextStyle(),
                        ),
                        icon: Icon(Icons.add_a_photo, color: Colors.grey[600]),
                        onPressed: () {
                          showModal(context);
                        },
                      ),
                    )
                  : Image(
                      image: _previewImage(),
                      height: widget.heightImageNetwork ?? null,
                      width: widget.widthImageNetwork ?? null,
                    ),
              _imageFile == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 25,
                          color: Colors.blue,
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            showModal(context);
                          },
                        ),
                        Container(width: 20),
                        _imageFile == null
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: 25,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                              ),
                      ],
                    ),
            ],
          );
  }

  ImageProvider _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null)
      return Image.file(File('assets/images/error_message.png')).image;

    if (_imageFile != null) {
      if (kIsWeb)
        return Image.network(
          _imageFile.path,
        ).image;
      else
        return Image.file(File(_imageFile.path)).image;
    } else if (_pickImageError != null)
      return Image.file(File('assets/images/error_message.png')).image;

    return null;
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> showModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.isRunningWeb
                  ? [
                      IconButton(
                        icon: Icon(Icons.collections,
                            size: 40, color: Colors.blue),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                          Navigator.of(context).pop();
                        },
                      )
                    ]
                  : [
                      IconButton(
                        icon: Icon(Icons.add_a_photo,
                            size: 40, color: Colors.blue),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);
                          kIsWeb = false;
                          Navigator.of(context).pop();
                        },
                      ),
                      Container(width: 20),
                      IconButton(
                        icon: Icon(Icons.collections,
                            size: 40, color: Colors.blue),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                          kIsWeb = false;
                          Navigator.of(context).pop();
                        },
                      )
                    ],
            ),
          ),
        );
      },
    );
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.pickImage(
          source: source, imageQuality: widget.imageQuality);
      setState(() {
        _imageFile = pickedFile;
      });
      if (pickedFile != null) {
        var bytes = await _imageFile.readAsBytes();
        widget.callback(_imageFile.path, bytes);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
}
