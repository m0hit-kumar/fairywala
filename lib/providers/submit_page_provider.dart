import 'package:flutter/material.dart';

import '../../models/category_field_modal.dart';

class SubmitPageProvider with ChangeNotifier {
  // CategoryFieldModal categoryFieldModal = CategoryFieldModal(id: id)

  final _items = <Map<String,dynamic>>[];
  List<Map<String,dynamic>> get items => List.unmodifiable(_items);

  final List<TextEditingController> _typeFoodControllers = <TextEditingController>[];
  List<TextEditingController> get typeFoodControllers => _typeFoodControllers;

  final List<TextEditingController> _quantityControllers = <TextEditingController>[];
  List<TextEditingController> get quantityControllers => _quantityControllers;

  bool foodControllerIsEmpty = false;
  bool quantityControllerIsEmpty = false;








  void addQuantityControllerToControllerList(TextEditingController textEditingController){
    _quantityControllers.add(textEditingController);
    notifyListeners();
  }

  void removeQuantityControllerFromControllerList(TextEditingController textEditingController){
    _quantityControllers.remove(textEditingController);
    notifyListeners();
  }

  void removeAllQuantityControllerFromControllerList(){
    _quantityControllers.clear();
    notifyListeners();
  }








  void addTypeFoodControllerToControllerList(TextEditingController textEditingController){
    _typeFoodControllers.add(textEditingController);
    notifyListeners();
  }

  void removeTypeFoodControllerFromControllerList(TextEditingController textEditingController){
    _typeFoodControllers.remove(textEditingController);
    notifyListeners();
  }

  void removeAllTypeFoodControllerFromControllerList(){
    _typeFoodControllers.clear();
    notifyListeners();
  }








  void deleteItem(String id) {
    final item = _items.firstWhere((element) => element['id'] == id);
    int index = _items.indexOf(item);
    _items.removeAt(index);
    notifyListeners();
  }

  void deleteAll(){
    _items.clear();
  }

  void addItem(CategoryFieldModal item) {
    _items.add(item.toJson());
    notifyListeners();
  }

}
