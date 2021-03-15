import 'package:agitprint/registers/people/list_people_admin.dart';
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
            leading: Icon(Icons.favorite),
            title: Text('Fornecedores'),
            subtitle: Text('Gerenciar fornecedores'),
            onTap: () {}),
        ListTile(
          leading: Icon(Icons.save),
          title: Text('Pessoas'),
          subtitle: Text('Gerenciar pessoas'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListPeopleAdmin()));
          },
        ),
        ListTile(
          leading: Icon(Icons.login),
          title: Text('Acessos'),
          subtitle: Text('Gerenciar perfis de acesso'),
          onTap: () {},
        )
      ],
    ));
  }
}
