import 'package:flutter/material.dart';
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
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          return Text('Name:');
        },
      ),
    );
  }
}
