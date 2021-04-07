class BankModel {
  BankModel(this.bankCod, this.name);
  String bankCod, name;

  BankModel.fromBanks(BankModel bank) {
    this.bankCod = bank.bankCod;
    this.name = bank.name;
  }
}
