import 'package:fairywala/Widgets/user_location.dart';
import 'package:fairywala/pages/maps_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

// getting user's location
  void getlocation() async {
    UserLocation location = UserLocation();
    list = await location.getUserLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const sellers = [
      {
        'heading': 'Vegetable Sellers',
        'types': ['Carrot', 'Brinjal', 'Lady finger', 'Cauliflower'],
      },
      {
        'heading': 'Fruit Sellers',
        'types': ['Mango', 'Apple', 'Banana', 'Guava'],
      },
      {
        'heading': 'Other Sellers',
        'types': ['Ice Cream', 'Clothes', 'Utensils'],
      },
      {
        'heading': 'Repairs',
        'types': ['Shoe', 'Chain', 'Electronic Items'],
      },
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("SlidingUpPanelExample"),
        ),
        body: Stack(
          children: <Widget>[
            list.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : MapsPage(list: list),
            SlidingUpPanel(
              defaultPanelState: PanelState.OPEN,
              panel: const Center(
                child: Text("This is the sliding Widget"),
              ),
            )
          ],
        ));
  }
}
