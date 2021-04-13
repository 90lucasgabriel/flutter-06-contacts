import 'package:flutter/material.dart';
import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper contactHelper = ContactHelper();
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();

    contactHelper.query().then((list) => setState(() {
          contactList = list;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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

  Widget _contactCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {},
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
                  child: Text(
                    contactList[index].name.toUpperCase().substring(0, 1),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w100,
                    ),
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
}
