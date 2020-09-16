import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:item/category_id_dropdown_list.dart';
import 'package:item/item.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<Item> createAlbum(String name, String itemCode, int categoryId) async {
  //print("Email $email and Password $password");
  final http.Response response = await http.post(
    'http://192.168.100.56:8000/api/items',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'item_code': itemCode,
      'category_id': "$categoryId",
    }),
  );

  if (response.statusCode == 200) {
    print("in success");
    return Item.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerItemCode = TextEditingController();
  final TextEditingController controllerCategoryId = TextEditingController();
  Future<Item> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add Item"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: controllerName,
                      decoration: InputDecoration(hintText: 'Enter Name'),
                    ),
                    TextField(
                      controller: controllerItemCode,
                      decoration: InputDecoration(hintText: 'Enter Item Code'),
                    ),
                    /* TextField(
                      controller: controllerCategoryId,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(hintText: 'Enter Category ID'),
                    ), */
                    CategoryIdDropdownList(),
                    RaisedButton(
                      child: Text('Create Data'),
                      onPressed: () {
                        setState(() {
                          _futureAlbum = createAlbum(
                            controllerName.text,
                            controllerItemCode.text,
                            //category id from dropdown list
                            int.parse(CategoryIdDropdownList().categoryId),
                          );
                        });
                      },
                    ),
                  ],
                )
              : FutureBuilder<Item>(
                  future: _futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.message);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}

