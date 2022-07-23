import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../widgets/button.dart';
import '../widgets/category_field.dart';
import '../models/category_field_modal.dart';
import '../providers/submit_page_provider.dart';
import 'user_info.dart';

class ScheduleRequest extends StatefulWidget {
  const ScheduleRequest({Key? key}) : super(key: key);

  @override
  _ScheduleRequestState createState() => _ScheduleRequestState();
}

class _ScheduleRequestState extends State<ScheduleRequest> {
  final List<String> foodTypes = const [
    'Fruits/Vegetables',
    'Icecream',
    'Folding Niwar Maker',
    'Gas Stove repair',
  ];

  TextEditingController controller = TextEditingController();
  InkWell buildCategoryOption(String text, TextEditingController controller) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        setState(() => controller.text = 'Fruits/Vegetables');
        // controller.text = item['foodType'];
        Navigator.pop(context);
      },
      child: Ink(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: primaryColor.withOpacity(0.2),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void showModal(BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 180,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14.0,
                    runSpacing: 14.0,
                    children: [
                      buildCategoryOption(foodTypes[0], controller),
                      buildCategoryOption(foodTypes[1], controller),
                      buildCategoryOption(foodTypes[2], controller),
                      buildCategoryOption(foodTypes[3], controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget inputField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 1),
          ),
        ],
        color: secondaryColor,
      ),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        style: TextStyle(fontSize: 14),
        onTap: () => showModal(context, controller),
      ),
    );
  }

  // Widget inputField(Map<String,dynamic> item,
  //     TextEditingController controller,SubmitPageProvider manager) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(borderRadius),
  //       boxShadow: [
  //         BoxShadow(
  //           blurRadius: 4,
  //           color: Colors.black.withOpacity(0.3),
  //           offset: Offset(0, 1),
  //         ),
  //       ],
  //       color: secondaryColor,
  //     ),
  //     child: TextFormField(
  //       readOnly: true,
  //       autovalidateMode: AutovalidateMode.always,
  //       validator: (text){
  //         if(text==null || text.isEmpty){
  //           manager.foodControllerIsEmpty = true;
  //         }
  //         else if(text.isNotEmpty){
  //           manager.foodControllerIsEmpty = false;
  //         }
  //       },
  //       cursorColor: Colors.black,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
  //       ),
  //       controller: controller,
  //       style: TextStyle(fontSize: 14),
  //       onTap: () => showModal(context, item, controller),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<SubmitPageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Request'),
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select the type of service",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            inputField(controller),
            // inputField(item, typeFoodController,widget.manager),
            SizedBox(height: 16.0),
            header(),
            SizedBox(height: 8.0),
            Consumer<SubmitPageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return CategoryField(
                  manager: manager,
                  // controllers: _controllers,
                );
              },
            ),
            SizedBox(height: 12.0),
            addFieldBtn(manager),
            SizedBox(height: 10),
            Button("logout", () {
              FirebaseAuth.instance.signOut();
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button('Next', () {
                if (manager.foodControllerIsEmpty &&
                        manager.quantityControllerIsEmpty ||
                    manager.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Add item to request!'),
                    backgroundColor: Theme.of(context).errorColor,
                  ));
                } else if (manager.foodControllerIsEmpty &&
                    !manager.quantityControllerIsEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Specify the type of product'),
                    backgroundColor: Theme.of(context).errorColor,
                  ));
                } else if (!manager.foodControllerIsEmpty &&
                    manager.quantityControllerIsEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Specify the quantity of product'),
                    backgroundColor: Theme.of(context).errorColor,
                  ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSubmitInfo(),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Types of vegetables',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            'Quantity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget addFieldBtn(SubmitPageProvider manager) {
    return TextButton(
      onPressed: () {
        if (manager.foodControllerIsEmpty &&
            manager.quantityControllerIsEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Add item to request!'),
            backgroundColor: Theme.of(context).errorColor,
          ));
        } else if (manager.foodControllerIsEmpty &&
            !manager.quantityControllerIsEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Specify the type of product'),
            backgroundColor: Theme.of(context).errorColor,
          ));
        } else if (!manager.foodControllerIsEmpty &&
            manager.quantityControllerIsEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Specify the quantity of product'),
            backgroundColor: Theme.of(context).errorColor,
          ));
        } else {
          manager.addItem(
            CategoryFieldModal(id: const Uuid().v1()),
          );
          manager
              .addTypeFoodControllerToControllerList(TextEditingController());
          manager
              .addQuantityControllerToControllerList(TextEditingController());

          // _controllers.add(TextEditingController());
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add),
          Text('ADD'),
        ],
      ),
    );
  }
}
