class ToDo {
  String text;
  bool isDone;

  ToDo({this.text, this.isDone = false});

  static List<ToDo> todoGenerator() {
    List<ToDo> todoList = [];

    final todos = [];
    for (var i = 0; i <= 5; i++) {
      todos.add(
        ToDo(text: 'ToDo ${i + 1}'),
      );
    }

    return todoList;
  }

  Map<String, dynamic> toMap() {
    return {'text': this.text, 'isDone': this.isDone};
  }

  ToDo.fromMap(Map<String, dynamic> map)
      : this.text = map['text'],
        this.isDone = map['isDone'];
}
