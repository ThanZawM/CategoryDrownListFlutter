import 'dart:convert';
import 'package:flutter/material.dart';
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
  List categoryData = List();
  String selectedCategoryId;

  Future<String> category() async {
    var res = await http.get(
        Uri.encodeFull("http://192.168.100.56:8000/api/categories"),
        headers: {"Accept": "application/json"});

    var resBody = json.decode(res.body);

    setState(() {
      categoryData = resBody;
    });
    return "Succes!";
  }

  @override
  void initState() {
    super.initState();
    this.category();
  }

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
                    DropdownButton(
                          items: categoryData.map((item) {
                            return new DropdownMenuItem(
                                child: new Text(
                                  item[
                                      'name'], //Names that the api dropdown contains
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                                value: item['id']
                                    .toString() //Id that has to be passed that the dropdown has.....
                                //e.g   India (Name)    and   its   ID (55fgf5f6frf56f) somethimg like that....
                                );
                          }).toList(),
                          onChanged: (String newVal) {
                            setState(() {
                              selectedCategoryId = newVal;
                              print(selectedCategoryId.toString());
                              print(selectedCategoryId is String);
                              return selectedCategoryId;
                            });
                          },
                          value:
                              selectedCategoryId,
                           //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                        ),
                    RaisedButton(
                      child: Text('Create Data'),
                      onPressed: () {
                        setState(() {
                          _futureAlbum = createAlbum(
                            controllerName.text,
                            controllerItemCode.text,
                            //category id from dropdown list
                            int.parse(selectedCategoryId),
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