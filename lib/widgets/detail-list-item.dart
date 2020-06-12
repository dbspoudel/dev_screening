import 'package:devscreening/helpers/styles.dart';
import 'package:devscreening/model/app-types.dart';
import 'package:devscreening/widgets/visual-time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DetailListItem extends StatefulWidget {
  final ScrollController topController;
  final ScrollController bottomController;
  final PanelData panelData;
  final Key key = GlobalKey();
  final bool canAssign;
  final bool canRemove;
  final Color panelColour;

  DetailListItem({
    @required this.panelData,
    this.canAssign = false,
    this.canRemove = false,
    this.panelColour = Colors.grey,
    this.topController,
    this.bottomController,
  });

  @override
  _DetailListItemState createState() => _DetailListItemState();
}

class _DetailListItemState extends State<DetailListItem> {
  bool _isExtraDetailVisible = false;
  GlobalKey _mainPanelKey = GlobalKey();

  Row getDetail(bool isExtraDetailVisible) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            color: widget.panelColour,
            child: Column(
              children: <Widget>[
                Row(
                  key: _mainPanelKey,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 55.0,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 5.0),
                                      child: Text(
                                        widget.panelData.mainText,
                                        style: kTaskTextStyle,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        VisualTime(widget.panelData.duration),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Visibility(
                      visible: isExtraDetailVisible,
                      child: Expanded(
                          child: Container(
                              child: Table(
                        columnWidths: {
                          0: FractionColumnWidth(0.30),
                          1: FractionColumnWidth(0.05),
                          2: FractionColumnWidth(0.30)
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(3.0, 3.0, 0.0, 3.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Sub Text 1:',
                                      style: kOperationTextStyle)),
                            ),
                            Text(' '),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 0.0),
                              child: Text(widget.panelData.subText1,
                                  style: kOperationTextStyle),
                            )
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(3.0, 3.0, 0.0, 3.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Subtext 2:',
                                      style: kOperationTextStyle)),
                            ),
                            Text(' '),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 0.0),
                              child: Text(widget.panelData.subText2,
                                  style: kOperationTextStyle),
                            )
                          ])
                        ],
                      ))),
                    )
                  ],
                ),
                //Divider( height: 3, color: Colors.white,)
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState activeState = Provider.of<AppState>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExtraDetailVisible = !_isExtraDetailVisible;
        });
      },
      child: Visibility(
        visible: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            color: widget.panelColour,
            elevation: 1.0,
            clipBehavior: Clip.antiAlias,
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                padding: EdgeInsets.all(0.0),
                child: IntrinsicHeight(
                  child: getDetail(_isExtraDetailVisible),
                ),
              ),
              actions: !widget.canAssign
                  ? null
                  : <Widget>[
                      IconSlideAction(
                        caption: 'Assign',
                        color: Colors.green,
                        icon: Icons.archive,
                        onTap: () {
                          activeState.movePanelToTop(
                              topController: widget.topController,
                              movePanel: widget.panelData);
                        },
                      ),
                    ],
              secondaryActions: !widget.canRemove
                  ? null
                  : [
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.archive,
                        onTap: () {
                          activeState.movePanelToBottom(
                              bottomController: widget.bottomController,
                              movePanel: widget.panelData);
                        },
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
