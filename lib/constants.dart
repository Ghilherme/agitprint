import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

const String mainTitleApp = 'Agit Print';

const String urlAvatarInitials =
    'https://ui-avatars.com/api/?background=random&name=';
const defaultPadding = 20.0;

const defaultPaddingListView = 5.0;
const textLightColor = Color(0xFFACACAC);

List<String> months = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro'
];

List<MultiSelectItem> allAcess = [
  const MultiSelectItem('admin0', 'Gerenciar acessos'),
  const MultiSelectItem('admin1', 'Creditar saldo'),
  const MultiSelectItem('admin2', 'Debitar saldo'),
  const MultiSelectItem('admin3', 'Visualizar lista pessoas'),
  const MultiSelectItem('admin4', 'Gerenciar pessoas'),
  const MultiSelectItem('admin5', 'Gerenciar diretorias'),
  const MultiSelectItem('user0', 'Solicitar pagamento'),
  const MultiSelectItem('user1', 'Gerenciar fornecedores'),
  const MultiSelectItem('user2', 'Gerenciar categorias'),
  const MultiSelectItem('user3', 'Adicionar comprovantes anexo'),
];
List<MultiSelectItem> directorshipAcess = [
  const MultiSelectItem('admin3', 'Visualizar lista pessoas'),
  const MultiSelectItem('admin4', 'Gerenciar pessoas'),
  const MultiSelectItem('user0', 'Solicitar pagamento'),
  const MultiSelectItem('user1', 'Gerenciar fornecedores'),
  const MultiSelectItem('user2', 'Gerenciar categorias'),
  const MultiSelectItem('user3', 'Adicionar comprovantes anexo'),
];
const List<String> paymentType = const [
  'Compras',
  'Ação',
];

String currentPeriod = DateTime.now().month.toString().padLeft(2, '0') +
    '/' +
    DateTime.now().year.toString();
DocumentReference idPeopleLogged;
PeopleModel currentPeopleLogged = PeopleModel.empty();
