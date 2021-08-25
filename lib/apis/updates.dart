import 'package:agitprint/models/payments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Updates {
  static Future<dynamic> attachReceiptTransaction(
      PaymentsModel _paymentModel, num pendingPaymentQuantityAdd) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      //Referencia pagamento
      DocumentReference paymentDB = FirebaseFirestore.instance
          .collection('pagamentos')
          .doc(_paymentModel.id);

      //Atualiza comprovante em pagamentos
      transaction.update(paymentDB, {
        'comprovante': _paymentModel.imageReceipt,
        'datacomprovante': _paymentModel.receiptDate,
        'status': _paymentModel.status,
      });

      //Referencia coleção pessoas
      DocumentReference ref = FirebaseFirestore.instance
          .collection('pessoas')
          .doc(_paymentModel.idPeople.id);

      //Get data coleção pessoas
      DocumentSnapshot people = await ref.get();

      //atualiza pagamentos pendentes
      num _pendingPayment =
          pendingPaymentQuantityAdd + people.get('pagamentospendentes');
      transaction.update(ref, {'pagamentospendentes': _pendingPayment});
    });
  }
}
