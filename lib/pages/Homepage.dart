import 'package:fairywala/MapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool panelOpend = true;
  @override
  Widget build(BuildContext context) {
    List<String> items = [
      'Vegitables',
      'icecream',
      'electrcian',
      'Vegitables',
      'icecream',
      'electrcian'
    ];

    return Stack(children: [
      panelOpend
          ? Stack(
              children: [
                Opacity(
                  opacity: 0.90,
                  child: Container(
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Image.asset(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                  color: Colors.blue.withOpacity(1),
                  colorBlendMode: BlendMode.color,
                ),
              ],
            )
          : const MapScreen(),
      SlidingUpPanel(
        onPanelClosed: () {
          setState(() {
            panelOpend = false;
          });

          print(panelOpend);
        },
        onPanelOpened: () {
          setState(() {
            panelOpend = true;
          });
        },
        minHeight: 130.0,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        defaultPanelState: PanelState.OPEN,
        panel: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for items items',
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const Text(
                "Items",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              const CircleAvatar(radius: 30),
                              Text(items[index])
                            ],
                          )),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Vendors",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              Container(
                height: 200,
                child: GridView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              const CircleAvatar(radius: 30),
                              Text(items[index]),
                            ],
                          )),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0),
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
