import 'package:flutter/material.dart';
import 'package:contacts/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper contactHelper = ContactHelper();

  @override
  void initState() {
    super.initState();

    // Contact contact = Contact();
    // contact.name = 'Lucas Gabriel';
    // contact.email = '90lucasgabriel@gmail.com';
    // contact.phone = '119289329';
    // contact.image = 'imagePath';

    // contactHelper.create(contact);

    contactHelper.query().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
