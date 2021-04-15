import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  final FocusNode _nameFocus = FocusNode();

  Future<bool> _handlePop() {
    if (_hasChanges) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Discard changes?"),
              content: Text('If you confirm, all changes will be lost.'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });

      return Future.value(false);
    }

    return Future.value(true);
  }

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
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_contact.name ?? 'New Contact'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      image: _contact.image != null
                          ? DecorationImage(
                              image: FileImage(File(_contact.image)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Center(
                      child: _contact.name != null && _contact.name.isNotEmpty
                          ? Text(
                              _contact.name.toUpperCase().substring(0, 1),
                              style: TextStyle(
                                color: _contact.image != null
                                    ? Colors.transparent
                                    : Colors.white,
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
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final response =
                        await _picker.getImage(source: ImageSource.gallery);

                    if (response == null) return;
                    setState(() {
                      _contact.image = response.path;
                    });
                  },
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
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
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            onPressed: () {
              if (_contact.name != null && _contact.name.isNotEmpty) {
                Navigator.pop(context, _contact);
                return;
              }

              FocusScope.of(context).requestFocus(_nameFocus);
            },
          ),
        ),
        onWillPop: _handlePop);
  }
}
