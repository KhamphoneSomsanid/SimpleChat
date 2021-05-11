import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
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
                Text(
                  '+ Add File',
                  style: semiBold.copyWith(
                      fontSize: fontMd,
                      color: primaryColor,
                      decoration: TextDecoration.underline),
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
}
