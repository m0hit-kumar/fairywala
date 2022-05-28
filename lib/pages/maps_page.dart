import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

class MapsPage extends StatefulWidget {
  final List<double> list;
  MapsPage({required this.list});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late HereMapController _hereMapController;
  // showing here map
  void _onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController;

    _hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError? error) {
      if (error != null) {
        Fluttertoast.showToast(
            msg: 'Map scene not loaded. MapError: ${error.toString()}');
        // print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 8000;
      hereMapController.camera.lookAtPointWithDistance(
          GeoCoordinates(widget.list[0], widget.list[1]),
          distanceToEarthInMeters);
      hereMapController.pinWidget(
          const Icon(
            Icons.location_on,
            size: 40,
            color: Colors.red,
          ),
          GeoCoordinates(widget.list[0], widget.list[1]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: HereMap(onMapCreated: _onMapCreated));
  }
}
