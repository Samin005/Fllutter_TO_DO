import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'To-do'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> _todoList = [
    Todo("Title 1", "Description 1"),
    Todo("Title 2", "Description 2")
  ];
  List<Todo> _todoListBackup = [];
  final TextEditingController _titleTextController = TextEditingController();
  bool _titleEmpty = false;
  final TextEditingController _descriptionTextController =
      TextEditingController();

  void _addToList() {
    setState(() {
      _todoList.add(
          Todo(_titleTextController.text, _descriptionTextController.text));
    });
    _titleTextController.clear();
    _descriptionTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_todoList[index].title),
            subtitle: Text(_todoList[index].description),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _todoListBackup = List.from(_todoList);
                  _todoList.removeAt(index);
                });
                final deleteSnackBar = SnackBar(
                  content: Text('Deleted ' + _todoList[index].title + '!'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _todoList = List.from(_todoListBackup);
                      });
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(deleteSnackBar);
              },
            ),
            onLongPress: () {
              final snackBar = SnackBar(
                  content:
                      Text('Long pressed ' + _todoList[index].title + '!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    title: const Text('New to-do'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _titleTextController,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            errorText:
                                _titleEmpty ? 'Title cannot be empty' : null,
                          ),
                        ),
                        TextField(
                          controller: _descriptionTextController,
                          decoration:
                              const InputDecoration(hintText: 'Description'),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              if (_titleTextController.text.isNotEmpty) {
                                _titleEmpty = false;
                                _addToList();
                                Navigator.pop(context, 'OK');
                              } else {
                                _titleEmpty = true;
                              }
                            });
                          },
                          child: const Text('OK')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'))
                    ],
                  ),
                )),
        tooltip: 'Add to-do',
        child: const Icon(Icons.add),
      ),
      bottomSheet: const Text(
          'By Samin Azhan'), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Todo {
  String title;
  String description;

  Todo(this.title, this.description);
}
