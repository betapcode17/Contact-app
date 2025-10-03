import 'package:contact_app/db/contactDatabaseHelper.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/pages/contact_form_page.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  Future<List<Contact>> contacts = Future.value([]);
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  Future<void> refreshContacts() async {
    final data = await ContactDatabaseHelper.instance.getAllContacts();
    setState(() {
      _allContacts = data;
      _filteredContacts = data;
      contacts = Future.value(data);
    });
  }

  void _filterContacts(String query) {
    final filtered = _allContacts.where((contact) {
      final nameLower = contact.name.toLowerCase();
      final phoneLower = contact.phone.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredContacts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Danh bạ"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: "Tìm kiếm liên hệ...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: contacts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Không có liên hệ nào"));
                } else {
                  return ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading:
                              contact.avatar != null &&
                                  contact.avatar!.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    contact.avatar!,
                                  ),
                                )
                              : const CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(contact.phone),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          // Chuyển sang trang thêm liên hệ
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactFormPage()),
          );
          // Sau khi quay lại thì refresh lại danh bạ
          refreshContacts();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
