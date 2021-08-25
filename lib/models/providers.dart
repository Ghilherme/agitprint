import 'package:agitprint/models/bank_accounts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProvidersModel {
  ProvidersModel(
      {this.id,
      this.name,
      this.cpf,
      this.cnpj,
      this.directorship,
      this.categories,
      this.lastModification,
      this.createdAt,
      this.status});
  String id, name, cpf, cnpj, directorship, status;
  List<dynamic> categories;
  DateTime lastModification, createdAt;
  List<BankAccountModel> banks;

  ProvidersModel.fromProviders(ProvidersModel providers) {
    this.id = providers.id;
    this.name = providers.name;
    this.cpf = providers.cpf;
    this.cnpj = providers.cnpj;
    this.directorship = providers.directorship;
    this.categories = providers.categories;
    this.banks = providers.banks;
    this.lastModification = providers.lastModification;
    this.createdAt = providers.createdAt;
    this.status = providers.status;
  }

  ProvidersModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.get('nome');
    this.cpf = snapshot.get('cpf');
    this.cnpj = snapshot.get('cnpj');
    this.directorship = snapshot.get('diretoria');
    this.categories = snapshot.get('categorias');
    this.banks = getAccounts(snapshot.get('contas'));
    this.lastModification = snapshot.get('atualizacao') == null
        ? null
        : snapshot.get('atualizacao').toDate();
    this.createdAt = snapshot.get('criacao') == null
        ? null
        : snapshot.get('criacao').toDate();
    this.status = snapshot.get('status');
  }

  ProvidersModel.fromFirestoreDocument(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.get('nome');
    this.cpf = snapshot.get('cpf');
    this.cnpj = snapshot.get('cnpj');
    this.directorship = snapshot.get('diretoria');
    this.categories = snapshot.get('categorias');
    this.banks = getAccounts(snapshot.get('contas'));
    this.lastModification = snapshot.get('atualizacao') == null
        ? null
        : snapshot.get('atualizacao').toDate();
    this.createdAt = snapshot.get('criacao') == null
        ? null
        : snapshot.get('criacao').toDate();
    this.status = snapshot.get('status');
  }

  ProvidersModel.empty() {
    this.name = '';
    this.cpf = '';
    this.cnpj = '';
    this.directorship = '';
    this.categories = [];
    this.banks = [BankAccountModel.empty()];
    this.lastModification = null;
    this.createdAt = null;
    this.status = '';
  }

  List<BankAccountModel> getAccounts(List<dynamic> data) {
    List<BankAccountModel> banks = [];
    data.forEach((value) {
      banks.add(new BankAccountModel(
          bankCod: value['codbanco'],
          bank: value['banco'],
          agency: value['agencia'],
          account: value['conta'],
          savingAccount: value['contapoupanca'],
          pix: Map<String, dynamic>.from(value['pix'])));
    });
    return banks;
  }
}
