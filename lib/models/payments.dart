import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentsModel {
  PaymentsModel(
      {this.amount,
      this.idProvider,
      this.idPeople,
      this.description,
      this.type,
      this.filial,
      this.providerName,
      this.imageReceipt,
      this.createdAt,
      this.actionDate,
      this.status});
  String id, description, type, filial, imageReceipt, status, providerName;
  num amount;
  DocumentReference idProvider, idPeople;

  DateTime actionDate, createdAt, receiptDate;

  PaymentsModel.fromPayment(PaymentsModel payment) {
    this.id = payment.id;
    this.amount = payment.amount;
    this.idProvider = payment.idProvider;
    this.idPeople = payment.idPeople;
    this.description = payment.description;
    this.type = payment.type;
    this.filial = payment.filial;
    this.providerName = payment.providerName;
    this.imageReceipt = payment.imageReceipt;
    this.createdAt = payment.createdAt;
    this.actionDate = payment.actionDate;
    this.receiptDate = payment.receiptDate;
    this.status = payment.status;
  }
  PaymentsModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.amount = snapshot.data()['valor'];
    this.idProvider = snapshot.data()['fornecedor'];
    this.idPeople = snapshot.data()['pessoa'];
    this.description = snapshot.data()['descricao'];
    this.type = snapshot.data()['tipo'];
    this.filial = snapshot.data()['filial'];
    this.providerName = snapshot.data()['nomefornecedor'];
    this.imageReceipt = snapshot.data()['comprovante'];
    this.createdAt = snapshot.data()['datasolicitacao'] == null
        ? null
        : snapshot.data()['datasolicitacao'].toDate();
    this.actionDate = snapshot.data()['dataacao'] == null
        ? null
        : snapshot.data()['dataacao'].toDate();
    this.receiptDate = snapshot.data()['datacomprovante'] == null
        ? null
        : snapshot.data()['datacomprovante'].toDate();
    this.status = snapshot.data()['status'];
  }

  PaymentsModel.empty() {
    this.amount = 0;
    this.description = '';
    this.type = '';
    this.filial = '';
    this.providerName = '';
    this.imageReceipt = '';
    this.createdAt = null;
    this.actionDate = null;
    this.receiptDate = null;
    this.status = '';
  }
}
