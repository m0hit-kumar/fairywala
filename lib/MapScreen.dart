import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  Set<Marker> markers = Set();
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(30.35545508927541, 76.75529017839561), zoom: 21.5);
  final Stream<QuerySnapshot> vendorsStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        markers.clear();
        if (snapshot.hasData) {
          // GeoPoint location = snapshot.data!.docs.first.get("location");
          // final latLng = LatLng(location.latitude, location.longitude);
          print("22222222222222222222 ${snapshot.data?.docs}");

          // Map<String, dynamic> data = snapshot.data! as Map<String, dynamic>;

//           data.forEach(){
// print();
//           }
          // print(data["loc"]);
          // print("-------------------------- $data");
          return GoogleMap(
              mapType: MapType.normal,
              markers: {
                // Marker(
                //   markerId: MarkerId(data["loc"].latitude),
                //   position:
                //       LatLng(data["loc"].latitude, data["position"].longitude),
                // ),
                const Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(30.35545508927541, 76.75529017839561),
                ),
                const Marker(
                  markerId: MarkerId("2"),
                  position: LatLng(30.355355253859837, 76.75530135870328),
                ),
                const Marker(
                  markerId: MarkerId("3"),
                  position: LatLng(30.35544049649795, 76.7551568393346),
                ),
                const Marker(
                  markerId: MarkerId("4"),
                  position: LatLng(30.355605924697695, 76.75527305530395),
                ),
                const Marker(
                  markerId: MarkerId("5"),
                  position: LatLng(30.35571986855334, 76.75534536665494),
                ),
              },
              //  controller: controller,

              //   onMapCreated: ((controller) {
              //   _googleMapController=controller;
              // }),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition);
        }
        return Center(child: CircularProgressIndicator());

        // return ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data =
        //         document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       title: Text(data['Name']),
        //       subtitle: Text(data['Name']),
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}
    // return const GoogleMap(
    //     myLocationButtonEnabled: false,
    //     zoomControlsEnabled: false,
    //     initialCameraPosition: _initialCameraPosition);
 