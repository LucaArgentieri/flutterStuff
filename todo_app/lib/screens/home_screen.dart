import 'package:flutter/material.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToDo> listaTodo = ToDo.todoGenerator();
  String inputValue;

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
                      onPressed: () {
                        ToDo pressedBtnValue = ToDo(text: inputValue);
                        setState(() {
                          listaTodo.add(pressedBtnValue);
                        });
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
                        },
                      ),
                      leading: Checkbox(
                        value: currentElement.isDone,
                        onChanged: (newvalue) {
                          setState(
                            () {
                              currentElement.isDone = newvalue;
                            },
                          );
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
