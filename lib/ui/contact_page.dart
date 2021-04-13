import 'package:flutter/material.dart';
import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact selectedContact;

  ContactPage({this.selectedContact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _contact;
  bool _hasChanges = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.selectedContact == null) {
      _contact = Contact();
      return;
    }

    _contact = Contact.toObject(widget.selectedContact.toMap());
    _nameController.text = _contact.name;
    _emailController.text = _contact.email;
    _phoneController.text = _contact.phone;
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
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  image: _contact.image != null
                      ? DecorationImage(image: FileImage(File(_contact.image)))
                      : null,
                ),
                child: Center(
                  child: _contact.name != null && _contact.name.isNotEmpty
                      ? Text(
                          _contact.name.toUpperCase().substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontWeight: FontWeight.w100,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 100,
                        ),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value) {
                  _hasChanges = true;
                  setState(() {
                    _contact.name = value;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _hasChanges = true;
                  _contact.email = value;
                },
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _hasChanges = true;
                  _contact.phone = value;
                },
              )
            ],
          )),
    );
  }
}