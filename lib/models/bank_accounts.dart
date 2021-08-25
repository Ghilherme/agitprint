import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccountModel {
  BankAccountModel(
      {this.bankCod,
      this.bank,
      this.agency,
      this.account,
      this.savingAccount,
      this.pix});
  String bankCod, bank, agency, account, savingAccount;

  Map<String, dynamic> pix;

  BankAccountModel.fromBankAccount(BankAccountModel bankAccount) {
    this.bankCod = bankAccount.bankCod;
    this.bank = bankAccount.bank;
    this.agency = bankAccount.agency;
    this.account = bankAccount.account;
    this.savingAccount = bankAccount.savingAccount;
    this.pix = bankAccount.pix;
  }

  BankAccountModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.bankCod = snapshot.get('codbanco');
    this.bank = snapshot.get('banco');
    this.agency = snapshot.get('agencia');
    this.account = snapshot.get('conta');
    this.savingAccount = snapshot.get('contapoupanca');
    this.pix = Map<String, dynamic>.from(snapshot.get('pix'));
  }

  BankAccountModel.empty() {
    this.bankCod = '';
    this.bank = '';
    this.agency = '';
    this.account = '';
    this.savingAccount = '';
    this.pix = {'cpf': '', 'cnpj': '', 'telefone': '', 'email': ''};
  }
}
