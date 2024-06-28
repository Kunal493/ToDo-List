import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/todo.dart';
import 'providers/todo_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class InsertTodoScreen extends StatefulWidget {
  @override
  _InsertTodoScreenState createState() => _InsertTodoScreenState();
}

class _InsertTodoScreenState extends State<InsertTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priorityController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _remindingDate;
  TimeOfDay? _remindingTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter priority';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Priority must be a number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_remindingDate == null
                    ? 'Select Date'
                    : DateFormat.yMd().format(_remindingDate!)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _remindingDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(_remindingTime == null
                    ? 'Select Time'
                    : _remindingTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _remindingTime = pickedTime;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DateTime? remindingDateTime;
                    if (_remindingDate != null && _remindingTime != null) {
                      remindingDateTime = DateTime(
                        _remindingDate!.year,
                        _remindingDate!.month,
                        _remindingDate!.day,
                        _remindingTime!.hour,
                        _remindingTime!.minute,
                      );
                    }
                    final todo = Todo(
                      id: Uuid().v4(),
                      name: _nameController.text,
                      priority: int.parse(_priorityController.text),
                      remindingTime: remindingDateTime,
                      description: _descriptionController.text,
                    );
                    Provider.of<TodoProvider>(context, listen: false).addTodo(todo);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
