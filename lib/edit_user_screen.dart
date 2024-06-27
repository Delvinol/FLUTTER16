// edit_user_screen.dart
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'api_service.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final ApiService apiService = ApiService();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController birthdateController;
  late bool active;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    ageController = TextEditingController(text: widget.user.age.toString());
    birthdateController = TextEditingController(text: widget.user.birthdate);
    active = widget.user.active;
    selectedDate = DateTime.tryParse(widget.user.birthdate);
  }

  Future<void> updateUser() async {
    try {
      User updatedUser = User(
        id: widget.user.id,
        name: nameController.text,
        age: int.parse(ageController.text),
        birthdate: selectedDate?.toIso8601String() ?? '',
        active: active,
      );
      await apiService.updateUser(updatedUser);
      Navigator.pop(context, true); // Devuelve true para indicar que se actualizó el usuario
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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
        title: Text('Edit User'),
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
              onPressed: updateUser,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
