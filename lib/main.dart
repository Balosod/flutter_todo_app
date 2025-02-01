import 'package:flutter/material.dart';
import 'components/add_todo.dart';
import 'components/todos.dart';
import 'components/home.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

// State management setup
final ValueNotifier<List<Todo>> todosNotifier = ValueNotifier([]);
int _nextId = 1;

// Define Todo class
class Todo {
  final int id;
  final String title;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  // Add copyWith for immutability
  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

// Define the router with ShellRoute for shared layout
final GoRouter _router = GoRouter(
  initialLocation: '/home', // Default page
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: '/todos',
          builder: (context, state) => const Todos(),
        ),
        GoRoute(
          path: '/add_todo',
          builder: (context, state) => AddTodo(
            onAdd: (title) {
              todosNotifier.value = [
                ...todosNotifier.value,
                Todo(id: _nextId, title: title)
              ];
              _nextId++;
            },
          ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router, // Use go_router for navigation
    );
  }
}

class Layout extends StatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text("TODO"),
        centerTitle: true,
        elevation: 5,
        toolbarOpacity: 0.8,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            // title: Text('Close'),
            trailing: Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Todos'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              context.go('/todos');
            },
          ),
          ListTile(
            title: Text('Add Todo'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              context.go('/add_todo');
            },
          ),
        ],
      )),
      body: widget.child, // The current screen's content

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Change this to any color you like
        selectedItemColor:
            Colors.deepPurple, // Color for the selected icon and label
        unselectedItemColor:
            Colors.grey, // Color for unselected icons and labels
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/todos');
          if (index == 2) context.go('/add_todo');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Todo',
          ),
        ],
      ),
    );
  }

  // Get the current selected index for BottomNavigationBar
  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/home') return 0;
    if (location == '/todos') return 1;
    if (location == '/add_todo') return 2;
    return 0;
  }
}
