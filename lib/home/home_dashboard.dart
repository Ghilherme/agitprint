import 'dart:io';

import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/home/body_home_dashboard.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/people.dart';
import 'package:agitprint/payments/payment.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../constants.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class HomeDashboard extends StatefulWidget {
  final PeopleModel people;

  const HomeDashboard({Key key, @required this.people}) : super(key: key);
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: currentPeopleLogged.profiles.contains('admin3')
          ? null
          : CustomDrawer(),
      appBar: AppBar(
        leading: currentPeopleLogged.profiles.contains('admin3')
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        actions: [
          PopupMenuButton<String>(onSelected: (value) {
            _generateExcelFile();
          }, itemBuilder: (BuildContext context) {
            return {'Gerar relatório'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          })
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(mainTitleApp),
      ),
      body: BodyHomeDashboard(
        people: widget.people,
      ),
      floatingActionButton: currentPeopleLogged.profiles.contains('user0')
          ? FloatingActionButton(
              child: const Icon(Icons.attach_money),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Payment()));
              },
            )
          : Container(),
    );
  }

  void _generateExcelFile() async {
    List<PaymentsModel> paymentsList =
        await Gets.getPaymentsByPeople(widget.people.id);
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    _generateExcelHeader(sheetObject);
    for (int row = 1; row < paymentsList.length; row++) {
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = widget.people.name;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = paymentsList[row].providerName;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = paymentsList[row].type;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = paymentsList[row].filial;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = paymentsList[row].description;
      sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
              .value =
          "${paymentsList[row].createdAt.day.toString().padLeft(2, '0')}/${paymentsList[row].createdAt.month.toString().padLeft(2, '0')}/${paymentsList[row].createdAt.year.toString()} ";
      sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
              .value =
          "${paymentsList[row].actionDate.day.toString().padLeft(2, '0')}/${paymentsList[row].actionDate.month.toString().padLeft(2, '0')}/${paymentsList[row].actionDate.year.toString()} ";
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
          .value = paymentsList[row].amount;
    }

    var fileName = widget.people.name + "_Relatorio.xlsx";
    var fileBytes = excel.save(fileName: fileName);

    var directory = await getApplicationDocumentsDirectory();

    File(directory.path + "/output_file_name.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }

  void _generateExcelHeader(Sheet sheetObject) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = 'Pessoa';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = 'Fornecedor';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = 'Tipo';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = 'Filial';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = 'Descrição';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = 'Data solicitação';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
        .value = 'Data Ação';
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
        .value = 'Valor';
  }
}
