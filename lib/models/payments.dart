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
    this.amount = snapshot.get('valor');
    this.idProvider = snapshot.get('fornecedor');
    this.idPeople = snapshot.get('pessoa');
    this.description = snapshot.get('descricao');
    this.type = snapshot.get('tipo');
    this.filial = snapshot.get('filial');
    this.providerName = snapshot.get('nomefornecedor');
    this.imageReceipt = snapshot.get('comprovante');
    this.createdAt = snapshot.get('datasolicitacao') == null
        ? null
        : snapshot.get('datasolicitacao').toDate();
    this.actionDate = snapshot.get('dataacao') == null
        ? null
        : snapshot.get('dataacao').toDate();
    this.receiptDate = snapshot.get('datacomprovante') == null
        ? null
        : snapshot.get('datacomprovante').toDate();
    this.status = snapshot.get('status');
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
