import 'package:cloud_firestore/cloud_firestore.dart';

// DO NOT PLAYING AROUND WITH ATTRIBUTE NAMES
class Project {
  String id;
  String name;
  String lastModified;
  DateTime? echeance;
  DateTime? datePreparationCahierCharges;
  DateTime? dateValidationCahierCharges;
  DateTime? datePublicationAppelOffre;
  DateTime? dateClotureAppelOffre;
  double? budgetAlloue;
  String? fournisseur;
  DateTime? dateAffectation;
  double? coutTotalMateriel;
  double? coutParArticle;
  DateTime? dateLivraisonPrevue;
  DateTime? dateLivraisonReelle;
  DateTime? dateReceptionDefinitive;
  double? penalite;
  double? coefficientPenalite;
  double? plafondPenalite;

  Project({
    required this.id,
    required this.name,
    required this.lastModified,
    this.echeance,
    this.datePreparationCahierCharges,
    this.dateValidationCahierCharges,
    this.datePublicationAppelOffre,
    this.dateClotureAppelOffre,
    this.budgetAlloue,
    this.fournisseur,
    this.dateAffectation,
    this.coutTotalMateriel,
    this.coutParArticle,
    this.dateLivraisonPrevue,
    this.dateLivraisonReelle,
    this.dateReceptionDefinitive,
    this.penalite,
    this.coefficientPenalite,
    this.plafondPenalite,
  });

  factory Project.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Project(
      id: doc.id,
      name: data['name'] ?? '',
      lastModified: data['lastModified'] ?? "1713460006113",
      echeance: data['echeance'] != null
          ? (data['echeance'] as Timestamp).toDate()
          : null,
      datePreparationCahierCharges: data['datePreparationCahierCharges'] != null
          ? (data['datePreparationCahierCharges'] as Timestamp).toDate()
          : null,
      dateValidationCahierCharges: data['dateValidationCahierCharges'] != null
          ? (data['dateValidationCahierCharges'] as Timestamp).toDate()
          : null,
      datePublicationAppelOffre: data['datePublicationAppelOffre'] != null
          ? (data['datePublicationAppelOffre'] as Timestamp).toDate()
          : null,
      dateClotureAppelOffre: data['dateClotureAppelOffre'] != null
          ? (data['dateClotureAppelOffre'] as Timestamp).toDate()
          : null,
      budgetAlloue: data['budgetAlloue']?.toDouble(),
      fournisseur: data['fournisseur'],
      dateAffectation: data['dateAffectation'] != null
          ? (data['dateAffectation'] as Timestamp).toDate()
          : null,
      coutTotalMateriel: data['coutTotalMateriel']?.toDouble(),
      coutParArticle: data['coutParArticle']?.toDouble(),
      dateLivraisonPrevue: data['dateLivraisonPrevue'] != null
          ? (data['dateLivraisonPrevue'] as Timestamp).toDate()
          : null,
      dateLivraisonReelle: data['dateLivraisonReelle'] != null
          ? (data['dateLivraisonReelle'] as Timestamp).toDate()
          : null,
      dateReceptionDefinitive: data['dateReceptionDefinitive'] != null
          ? (data['dateReceptionDefinitive'] as Timestamp).toDate()
          : null,
      penalite: data['penalite']?.toDouble(),
      coefficientPenalite: data['coefficientPenalite']?.toDouble(),
      plafondPenalite: data['plafondPenalite']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'lastModified':lastModified,
      'echeance': echeance != null ? Timestamp.fromDate(echeance!) : null,
      'datePreparationCahierCharges': datePreparationCahierCharges != null
          ? Timestamp.fromDate(datePreparationCahierCharges!)
          : null,
      'dateValidationCahierCharges': dateValidationCahierCharges != null
          ? Timestamp.fromDate(dateValidationCahierCharges!)
          : null,
      'datePublicationAppelOffre': datePublicationAppelOffre != null
          ? Timestamp.fromDate(datePublicationAppelOffre!)
          : null,
      'dateClotureAppelOffre': dateClotureAppelOffre != null
          ? Timestamp.fromDate(dateClotureAppelOffre!)
          : null,
      'budgetAlloue': budgetAlloue,
      'fournisseur': fournisseur,
      'dateAffectation':
          dateAffectation != null ? Timestamp.fromDate(dateAffectation!) : null,
      'coutTotalMateriel': coutTotalMateriel,
      'coutParArticle': coutParArticle,
      'dateLivraisonPrevue': dateLivraisonPrevue != null
          ? Timestamp.fromDate(dateLivraisonPrevue!)
          : null,
      'dateLivraisonReelle': dateLivraisonReelle != null
          ? Timestamp.fromDate(dateLivraisonReelle!)
          : null,
      'dateReceptionDefinitive': dateReceptionDefinitive != null
          ? Timestamp.fromDate(dateReceptionDefinitive!)
          : null,
      'penalite': penalite,
      'coefficientPenalite': coefficientPenalite,
      'plafondPenalite': plafondPenalite,
    };
  }
}
