import 'package:agitprint/constants.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sets {
  static Future<dynamic> setBalanceTransaction(
      PaymentsModel _paymentModel, bool isPendingPayment) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      //Referencia pagamento
      DocumentReference payment = FirebaseFirestore.instance
          .collection('pagamentos')
          .doc(_paymentModel.id);

      //Insere pagamento
      transaction.set(payment, {
        'valor': _paymentModel.amount,
        'fornecedor': _paymentModel.idProvider,
        'pessoa': _paymentModel.idPeople,
        'descricao': _paymentModel.description,
        'tipo': _paymentModel.type,
        'filial': _paymentModel.filial,
        'nomefornecedor': _paymentModel.providerName,
        'comprovante': _paymentModel.imageReceipt,
        'datacomprovante': _paymentModel.receiptDate,
        'datasolicitacao': _paymentModel.createdAt,
        'dataacao': _paymentModel.actionDate,
        'status': _paymentModel.status,
      });

      //Referencia coleção pessoas
      DocumentReference ref = FirebaseFirestore.instance
          .collection('pessoas')
          .doc(_paymentModel.idPeople.id);

      //Get data coleção pessoas
      PeopleModel people = PeopleModel.fromFirestore(await ref.get());

      //atualiza saldo da pessoa, pagamentos pendentes e totais
      num balance = people.balance + _paymentModel.amount;
      num pendingPayment = isPendingPayment
          ? people.pendingPayments + 1
          : people.pendingPayments;

      transaction.update(
          ref, {'saldo': balance, 'pagamentospendentes': pendingPayment});
    });
  }
}
