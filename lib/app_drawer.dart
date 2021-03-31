import 'package:agitprint/login/login.dart';
import 'package:agitprint/registers/categories/list_categories_admin.dart';
import 'package:agitprint/registers/directorship/list_directorship_admin.dart';
import 'package:agitprint/registers/people/list_people_admin.dart';
import 'package:agitprint/registers/providers/list_providers_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(mainTitleApp),
            accountEmail: Text('email do logado')),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Pessoas'),
          subtitle: Text('Gerenciar pessoas'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListPeopleAdmin()));
          },
        ),
        ListTile(
            leading: Icon(Icons.business),
            title: Text('Diretorias'),
            subtitle: Text('Gerenciar diretorias'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListDirectorshipAdmin()));
            }),
        ListTile(
            leading: Icon(Icons.payments),
            title: Text('Fornecedores'),
            subtitle: Text('Gerenciar fornecedores'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListProvidersAdmin()));
            }),
        ListTile(
            leading: Icon(Icons.category),
            title: Text('Categorias'),
            subtitle: Text('Gerenciar categorias de fornecedores'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListCategoriesAdmin()));
            }),
        ListTile(
          leading: Icon(Icons.no_encryption),
          title: Text('Acessos'),
          subtitle: Text('Gerenciar perfis de acesso'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Sair'),
          subtitle: Text('Logout'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          },
        )
      ],
    ));
  }
}
