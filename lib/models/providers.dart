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
    this.name = snapshot.data()['nome'];
    this.cpf = snapshot.data()['cpf'];
    this.cnpj = snapshot.data()['cnpj'];
    this.directorship = snapshot.data()['diretoria'];
    this.categories = snapshot.data()['categorias'];
    this.banks = getAccounts(snapshot.data()['contas']);

    this.lastModification = snapshot.data()['atualizacao'] == null
        ? null
        : snapshot.data()['atualizacao'].toDate();
    this.createdAt = snapshot.data()['criacao'] == null
        ? null
        : snapshot.data()['criacao'].toDate();
    this.status = snapshot.data()['status'];
  }

  ProvidersModel.empty() {
    this.id = '';
    this.name = '';
    this.cpf = '';
    this.cnpj = '';
    this.directorship = '';
    this.categories = [''];
    this.banks = [BankAccountModel.empty()];
    this.lastModification = null;
    this.createdAt = null;
    this.status = '';
  }

  List<BankAccountModel> getAccounts(Map<String, dynamic> data) {
    List<BankAccountModel> banks = [];
    data.forEach((key, value) {
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
