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
    this.name = snapshot.data()['nome'];
    this.email = snapshot.data()['email'];
    this.balance = snapshot.data()['saldo'];
    this.profiles = snapshot.data()['perfil'];
    this.directorship = snapshot.data()['diretoria'];
    this.regionalGroup = snapshot.data()['regional'];
    this.pendingPayments = snapshot.data()['pagamentospendentes'];
    this.imageAvatar = snapshot.data()['avatar'];
    this.lastModification = snapshot.data()['atualizacao'] == null
        ? null
        : snapshot.data()['atualizacao'].toDate();
    this.createdAt = snapshot.data()['criacao'] == null
        ? null
        : snapshot.data()['criacao'].toDate();
    this.budgetPeriod = getBudgetPeriod(snapshot.data()['orcamentoperiodo']);
    this.status = snapshot.data()['status'];
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
    this.budgetPeriod = [BudgetPeriodModel.empty()];
    this.status = '';
  }

  List<BudgetPeriodModel> getBudgetPeriod(Map<dynamic, dynamic> map) {
    return map.entries
        .map((entry) => BudgetPeriodModel(
            period: entry.key,
            totalWastes: entry.value['totalgastos'],
            totalActions: entry.value['totalacoes'],
            totalCategories: entry.value['totalcategorias'],
            totalEarns: entry.value['totalganhos']))
        .toList();
  }
}
