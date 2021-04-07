import 'package:agitprint/constants.dart';
import 'package:agitprint/models/budget_period.dart';
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
      var testre = await ref.get();
      PeopleModel people = PeopleModel.fromFirestoreDocument(testre);

      //atualiza saldo da pessoa, pagamentos pendentes
      num balance = people.balance + _paymentModel.amount;
      num pendingPayment = isPendingPayment
          ? people.pendingPayments + 1
          : people.pendingPayments;

      //atualiza totais
      List<BudgetPeriodModel> _totals = _updateTotals(people, _paymentModel);

      //monta lista de budgets
      List totals = _buildListBudgets(_totals);

      transaction.update(ref, {
        'saldo': balance,
        'pagamentospendentes': pendingPayment,
        'orcamentoperiodo': totals
      });
    });
  }

  static List _buildListBudgets(List<BudgetPeriodModel> _totals) {
    List<dynamic> totals = [];
    _totals.forEach((element) {
      totals.add({
        'periodo': element.period,
        'totalacoes': element.totalActions,
        'totalcompras': element.totalPurchases,
        'totalganhos': element.totalEarns,
        'totalgastos': element.totalWastes,
      });
    });
    return totals;
  }

  static List<BudgetPeriodModel> _updateTotals(
      PeopleModel people, PaymentsModel _paymentModel) {
    var budgetsList = people.budgetPeriod;
    var budgetPeriod =
        budgetsList.where((element) => element.period == currentPeriod);
    BudgetPeriodModel budgets;

    if (budgetPeriod.isEmpty)
      budgets = BudgetPeriodModel.empty();
    else {
      budgets = budgetPeriod.first;
      budgetsList.remove(budgetPeriod.first);
    }

    num amountPositive = _paymentModel.amount.abs();

    num totalPurchases = _paymentModel.type == paymentType[0] //Compras
        ? budgets.totalPurchases + amountPositive
        : budgets.totalPurchases;
    num totalActions = _paymentModel.type == paymentType[1] //Ações
        ? budgets.totalActions + amountPositive
        : budgets.totalActions;
    num totalEarns = budgets.totalEarns, totalWastes = budgets.totalWastes;
    _paymentModel.amount.isNegative
        ? totalWastes += amountPositive
        : totalEarns += amountPositive;

    budgetsList.add(BudgetPeriodModel(
        period: currentPeriod,
        totalActions: totalActions,
        totalEarns: totalEarns,
        totalPurchases: totalPurchases,
        totalWastes: totalWastes));

    return budgetsList;
  }

  static Future<void> setPeople(
      PeopleModel _peopleModel, DocumentReference refDB) {
    List _totals = _buildListBudgets(_peopleModel.budgetPeriod);

    return refDB.set({
      'nome': _peopleModel.name,
      'email': _peopleModel.email,
      'saldo': _peopleModel.balance,
      'perfil': _peopleModel.profiles,
      'diretoria': _peopleModel.directorship,
      'regional': _peopleModel.regionalGroup,
      'pagamentospendentes': _peopleModel.pendingPayments,
      'orcamentoperiodo': _totals,
      'avatar': _peopleModel.imageAvatar,
      'atualizacao': _peopleModel.lastModification,
      'criacao': _peopleModel.createdAt,
      'status': _peopleModel.status,
    });
  }
}
