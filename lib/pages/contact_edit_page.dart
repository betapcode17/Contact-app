import 'package:flutter/material.dart';
import 'package:contact_app/db/contactDatabaseHelper.dart';
import 'package:contact_app/models/contact.dart';

class ContactEditPage extends StatefulWidget {
  final Contact contact;
  const ContactEditPage({super.key, required this.contact});

  @override
  State<ContactEditPage> createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);
    _avatarController = TextEditingController(
      text: widget.contact.avatar ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final avatar = _avatarController.text.trim().isEmpty
        ? null
        : _avatarController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ thông tin")),
      );
      return;
    }

    // Cập nhật thông tin contact
    final updatedContact = Contact(
      id: widget.contact.id, // cần giữ id để update
      name: name,
      phone: phone,
      email: email,
      avatar: avatar,
    );

    await ContactDatabaseHelper.instance.updateContact(updatedContact);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit contact"),
        actions: [
          TextButton(
            onPressed: _saveContact,
            child: const Text("SAVE", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _avatarController.text.isNotEmpty
                  ? NetworkImage(_avatarController.text)
                  : null,
              child: _avatarController.text.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _avatarController,
              decoration: const InputDecoration(
                labelText: "Avatar (URL or path)",
                prefixIcon: Icon(Icons.image),
              ),
              onChanged: (_) {
                setState(() {}); // update avatar preview khi thay đổi
              },
            ),
          ],
        ),
      ),
    );
  }
}
