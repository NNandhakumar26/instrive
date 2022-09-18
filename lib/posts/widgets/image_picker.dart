import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/widgets/alert_dialog.dart';

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
      child: Column(
        children: ['Camera', 'Gallery']
            .map(
              (e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      List<XFile?>? image;
                      if (e == 'Camera') {
                        image!.add(
                          await _picker.pickImage(
                            source: ImageSource.camera,
                          ),
                        );
                      } else {
                        image = (canMultiSelect)
                            ? await _picker.pickMultiImage()
                            : [
                                await _picker.pickImage(
                                  source: ImageSource.gallery,
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
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
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
    );
  }
}
