import 'package:flutter/material.dart';
import '../models/user.dart';

class UserForm extends StatefulWidget {
  final User? initialData;
  final Function(User) onSubmit;
  final VoidCallback onCancel;

  const UserForm({
    super.key,
    this.initialData,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarAssetController;
  late TextEditingController _departmentController;
  late TextEditingController _locationController;
  late TextEditingController _joinDateController;
  late String _role;
  late bool _isActive;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialData?.name ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialData?.email ?? '',
    );
    _avatarAssetController = TextEditingController(
      text: widget.initialData?.avatarAsset ?? 'assets/ellipse_5.png',
    );
    _departmentController = TextEditingController(
      text: widget.initialData?.department ?? '',
    );
    _locationController = TextEditingController(
      text: widget.initialData?.location ?? '',
    );

    _joinDateController = TextEditingController(
      text:
          widget.initialData?.joinDate != null
              ? widget.initialData!.joinDate.toIso8601String().substring(0, 10)
              : DateTime.now().toIso8601String().substring(0, 10),
    );

    // Additional properties
    _role = widget.initialData?.role ?? 'Viewer';
    _isActive = widget.initialData?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items:
                  ['Admin', 'Editor', 'Viewer'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _role = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _joinDateController,
              decoration: const InputDecoration(
                labelText: 'Join Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _joinDateController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: widget.initialData?.id ?? 0,
        name: _nameController.text,
        email: _emailController.text,
        avatarAsset: _avatarAssetController.text,
        role: _role,
        department: _departmentController.text,
        location: _locationController.text,
        joinDate: DateTime.tryParse(_joinDateController.text) ?? DateTime.now(),
        isActive: _isActive,
      );
      widget.onSubmit(user);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarAssetController.dispose();
    _departmentController.dispose();
    _locationController.dispose();
    _joinDateController.dispose();
    super.dispose();
  }
}
