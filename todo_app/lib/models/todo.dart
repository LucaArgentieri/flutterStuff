class ToDo {
  String text;
  bool isDone;

  ToDo({this.text, this.isDone = false});

  static List<ToDo> todoGenerator() {
    List<ToDo> todoList = [];

    todoList.add(ToDo(text: 'Ciao'));
    todoList.add(ToDo(text: 'Ciao sono ancora io'));
    todoList.add(ToDo(text: 'Ciao ancora'));

    return todoList;
  }
}
