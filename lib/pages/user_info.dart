import 'dart:async';
import 'package:fairywala/providers/submit_page_provider.dart';
import 'package:fairywala/pages/service_request_submit_loading_screen.dart';
import 'package:fairywala/widgets/input.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:fairywala/models/service_modal.dart';
import 'package:fairywala/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../widgets/button.dart';
import '../widgets/field_title.dart';

class UserSubmitInfo extends StatefulWidget {
  UserSubmitInfo({Key? key}) : super(key: key);

  @override
  _UserSubmitInfoState createState() => _UserSubmitInfoState();
}

class _UserSubmitInfoState extends State<UserSubmitInfo> {
  String username = 'user';
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  bool hasValue = false;
  late StreamSubscription _streamSubscription;
  // late final manager;

  var _initialCameraPosition = const CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final Set<Marker> _markers = {};
  Location currentLocation = Location();
  GoogleMapController? _googleMapController;
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? time;
  late DateTime date;
  late int _phoneNumber;

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    late Map<String, dynamic> userInfo;
    await FirebaseFirestore.instance
        .collection('customers')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get()
        .then(
      (field) {
        // print('%%%%%%%%%-->${field.docs[0].reference.collection('donations').add()['username']}');
        return userInfo = {
          'username': field.docs.single.data()['username'],
          'email': field.docs.single.data()['email'],
        };
      },
    ).catchError((err) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(err.toString()),
      //   backgroundColor: Theme.of(context).errorColor,
      // ));
    });
    return userInfo;
  }

  Future fetchUserData() async {
    final Map<String, dynamic> userInfo = await getUserInfo(currentUserUid);
    username = userInfo['username']!;
    _emailController.text = userInfo['email']!;
  }

  void getLocation() async {
    _streamSubscription = currentLocation.onLocationChanged.listen(
      (LocationData loc) {
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
          ),
        );
        setState(() {
          _initialCameraPosition = CameraPosition(
            target: LatLng(loc.latitude!, loc.longitude!),
            zoom: 16,
          );
          if (hasValue == false) {
            _googleMapController!.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            );
            hasValue = true;
          }
          _markers.add(Marker(
              markerId: MarkerId('Home'),
              position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
          print('${loc.latitude} ${loc.longitude}');
        });
      },
    );
  }

  void getDate() async {
    date = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime.now().add(Duration(days: 7)),
    ))!;

    if (date != null) {
      _dateController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  void getTime() async {
    time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      _timeController.text = DateFormat().add_jm().format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          time!.hour,
          time!.minute));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData().whenComplete(() => setState(() => {}));
    print('getting in init');
    // getLocation();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<SubmitPageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                radius: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 36,
                    ),
                    SizedBox(height: 6),
                    Text(
                      username.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            FieldTitle(title: 'Email'),
            InputField(_emailController, TextInputType.emailAddress),
            SizedBox(height: 14),
            FieldTitle(title: 'Phone Number'),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    primaryBoxShadow,
                  ],
                  color: secondaryColor,
                ),
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  controller: _phoneController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14),
                  validator: (text) {
                    if (text != null && (text.length < 10 || text.isEmpty)) {
                      return 'Enter a valid mobile number';
                    }
                  },
                  onChanged: (text) {
                    _formKey.currentState!.validate();
                    setState(() => _phoneNumber = int.parse(text));
                  },
                ),
              ),
            ),
            SizedBox(height: 14),
            Text(
              'Add the location of delivery/service point',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.baseline,
              // textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldTitle(title: 'Date'),
                        GestureDetector(
                          onTap: getDate,
                          child: AbsorbPointer(
                            child: InputField(
                              _dateController,
                              TextInputType.text,
                              suffix:
                                  Icon(Icons.date_range, color: Colors.black),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldTitle(title: 'Time'),
                        GestureDetector(
                          onTap: getTime,
                          child: AbsorbPointer(
                            child: InputField(
                              _timeController,
                              TextInputType.text,
                              suffix:
                                  Icon(Icons.access_time, color: Colors.black),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            FieldTitle(title: 'Address of service/delivery'),
            SizedBox(height: 8),
            InputField(_locationController, TextInputType.streetAddress),
            SizedBox(height: 14),
            Container(
              color: Colors.black.withOpacity(0.3),
              height: 200,
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    markers: _markers,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: ElevatedButton(
                      onPressed: () => _googleMapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                              _initialCameraPosition)),
                      child: Text('Reset'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Button('SUBMIT', () async {
              _locationController.text = 29.6923.toString();
              if (_emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Enter the email address.'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              } else if (!_formKey.currentState!.validate()) {
                // on success, notify the parent widget
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Check your phone number again.'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              } else if (_dateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Enter the pickup date.'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              } else if (_timeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Enter the pickup time.'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              } else if (_locationController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Enter the pickup location.'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              } else {
                Service service = Service(
                    consumerName: username,
                    items: manager.items,
                    accepted: false,
                    recieveDateTime: DateTime(date.year, date.month, date.day,
                        time!.hour, time!.minute),
                    consumerEmail: _emailController.text,
                    recieveCoordinates: (29.6923).toString(),
                    consumerID: currentUserUid,
                    consumerPhone: _phoneNumber,
                    createdON: DateTime.now(),
                    serviceCategory: ServiceCategory.Vegetable);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServiceRequestSubmitLoadingScreen(
                            service: service)));
              }
            }),
            SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xFFE78888),
              ),
              child: Text(
                'Warning:  False Requests for service can result in ban of your account',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
