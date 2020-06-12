import 'package:devscreening/model/app-types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AppFloatingActionButton extends StatelessWidget {
  final double _speedDialOffset = 90.0;

  final TextStyle _fabNumericTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
  final TextStyle _fabTitleTextStyle =
      TextStyle(fontWeight: FontWeight.normal, fontSize: 10);

  final TextStyle _fabItemNumericTextStyle = TextStyle(
    fontSize: 40,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  final TextStyle _fabItemDetailTextStyle = TextStyle(
      fontFamily: 'RobotoCondensed',
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: Colors.black);

  SpeedDialChild _getSpeedDialChild(BuildContext context, IconData icon,
      String numericComponent, String message) {
    return SpeedDialChild(
        child: Icon(icon),
        backgroundColor: Theme.of(context).primaryColorDark,
        labelWidget: Container(
          width: MediaQuery.of(context).size.width - _speedDialOffset,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(numericComponent, style: _fabItemNumericTextStyle),
              SizedBox(width: 10),
              Expanded(
                  flex: 1,
                  child: Text(
                    message,
                    style: _fabItemDetailTextStyle,
                  ))
            ],
          ),
        ),
        onTap: () => print('FIRST CHILD'));
  }

  List<SpeedDialChild> _getSpeedDialChildren(BuildContext context) {
    const List<Tuple3<IconData, String, String>> items = [
      Tuple3<IconData, String, String>(Icons.ac_unit, '3',
          'Notice centrality of text regardless of how many lines of text there are'),
      Tuple3<IconData, String, String>(
          Icons.airline_seat_flat, '9', 'Reasons to go to bed'),
      Tuple3<IconData, String, String>(Icons.alarm, '8', 'Alarms set'),
      Tuple3<IconData, String, String>(
          Icons.attach_file, '7', 'Paperclips on my desk'),
      Tuple3<IconData, String, String>(
          Icons.check_circle_outline, '4', 'Things going right at the moment'),
    ];

    return items
        .map((e) => _getSpeedDialChild(context, e.item1, e.item2, e.item3))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, value, child) {
        return Opacity(
          opacity: value.isScrolling ? 0.2 : 1.0,
          child: SpeedDial(
            backgroundColor: Colors.red,
            curve: Curves.bounceIn,
            elevation: 8.0,
            overlayOpacity: 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '9+',
                  style: _fabNumericTextStyle,
                ),
                Text(
                  'TO DO',
                  style: _fabTitleTextStyle,
                ),
              ],
            ),
            children: _getSpeedDialChildren(context),
          ),
        );
      },
    );
  }
}
