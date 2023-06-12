import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MySpeedDial extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final color;
  final Function() edit;
  final Function() delete;
  final Function() share;
  const MySpeedDial(
      {super.key,
      required this.color,
      required this.edit,
      required this.delete,
      required this.share});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SpeedDial(
      buttonSize: Size(size.width * 0.04, size.height * 0.04),
      icon: Icons.settings,
      useRotationAnimation: true,
      direction: SpeedDialDirection.down,
      iconTheme: IconThemeData(
        color: color,
        size: 40,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 30,
      spaceBetweenChildren: 6,
      children: [
        SpeedDialChild(
            child: Icon(Icons.edit,
                color: Theme.of(context).scaffoldBackgroundColor),
            label: 'Editar',
            backgroundColor: Theme.of(context).iconTheme.color,
            onTap: edit),
        SpeedDialChild(
            child: Icon(Icons.delete,
                color: Theme.of(context).scaffoldBackgroundColor),
            label: 'Eliminar',
            backgroundColor: Theme.of(context).iconTheme.color,
            onTap: delete),
        SpeedDialChild(
            child: Icon(Icons.share, color: Theme.of(context).iconTheme.color),
            label: 'Compartir',
            backgroundColor: Theme.of(context).canvasColor,
            onTap: share),
      ],
    );
  }
}
