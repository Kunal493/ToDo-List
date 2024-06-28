import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/todo.dart';
import 'providers/todo_provider.dart';
import 'package:intl/intl.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  EditTodoScreen({required this.todo});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.todo.name);
  late final _priorityController = TextEditingController(
    text: widget.todo.priority?.toString(),
  );
  late final _descriptionController = TextEditingController(
    text: widget.todo.description,
  );
  DateTime? _remindingDate;
  TimeOfDay? _remindingTime;

  @override
  void initState() {
    super.initState();
    if (widget.todo.remindingTime != null) {
      _remindingDate = widget.todo.remindingTime;
      _remindingTime = TimeOfDay.fromDateTime(widget.todo.remindingTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo', style: TextStyle(color: Colors.white)),
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
                    initialDate: _remindingDate ?? DateTime.now(),
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
                    initialTime: _remindingTime ?? TimeOfDay.now(),
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
                    final newTodo = Todo(
                      id: widget.todo.id,
                      name: _nameController.text,
                      priority: int.tryParse(_priorityController.text),
                      remindingTime: remindingDateTime,
                      description: _descriptionController.text,
                    );
                    Provider.of<TodoProvider>(context, listen: false)
                        .editTodo(newTodo);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
