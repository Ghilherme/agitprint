import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetPeriodModel {
  BudgetPeriodModel(
      {this.period,
      this.totalWastes,
      this.totalEarns,
      this.totalPurchases,
      this.totalActions});
  String period;
  num totalWastes, totalEarns, totalPurchases, totalActions;

  BudgetPeriodModel.fromBudgetPeriod(BudgetPeriodModel budget) {
    this.period = budget.period;
    this.totalWastes = budget.totalWastes;
    this.totalEarns = budget.totalEarns;
    this.totalPurchases = budget.totalPurchases;
    this.totalActions = budget.totalActions;
  }
  BudgetPeriodModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.period = '';
    this.totalWastes = snapshot.get('totalgastos');
    this.totalEarns = snapshot.get('totalganhos');
    this.totalPurchases = snapshot.get('totalcompras');
    this.totalActions = snapshot.get('totalacoes');
  }

  BudgetPeriodModel.empty() {
    this.period = '';
    this.totalWastes = 0.0;
    this.totalEarns = 0.0;
    this.totalPurchases = 0.0;
    this.totalActions = 0.0;
  }
}
