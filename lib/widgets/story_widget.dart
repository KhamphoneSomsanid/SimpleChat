import 'package:flutter/material.dart';

import 'package:simplechat/models/story_model.dart';
import 'package:simplechat/screens/story/add_story_screen.dart';
import 'package:simplechat/screens/story/story_detail_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

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
          if (widget.stories.isNotEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.stories.length,
                itemBuilder: (context, i) {
                  return widget.stories[i].cell(
                      content: _getContent(widget.stories[i]),
                      action: () {
                        NavigatorService(context).pushToWidget(
                            screen: StoryDetailScreen(
                          list: widget.stories[i].list,
                          user: widget.stories[i].user,
                        ));
                      });
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _getContent(story) {
    switch (story.list.last.type) {
      case 'IMAGE':
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(
            story.list.last.thumbnail,
            fit: BoxFit.cover,
            loadingBuilder: (context, widget, event) {
              return event == null
                  ? widget
                  : Center(
                      child: Image.asset(
                        'assets/icons/ic_logo.png',
                        color: Colors.grey,
                        width: 48,
                        fit: BoxFit.fitWidth,
                      ),
                    );
            },
          ),
        );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: offsetXSm),
      decoration: BoxDecoration(
        gradient: getGradientColor(color: getRandomColor()),
      ),
      child: Center(
        child: Text(
          story.list.last.content,
          textAlign: TextAlign.center,
          style: semiBold.copyWith(fontSize: fontXSm, color: Colors.white),
          maxLines: 2,
        ),
      ),
    );
  }
}
