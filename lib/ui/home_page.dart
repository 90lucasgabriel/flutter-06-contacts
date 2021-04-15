import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:contacts/helpers/contact_helper.dart';
import 'package:contacts/ui/contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper contactHelper = ContactHelper();
  List<Contact> contactList = [];

  void _queryContacts() {
    contactHelper.query().then((list) => setState(() {
          contactList = list;
        }));
  }

  void _navigateToContactPage({Contact contact}) async {
    final response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          selectedContact: contact,
        ),
      ),
    );

    if (response == null) {
      return;
    }

    if (contact != null) {
      await contactHelper.update(response);
    } else {
      await contactHelper.create(response);
    }

    _queryContacts();
  }

  @override
  void initState() {
    super.initState();

    _queryContacts();
  }

  void _handleOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (contactList[index].phone != null)
                    TextButton(
                      style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(16))),
                      child: Text(
                        'Call',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () {
                        launch('tel:${contactList[index].phone}');
                        Navigator.pop(context);
                      },
                    ),
                  Divider(height: 0),
                  if (contactList[index].email != null ||
                      contactList[index].email.length > 0)
                    TextButton(
                      style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(16))),
                      child: Text(
                        'Send email',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () {
                        launch('mailto:${contactList[index].email}');
                        Navigator.pop(context);
                      },
                    ),
                  Divider(height: 0),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(16))),
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToContactPage(
                        contact: contactList[index],
                      );
                    },
                  ),
                  Divider(height: 0),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(16))),
                    child: Text(
                      'Remove',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () {
                      contactHelper.delete(contactList[index].id);
                      setState(() {
                        contactList.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        _handleOptions(context, index);
      },
      child: Ink(
        color: Colors.white,
        child: Column(children: [
          Container(
            height: 96,
            padding: EdgeInsets.all(16),
            child: Row(children: [
              Container(
                margin: EdgeInsets.only(right: 16),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  image: contactList[index].image != null
                      ? DecorationImage(
                          image: FileImage(File(contactList[index].image)))
                      : null,
                ),
                child: Center(
                  child: contactList[index].name != null &&
                          contactList[index].name.isNotEmpty
                      ? Text(
                          contactList[index].name.toUpperCase().substring(0, 1),
                          style: TextStyle(
                            color: contactList[index].image != null
                                ? Colors.transparent
                                : Colors.white,
                            fontSize: 32,
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
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contactList[index].name ?? '-',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        contactList[index].email ?? '-',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        contactList[index].phone ?? '-',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ]),
              ),
            ]),
          ),
          Divider(
            height: 0,
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }
}
