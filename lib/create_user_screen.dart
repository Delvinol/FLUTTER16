// create_user_screen.dart
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'api_service.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final ApiService apiService = ApiService();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  bool active = false;
  DateTime? selectedDate;

  Future<void> createUser() async {
    try {
      User newUser = User(
        id: '', // El servidor asignará un nuevo ID
        name: nameController.text,
        age: int.parse(ageController.text),
        birthdate: selectedDate?.toIso8601String() ?? '',
        active: active,
      );
      await apiService.createUser(newUser);

      // Regresa a la pantalla de listado de usuarios e indica que se ha creado un nuevo usuario
      Navigator.pop(context, true); // Devuelve true para indicar que se creó el usuario
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: birthdateController,
                  decoration: InputDecoration(labelText: 'Birthdate'),
                ),
              ),
            ),
            CheckboxListTile(
              title: Text('Active'),
              value: active,
              onChanged: (value) {
                setState(() {
                  active = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: createUser,
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
