import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String name;
  double? budgetAlloue;
  DateTime? dateMiseEnVigueur;
  DateTime? datePublicationAO;
  int? delaiAO;
  DateTime? dateClotureAO;
  DateTime? dateOuvertureOffres;
  DateTime? datePrevueLivraison;
  DateTime? dateReelleLivraison;
  DateTime? dateReceptionDefinitive;
  double? coefficientPenalite;
  double? plafondPenalite;
  double? montantPenalite;

  Project({
    required this.id,
    required this.name,
    this.budgetAlloue,
    this.dateMiseEnVigueur,
    this.datePublicationAO,
    this.delaiAO,
    this.dateClotureAO,
    this.dateOuvertureOffres,
    this.datePrevueLivraison,
    this.dateReelleLivraison,
    this.dateReceptionDefinitive,
    this.coefficientPenalite,
    this.plafondPenalite,
    this.montantPenalite,
  });

  factory Project.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Project(
      id: doc.id,
      name: data['name'] ?? '',
      budgetAlloue: data['budgetAlloue'] != null ? data['budgetAlloue'].toDouble() : null,
      dateMiseEnVigueur: data['dateMiseEnVigueur'] != null ? (data['dateMiseEnVigueur'] as Timestamp).toDate() : null,
      datePublicationAO: data['datePublicationAO'] != null ? (data['datePublicationAO'] as Timestamp).toDate() : null,
      delaiAO: data['delaiAO'] ?? null,
      dateClotureAO: data['dateClotureAO'] != null ? (data['dateClotureAO'] as Timestamp).toDate() : null,
      dateOuvertureOffres: data['dateOuvertureOffres'] != null ? (data['dateOuvertureOffres'] as Timestamp).toDate() : null,
      datePrevueLivraison: data['datePrevueLivraison'] != null ? (data['datePrevueLivraison'] as Timestamp).toDate() : null,
      dateReelleLivraison: data['dateReelleLivraison'] != null ? (data['dateReelleLivraison'] as Timestamp).toDate() : null,
      dateReceptionDefinitive: data['dateReceptionDefinitive'] != null ? (data['dateReceptionDefinitive'] as Timestamp).toDate() : null,
      coefficientPenalite: data['coefficientPenalite'] != null ? data['coefficientPenalite'].toDouble() : null,
      plafondPenalite: data['plafondPenalite'] != null ? data['plafondPenalite'].toDouble() : null,
      montantPenalite: data['montantPenalite'] != null ? data['montantPenalite'].toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'budgetAlloue': budgetAlloue,
      'dateMiseEnVigueur': dateMiseEnVigueur != null ? Timestamp.fromDate(dateMiseEnVigueur!) : null,
      'datePublicationAO': datePublicationAO != null ? Timestamp.fromDate(datePublicationAO!) : null,
      'delaiAO': delaiAO,
      'dateClotureAO': dateClotureAO != null ? Timestamp.fromDate(dateClotureAO!) : null,
      'dateOuvertureOffres': dateOuvertureOffres != null ? Timestamp.fromDate(dateOuvertureOffres!) : null,
      'datePrevueLivraison': datePrevueLivraison != null ? Timestamp.fromDate(datePrevueLivraison!) : null,
      'dateReelleLivraison': dateReelleLivraison != null ? Timestamp.fromDate(dateReelleLivraison!) : null,
      'dateReceptionDefinitive': dateReceptionDefinitive != null ? Timestamp.fromDate(dateReceptionDefinitive!) : null,
      'coefficientPenalite': coefficientPenalite,
      'plafondPenalite': plafondPenalite,
      'montantPenalite': montantPenalite,
    };
  }
}
