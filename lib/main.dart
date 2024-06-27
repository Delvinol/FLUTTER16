// main.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_model.dart';
import 'edit_user_screen.dart';
import 'create_user_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UsersScreen(),
    );
  }
}

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService apiService = ApiService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      List<User> fetchedUsers = await apiService.getUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await apiService.deleteUser(userId);
      setState(() {
        users.removeWhere((user) => user.id == userId);
      });
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> navigateToEditUser(User user) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: user),
      ),
    );

    if (result == true) {
      // Refrescar la lista si se actualizó el usuario
      getUsers();
    }
  }

  Future<void> navigateToCreateUser() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateUserScreen(),
      ),
    );

    if (result == true) {
      // Refrescar la lista si se creó un nuevo usuario
      getUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Age: ${user.age}, Active: ${user.active}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => navigateToEditUser(user),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteUser(user.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToCreateUser,
              child: Text('Create User'),
            ),
          ),
        ],
      ),
    );
  }
}
