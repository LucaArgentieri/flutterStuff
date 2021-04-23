import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToDo> listaTodo = [];
  String inputValue;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    recoverData();
  }

  saveData() async {
    List<Map<String, dynamic>> listTodoAsMap =
        listaTodo.map((toDo) => toDo.toMap()).toList();

    List<String> listTodoAsString =
        listTodoAsMap.map((toDoMap) => json.encode(toDoMap)).toList();

    await sharedPreferences.setStringList('myKey', listTodoAsString);
  }

  recoverData() {
    List<String> listTodoAsString =
        sharedPreferences.getStringList('myKey') ?? [];

    List<dynamic> listTodoAsMap =
        listTodoAsString.map((toDoString) => json.decode(toDoString)).toList();

    setState(() {
      listaTodo =
          listTodoAsMap.map((toDoMap) => ToDo.fromMap(toDoMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  inputValue = value;
                },
                decoration: InputDecoration(
                    hintText: 'Aggiungi nuovo elemento alla lista...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        ToDo pressedBtnValue = ToDo(text: inputValue);
                        setState(() {
                          listaTodo.add(pressedBtnValue);
                        });
                        await saveData();
                      },
                    )),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listaTodo.length,
                  itemBuilder: (context, index) {
                    ToDo currentElement = listaTodo.elementAt(index);
                    return ListTile(
                      title: Text(
                        currentElement.text ?? 'null',
                        style: TextStyle(
                            decoration: currentElement.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('Sei sicuro?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('Si'),
                                      ),
                                    ]);
                              });

                          if (result) {
                            setState(() {
                              listaTodo.removeAt(index);
                            });
                          }
                          await saveData();
                        },
                      ),
                      leading: Checkbox(
                        value: currentElement.isDone,
                        onChanged: (newvalue) async {
                          setState(
                            () {
                              currentElement.isDone = newvalue;
                            },
                          );
                          await saveData();
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
