import 'dart:async';
import 'dart:convert';
import 'category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Category> createAlbum(String name, String description) async {
  //print("Email $email and Password $password");
  final http.Response response = await http.post(
    'http://192.168.100.56:8000/api/categories',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'description': description,
    }),
  );

  if (response.statusCode == 200) {
    print("in success");
    return Category.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class AddCategory extends StatefulWidget {
  AddCategory({Key key}) : super(key: key);

  @override
  _AddCategoryState createState() {
    return _AddCategoryState();
  }
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  Future<Category> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Category'),
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
                      controller: controllerDescription,
                      decoration: InputDecoration(hintText: 'Enter Description'),
                    ),

                    RaisedButton(
                      child: Text('Create Data'),
                      onPressed: () {
                        setState(() {
                          _futureAlbum = createAlbum(
                              controllerName.text,
                              controllerDescription.text,);
                        });
                      },
                    ),
                  ],
                )
              : FutureBuilder<Category>(
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
