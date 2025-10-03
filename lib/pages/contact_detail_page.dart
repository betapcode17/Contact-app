import 'package:contact_app/models/contact.dart';
import 'package:contact_app/pages/contact_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/db/contactDatabaseHelper.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;
  const ContactDetailPage({super.key, required this.contact});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  void _loadContact() async {
    final updatedContact = await ContactDatabaseHelper.instance.getContactById(
      widget.contact.id!,
    );
    setState(() {
      widget.contact.name = updatedContact!.name;
      widget.contact.phone = updatedContact.phone;
      widget.contact.email = updatedContact.email;
      widget.contact.avatar = updatedContact.avatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header màu xanh
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row icon phía trên cùng bên phải
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.star_border, color: Colors.white),
                      onPressed: () {
                        // TODO: thêm chức năng đánh dấu yêu thích
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        // Chuyển sang trang Edit và chờ kết quả
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactEditPage(contact: widget.contact),
                          ),
                        );
                        if (result == true) {
                          // Nếu contact được cập nhật, refresh lại trang
                          _loadContact();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        // TODO: thêm menu khác
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        widget.contact.avatar != null &&
                            widget.contact.avatar!.isNotEmpty
                        ? NetworkImage(widget.contact.avatar!)
                        : null,
                    child:
                        widget.contact.avatar == null ||
                            widget.contact.avatar!.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                // Tên liên hệ
                Center(
                  child: Text(
                    widget.contact.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Số điện thoại + icon gọi và nhắn tin
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: Text(widget.contact.phone),
              subtitle: const Text("Mobile"),
              trailing: IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () {
                  // TODO: thêm chức năng nhắn tin
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Email
          if (widget.contact.email.isNotEmpty)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: Text(widget.contact.email),
                subtitle: const Text("Email"),
                trailing: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    // TODO: thêm chức năng gửi email
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
