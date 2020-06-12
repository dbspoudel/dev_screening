import 'package:flutter/material.dart';

class TitleAndAction {
  final String title;
  final Function action;

  TitleAndAction({@required this.title, @required this.action});
}

class SimpleAlertDialog extends StatelessWidget {
  final String message;
  final TitleAndAction rightButton;
  final TitleAndAction middleButton;
  final TitleAndAction leftButton;

  SimpleAlertDialog(
      {@required this.message,
      @required this.rightButton,
      this.middleButton,
      this.leftButton});

  Widget makeFlatButton(TitleAndAction detail) {
    return FlatButton(
      child: Text(detail.title),
      onPressed: detail.action,
    );
  }

  List<Widget> _getActionButtons() {
    List<Widget> result = new List<Widget>();

    if (null != leftButton) result.add(makeFlatButton(leftButton));
    if (null != middleButton) result.add(makeFlatButton(middleButton));
    result.add(makeFlatButton(rightButton));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: _getActionButtons(),
    );
  }
}
