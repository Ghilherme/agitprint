import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetPeriodModel {
  BudgetPeriodModel(
      {this.period,
      this.totalWastes,
      this.totalEarns,
      this.totalCategories,
      this.totalActions});
  String period;
  num totalWastes, totalEarns, totalCategories, totalActions;

  BudgetPeriodModel.fromBudgetPeriod(BudgetPeriodModel budget) {
    this.period = budget.period;
    this.totalWastes = budget.totalWastes;
    this.totalEarns = budget.totalEarns;
    this.totalCategories = budget.totalCategories;
    this.totalActions = budget.totalActions;
  }
  BudgetPeriodModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.period = '';
    this.totalWastes = snapshot.data()['totalgastos'];
    this.totalEarns = snapshot.data()['totalganhos'];
    this.totalCategories = snapshot.data()['totalcategorias'];
    this.totalActions = snapshot.data()['totalacoes'];
  }

  BudgetPeriodModel.empty() {
    this.period = '';
    this.totalWastes = 0.0;
    this.totalEarns = 0.0;
    this.totalCategories = 0.0;
    this.totalActions = 0.0;
  }
}
