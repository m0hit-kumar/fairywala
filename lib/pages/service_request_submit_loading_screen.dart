import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service_modal.dart';
import '../providers/submit_page_provider.dart';

class ServiceRequestSubmitLoadingScreen extends StatefulWidget {
  const ServiceRequestSubmitLoadingScreen({Key? key, required this.service})
      : super(key: key);
  final Service service;
  @override
  State<ServiceRequestSubmitLoadingScreen> createState() =>
      _ServiceRequestSubmitLoadingScreenState();
}

class _ServiceRequestSubmitLoadingScreenState
    extends State<ServiceRequestSubmitLoadingScreen> {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> submitRequest(SubmitPageProvider manager) async {
    print('----------Starting submit');
    DocumentReference<Map<String, dynamic>>
        serviceRequestCollectionDocumentReference =
        FirebaseFirestore.instance.collection('serviceRequests').doc();
    DocumentReference<Map<String, dynamic>>
        userServiceRequestsCollectionDocumentReference = FirebaseFirestore
            .instance
            .collection('customers')
            .doc(widget.service.consumerID)
            .collection('serviceRequests')
            .doc();

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(serviceRequestCollectionDocumentReference, {
        'serviceRequestsCollectionDocumentId':
            serviceRequestCollectionDocumentReference.id,
        'requestedItems': widget.service.items,
        'accepted': widget.service.accepted,
        'createdOn': widget.service.createdON,
        'receiveDateTime': widget.service.recieveDateTime,
        'receiveCoordinates': widget.service.recieveCoordinates,
        'consumerID': widget.service.consumerID,
        'consumerEmail': widget.service.consumerEmail,
        'consumerPhone': widget.service.consumerPhone,
        'consumerName': widget.service.consumerName,
        'serviceCategory': widget.service.serviceCategory.index,
        'consumerRequestId': userServiceRequestsCollectionDocumentReference.id
      });

      print('In transaction ---starting other');
      transaction.set(userServiceRequestsCollectionDocumentReference, {
        'serviceRequestCollectionDocumentId':
            serviceRequestCollectionDocumentReference.id,
        'requestedItems': widget.service.items,
        'accepted': widget.service.accepted,
        'createdOn': widget.service.createdON,
        'receiveDateTime': widget.service.recieveDateTime,
        'receiveCoordinates': widget.service.recieveCoordinates,
        'consumerID': widget.service.consumerID,
        'consumerEmail': widget.service.consumerEmail,
        'consumerPhone': widget.service.consumerPhone,
        'consumerName': widget.service.consumerName,
        'serviceCategory': widget.service.serviceCategory.name,
        'consumerRequestId': userServiceRequestsCollectionDocumentReference.id
      });
    }).then((value) {
      print('In then of transaction -----------------------');
      manager.deleteAll();
      manager.removeAllTypeFoodControllerFromControllerList();
      manager.removeAllQuantityControllerFromControllerList();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            'Congrats!! Your request has been successfully submitted.'),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      Navigator.pushReplacementNamed(context, '/hello');
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was some error in submitting your request'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<SubmitPageProvider>(context, listen: false);
    submitRequest(manager);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(),
            ),
            InkWell(
              child: const Text('Cancel'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                      'There was some error in submitting your request'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
                Navigator.popUntil(context, ModalRoute.withName('/category'));
              },
            )
          ],
        ),
      ),
    );
  }
}
