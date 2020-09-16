import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryIdDropdownList extends StatefulWidget {
  @override
  _CategoryIdDropdownListState createState() => _CategoryIdDropdownListState();
}

class _CategoryIdDropdownListState extends State<CategoryIdDropdownList> {
  List categoryData = List();
  String categoryId;

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
    return Container(
        padding: EdgeInsets.all(15.0), //some padding
        child: Column(
          children: <Widget>[
            DecoratedBox(
                decoration: BoxDecoration(
                    border: new Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  //Why you have used Stack ??????
                  //B'coz it make clickable to whole decorated Box!!!! as you can click anywhere for dropdown !!!
                  child: Stack(
                    children: <Widget>[
//Country Text
                      Text(
                        "Category: ",
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),

//Dropdown that has no loine beneath

                      DropdownButtonHideUnderline(
                        child:
//starting the dropdown
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
                              categoryId = newVal;
                              print(categoryId.toString());
                              print(categoryId is String);
                              return categoryId;
                            });
                          },
                          value:
                              categoryId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
