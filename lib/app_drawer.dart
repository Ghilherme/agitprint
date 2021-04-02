import 'package:agitprint/login/login.dart';
import 'package:agitprint/registers/categories/list_categories_admin.dart';
import 'package:agitprint/registers/directorship/list_directorship_admin.dart';
import 'package:agitprint/registers/people/list_people_admin.dart';
import 'package:agitprint/registers/providers/list_providers_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
                backgroundImage: currentPeopleLogged.imageAvatar == '' ||
                        currentPeopleLogged.imageAvatar == null
                    ? Image.network(
                            urlAvatarInitials + currentPeopleLogged.name)
                        .image
                    : Image.network(currentPeopleLogged.imageAvatar).image),
            accountName: Text(currentPeopleLogged.name),
            accountEmail: Text(currentPeopleLogged.email)),
        currentPeopleLogged.profiles.contains('admin4')
            ? ListTile(
                leading: Icon(Icons.people),
                title: Text('Pessoas'),
                subtitle: Text('Gerenciar pessoas'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListPeopleAdmin()));
                },
              )
            : Container(),
        currentPeopleLogged.profiles.contains('admin5')
            ? ListTile(
                leading: Icon(Icons.business),
                title: Text('Diretorias'),
                subtitle: Text('Gerenciar diretorias'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListDirectorshipAdmin()));
                })
            : Container(),
        currentPeopleLogged.profiles.contains('user1')
            ? ListTile(
                leading: Icon(Icons.payments),
                title: Text('Fornecedores'),
                subtitle: Text('Gerenciar fornecedores'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListProvidersAdmin()));
                })
            : Container(),
        currentPeopleLogged.profiles.contains('user2')
            ? ListTile(
                leading: Icon(Icons.category),
                title: Text('Categorias'),
                subtitle: Text('Gerenciar categorias de fornecedores'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListCategoriesAdmin()));
                })
            : Container(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Sair'),
          subtitle: Text('Logout'),
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.clear();

            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          },
        )
      ],
    ));
  }
}
