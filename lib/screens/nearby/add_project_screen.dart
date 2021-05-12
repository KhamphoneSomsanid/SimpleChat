import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/image_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  var stepValue = 0;

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _getWidget() {
    switch (stepValue) {
      case 0:
        return Column(
          children: [
            _getStepWidget(),
            UnderLineTextField(
              label: 'Title',
              controller: titleController,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: offsetMd),
              padding: EdgeInsets.symmetric(
                  horizontal: offsetBase, vertical: offsetSm),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
              ),
              child: MultiLineTextField(
                controller: contentController,
                hint: 'Please input your job description',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Files (Optional)',
                  style: semiBold.copyWith(
                    fontSize: fontMd,
                  ),
                ),
                InkWell(
                  onTap: () {
                    DialogService(context).showProjectDialog(
                        chooseImage: () {
                          Navigator.of(context).pop();
                          showPickerDialog(isVideo: false);
                        },
                        chooseVideo: () {
                          Navigator.of(context).pop();
                          showPickerDialog(isVideo: true);
                        },
                        chooseFile: () {});
                  },
                  child: Text(
                    '+ Add File',
                    style: semiBold.copyWith(
                        fontSize: fontMd,
                        color: primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            )
          ],
        );
    }
    return Container();
  }

  _getStepWidget() {
    var symbolSize = 24.0;
    var allSteps = 3;
    var descriptions = [
      'Please start your new job in here.\nYou can input all information for a new job.',
      'Description1 Description1 Description1 Description1 ',
      'Description1 Description1 Description1 Description1 ',
      'Description1 Description1 Description1 Description1 '
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: offsetBase, vertical: fontBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < allSteps; i++)
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: symbolSize,
                        height: symbolSize,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: i < stepValue
                                    ? primaryColor
                                    : i == stepValue
                                        ? Colors.red
                                        : Colors.grey),
                            borderRadius: BorderRadius.all(
                                Radius.circular(symbolSize / 2))),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: semiBold.copyWith(
                                fontSize: fontMd,
                                color: i < stepValue
                                    ? primaryColor
                                    : i == stepValue
                                        ? Colors.red
                                        : Colors.grey),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(horizontal: offsetSm),
                        height: 2,
                        color: Colors.grey,
                      )),
                    ],
                  ),
                ),
              Container(
                width: symbolSize,
                height: symbolSize,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: allSteps < stepValue
                            ? primaryColor
                            : allSteps == stepValue
                                ? Colors.red
                                : Colors.grey),
                    borderRadius:
                        BorderRadius.all(Radius.circular(symbolSize / 2))),
                child: Center(
                  child: Text(
                    '${allSteps + 1}',
                    style: semiBold.copyWith(
                        fontSize: fontMd,
                        color: allSteps < stepValue
                            ? primaryColor
                            : allSteps == stepValue
                                ? Colors.red
                                : Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: offsetBase,
          ),
          Text(
            descriptions[stepValue],
            style: mediumText.copyWith(fontSize: fontMd),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: MainBarWidget(
          titleString: 'Add Project',
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: SingleChildScrollView(
            child: _getWidget(),
          ),
        ),
      ),
    );
  }

  void showPickerDialog({bool isVideo = false}) {
    var pickers = [
      {
        'icon': Icons.image,
        'title': 'From Gallery',
        'source': ImageSource.gallery,
        'color': primaryColor
      },
      {
        'icon': Icons.videocam,
        'title': 'From Camera',
        'source': ImageSource.camera,
        'color': blueColor
      },
    ];
    DialogService(context).showCustomModalBottomSheet(
      titleWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: boldText.copyWith(fontSize: fontBase, color: Colors.red),
              ),
            ),
            Text(
              'Choose Media',
              style: boldText.copyWith(fontSize: fontLg),
            ),
            Text(
              'Cancel',
              style: boldText.copyWith(fontSize: fontBase, color: Colors.white),
            ),
          ],
        ),
      ),
      bodyWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Column(
          children: [
            Text(
              'Please choose the image picker source.',
              style: mediumText.copyWith(fontSize: fontMd),
            ),
            SizedBox(
              height: offsetMd,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: offsetLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var data in pickers)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (isVideo) {
                          _vidPicker(data['source']);
                        } else {
                          _imgPicker(data['source']);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: offsetBase, vertical: offsetBase),
                        decoration: BoxDecoration(
                          gradient: getGradientColor(color: data['color']),
                          borderRadius:
                              BorderRadius.all(Radius.circular(offsetBase)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              data['icon'],
                              size: 36,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: offsetSm,
                            ),
                            Text(
                              data['title'],
                              style: semiBold.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _imgPicker(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
        source: source, imageQuality: 50, maxWidth: 4000, maxHeight: 4000);
    if (image != null) {

    }
  }

  _vidPicker(ImageSource source) async {
    PickedFile video = await ImagePicker().getVideo(source: source);
    if (video != null) {

    }
  }
}
