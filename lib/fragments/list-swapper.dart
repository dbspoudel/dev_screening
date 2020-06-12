import 'package:devscreening/model/app-types.dart';
import 'package:devscreening/widgets/detail-list-item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ListSwapper extends StatelessWidget {
  ScrollController topController = new ScrollController();
  ScrollController bottomController = new ScrollController();

  TextStyle get titleTextStyle => TextStyle(
      fontFamily: "Montserrat",
      fontSize: 22,
      color: Colors.black87,
      fontWeight: FontWeight.bold);
  Widget verticalDivider(Color color) => SizedBox(
        width: 5.0,
        height: 30.0,
        child: Container(color: color),
      );

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  child: Card(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Row(
                          children: <Widget>[
                            verticalDivider(Colors.green),
                            SizedBox(width: 10.0),
                            Text('Slide panel left to reveal button',
                                style: titleTextStyle),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Visibility(
              visible: appState.topList.length == 0,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                      // Colors.white,
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).primaryColorDark,
                    ])),
                height: 50,
                // color: Theme.of(context).primaryColorDark,
                child: Center(
                  child: Text(
                    "I'm sad.  :-(  Add something here !",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 3,
              ),
              child: AnimationLimiter(
                child: ListView(
                  controller: topController,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: appState.topList
                      .map((e) => DetailListItem(
                            topController: topController,
                            bottomController: bottomController,
                            panelData: e,
                            canAssign: false,
                            canRemove: true,
                            panelColour: Colors.white,
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  child: Card(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Row(
                          children: <Widget>[
                            verticalDivider(Colors.red),
                            SizedBox(width: 10.0),
                            Text('Slide panel right to reveal button',
                                style: titleTextStyle),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  //AppScaffoldState s = Provider.of<AppScaffoldState>( context, listen: false );
                  bool isScrolling = (notification is UserScrollNotification &&
                              notification.direction == ScrollDirection.idle) ||
                          notification is ScrollEndNotification
                      ? false
                      : true;

                  appState.isScrolling = isScrolling;
                  return true;
                },
                child: Container(
                  color: Colors.grey[300],
                  child: AnimationLimiter(
                    child: ListView.builder(
                        itemCount: appState.bottomList.length,
                        controller: bottomController,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(milliseconds: 400),
                              child: SlideAnimation(
                                  verticalOffset: 100.0,
                                  child: FadeInAnimation(
                                    child: DetailListItem(
                                      topController: topController,
                                      bottomController: bottomController,
                                      panelData: appState.bottomList[index],
                                      canAssign: true,
                                      canRemove: false,
                                      panelColour: Colors.white,
                                    ),
                                  )));
                        }
                        // child: ListView(
                        //   controller: bottomController,
                        //   physics: BouncingScrollPhysics(),
                        //   children: appState.bottomList
                        //       .map((e) => DetailListItem(
                        //             topController: topController,
                        //             bottomController: bottomController,
                        //             panelData: e,
                        //             canAssign: true,
                        //             canRemove: false,
                        //             panelColour: Theme.of(context).primaryColorDark,
                        //           ))
                        //       .toList(),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }
}
