import 'package:equatable/equatable.dart';

class ConversationScenario extends Equatable {
  final String id;
  final String title;
  final String description;
  final String cefrLevel;
  final int estimatedDurationMinutes;
  final String personaName;
  final String personaRole;
  final String personaPersonality;
  final List<String> targetVocabulary;
  final List<String> targetGrammarRules;
  final String culturalNote;

  const ConversationScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.cefrLevel,
    required this.estimatedDurationMinutes,
    required this.personaName,
    required this.personaRole,
    required this.personaPersonality,
    required this.targetVocabulary,
    required this.targetGrammarRules,
    required this.culturalNote,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        cefrLevel,
        estimatedDurationMinutes,
        personaName,
        personaRole,
        personaPersonality,
        targetVocabulary,
        targetGrammarRules,
        culturalNote,
      ];
}

class BuiltInScenarios {
  static const ScenarioCafeVienna = ConversationScenario(
    id: 'scn_cafe_vienna',
    title: 'Ordering at a Viennese Café',
    description: 'Practice ordering coffee, pastries, and asking for the bill in Vienna.',
    cefrLevel: 'A1',
    estimatedDurationMinutes: 15,
    personaName: 'Greta',
    personaRole: 'Café Waitress in Vienna',
    personaPersonality: 'Patient, polite, traditional Viennese',
    targetVocabulary: ['der Kaffee', 'die Speisekarte', 'das Wasser', 'zahlen', 'bitte'],
    targetGrammarRules: ['accusative_masculine_article', 'polite_verb_inversion'],
    culturalNote: 'In Vienna, it is customary to order "Einen Verlängerten" instead of "Americano".',
  );

  static const ScenarioDoctorAppointment = ConversationScenario(
    id: 'scn_doctor_berlin',
    title: 'Doctor Appointment in Berlin',
    description: 'Describe symptoms, understand prescriptions, and schedule follow-ups.',
    cefrLevel: 'A2',
    estimatedDurationMinutes: 15,
    personaName: 'Dr. Schmidt',
    personaRole: 'General Practitioner in Berlin',
    personaPersonality: 'Professional, empathetic, precise',
    targetVocabulary: ['Kopfschmerzen', 'das Rezept', 'die Apotheke', 'fieber', 'nehmen'],
    targetGrammarRules: ['modal_verbs_sollen_müssen', 'dative_prepositions'],
    culturalNote: 'Bring your health insurance card (Gesundheitskarte) to the reception first.',
  );

  static List<ConversationScenario> get all => [
        ScenarioCafeVienna,
        ScenarioDoctorAppointment,
      ];
}
