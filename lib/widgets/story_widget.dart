import 'package:flutter/material.dart';

import 'package:simplechat/models/story_model.dart';
import 'package:simplechat/screens/story/add_story_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/utils/dimens.dart';

class StoryWidget extends StatefulWidget {
  final List<dynamic> stories;
  final Function() refresh;

  const StoryWidget({
    Key key,
    @required this.stories,
    this.refresh,
  }) : super(key: key);

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  var stories = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.symmetric(horizontal: offsetSm, vertical: offsetXSm),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                NavigatorService(context).pushToWidget(
                    screen: AddStoryScreen(),
                    pop: (value) {
                      if (value != null) {
                        if (widget.refresh != null) widget.refresh();
                      }
                    });
              },
              child: StoryModel().addCell()),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: stories.length,
              itemBuilder: (context, i) {
                return stories[i].cell();
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
