import 'package:devscreening/helpers/styles.dart';
import 'package:flutter/material.dart';

class VisualTime extends StatefulWidget {
  Duration _elapsedTime;

  VisualTime(this._elapsedTime) {}

  @override
  _VisualTimeState createState() => _VisualTimeState();
}

class _VisualTimeState extends State<VisualTime> {
  @override
  int hoursFrom(Duration d) {
    return d.inHours;
  }

  int minutesFrom(Duration d) {
    return d.inMinutes - d.inHours * Duration.minutesPerHour;
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        verticalDirection: VerticalDirection.down,
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <Widget>[
          Text(
            hoursFrom(widget._elapsedTime).toString(),
            style: kVisualTimeDigitStyle,
          ),
          Text(
            'h',
            style: kVisualTimeDesignatorStyle,
          ),
          Text(minutesFrom(widget._elapsedTime).toString().padLeft(2, '0'),
              style: kVisualTimeDigitStyle),
          Text(
            'm',
            style: kVisualTimeDesignatorStyle,
          ),
        ],
      ),
    );
  }
}
