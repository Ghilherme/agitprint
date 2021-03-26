import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

const String mainTitleApp = 'Agit Print';

const String urlAvatarInitials =
    'https://ui-avatars.com/api/?background=random&name=';
const defaultPadding = 20.0;

const defaultPaddingListView = 5.0;
const textLightColor = Color(0xFFACACAC);

List<MultiSelectItem> profiles = [
  const MultiSelectItem('admin', 'admin'),
  const MultiSelectItem('admin2', 'admin2')
];
const List<String> paymentType = const [
  'Compras',
  'Ação',
];

DocumentReference fazerLogar =
    FirebaseFirestore.instance.doc('/pessoas/SXeqcWVuTpMbQspsgGFG');
