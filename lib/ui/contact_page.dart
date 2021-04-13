import 'package:flutter/material.dart';
import 'package:contacts/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact selectedContact;

  ContactPage({this.selectedContact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _contact;

  @override
  void initState() {
    super.initState();

    if (widget.selectedContact == null) {
      _contact = Contact();
      return;
    }

    _contact = Contact.toObject(widget.selectedContact.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_contact.name ?? 'New Contact'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }
}
