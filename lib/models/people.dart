import 'package:agitprint/constants.dart';
import 'package:agitprint/models/budget_period.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleModel {
  PeopleModel(
      {this.name,
      this.email,
      this.balance,
      this.profiles,
      this.directorship,
      this.regionalGroup,
      this.pendingPayments,
      this.imageAvatar,
      this.createdAt,
      this.lastModification,
      this.budgetPeriod,
      this.status});
  String id, name, email, directorship, regionalGroup, imageAvatar, status;
  num balance;
  List<dynamic> profiles;
  int pendingPayments;
  List<BudgetPeriodModel> budgetPeriod;

  DateTime lastModification, createdAt;

  PeopleModel.fromPeople(PeopleModel people) {
    this.id = people.id;
    this.name = people.name;
    this.email = people.email;
    this.balance = people.balance;
    this.profiles = people.profiles;
    this.directorship = people.directorship;
    this.regionalGroup = people.regionalGroup;
    this.pendingPayments = people.pendingPayments;
    this.imageAvatar = people.imageAvatar;
    this.lastModification = people.lastModification;
    this.createdAt = people.createdAt;
    this.budgetPeriod = people.budgetPeriod;
    this.status = people.status;
  }
  PeopleModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.get('nome');
    this.email = snapshot.get('email');
    this.balance = snapshot.get('saldo');
    this.profiles = snapshot.get('perfil');
    this.directorship = snapshot.get('diretoria');
    this.regionalGroup = snapshot.get('regional');
    this.pendingPayments = snapshot.get('pagamentospendentes');
    this.imageAvatar = snapshot.get('avatar');
    this.lastModification = snapshot.get('atualizacao') == null
        ? null
        : snapshot.get('atualizacao').toDate();
    this.createdAt = snapshot.get('criacao') == null
        ? null
        : snapshot.get('criacao').toDate();
    this.budgetPeriod = getBudgetPeriod(snapshot.get('orcamentoperiodo'));
    this.status = snapshot.get('status');
  }
  PeopleModel.fromFirestoreDocument(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.get('nome');
    this.email = snapshot.get('email');
    this.balance = snapshot.get('saldo');
    this.profiles = snapshot.get('perfil');
    this.directorship = snapshot.get('diretoria');
    this.regionalGroup = snapshot.get('regional');
    this.pendingPayments = snapshot.get('pagamentospendentes');
    this.imageAvatar = snapshot.get('avatar');
    this.lastModification = snapshot.get('atualizacao') == null
        ? null
        : snapshot.get('atualizacao').toDate();
    this.createdAt = snapshot.get('criacao') == null
        ? null
        : snapshot.get('criacao').toDate();
    this.budgetPeriod = getBudgetPeriod(snapshot.get('orcamentoperiodo'));
    this.status = snapshot.get('status');
  }

  PeopleModel.empty() {
    this.name = '';
    this.email = '';
    this.balance = 0.0;
    this.profiles = [];
    this.directorship = '';
    this.regionalGroup = '';
    this.pendingPayments = 0;
    this.imageAvatar = '';
    this.lastModification = null;
    this.createdAt = null;
    this.budgetPeriod = [
      BudgetPeriodModel(
          period: currentPeriod,
          totalActions: 0,
          totalEarns: 0,
          totalPurchases: 0,
          totalWastes: 0)
    ];
    this.status = '';
  }

  List<BudgetPeriodModel> getBudgetPeriod(List<dynamic> data) {
    List<BudgetPeriodModel> budgets = [];
    data.forEach((value) {
      budgets.add(BudgetPeriodModel(
          period: value['periodo'],
          totalWastes: value['totalgastos'],
          totalActions: value['totalacoes'],
          totalPurchases: value['totalcompras'],
          totalEarns: value['totalganhos']));
    });
    return budgets;
  }
}
