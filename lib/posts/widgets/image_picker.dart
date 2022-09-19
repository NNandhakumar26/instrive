import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImageWidget extends StatelessWidget {
  final bool canMultiSelect;
  GetImageWidget({
    Key? key,
    this.canMultiSelect = true,
  }) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Camera', 'Gallery']
              .map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () async {
                        List<XFile?>? image = [];
                        if (e == 'Camera') {
                          await _picker
                              .pickImage(
                                source: ImageSource.camera,
                                // imageQuality: 75,
                              )
                              .then((value) => image!.add(value));
                        } else {
                          image = (canMultiSelect)
                              ? await _picker.pickMultiImage(
                                  // imageQuality: 75,
                                  )
                              : [
                                  await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    // imageQuality: 75,
                                  )
                                ];
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pop(
                          context,
                          ((image == null) || image.isEmpty)
                              ? null
                              : image
                                  .map(
                                    (e) => File(e!.path),
                                  )
                                  .toList(),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      title: Text(
                        e,
                      ),
                    ),
                    PopupMenuDivider(
                      height: 16,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
