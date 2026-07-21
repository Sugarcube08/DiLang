import 'package:dilang_learner/learner.dart';
import 'package:dilang_conversation/src/scenarios/conversation_scenario.dart';

class AdaptivePromptAssembler {
  const AdaptivePromptAssembler();

  String assembleSystemPrompt({
    required DiLangUser learner,
    required ConversationScenario scenario,
    List<String> weakGrammarNodes = const [],
  }) {
    final langProfile = learner.primaryLanguageProfile;
    final targetLang = langProfile?.targetLanguage ?? 'German';
    final nativeLang = learner.profile.nativeLanguage;
    final cefr = langProfile?.cefrLevel ?? 'A1';
    final brainModel = langProfile?.brainModel ?? 'Conversation First';
    final personaName = scenario.personaName;
    final personaRole = scenario.personaRole;

    final buffer = StringBuffer();
    buffer.writeln('You are $personaName, a $personaRole.');
    buffer.writeln('Target Language: $targetLang | Medium/Explanation Language: $nativeLang');
    buffer.writeln('Learner CEFR Level: $cefr | Brain Model Focus: $brainModel');
    buffer.writeln('Scenario Objective: ${scenario.description}');
    buffer.writeln('Cultural Context: ${scenario.culturalNote}');

    if (weakGrammarNodes.isNotEmpty) {
      buffer.writeln('Learner Weak Grammar Points to target: ${weakGrammarNodes.join(", ")}');
    }

    if (cefr == 'A1' || cefr == 'A2') {
      buffer.writeln('Guidelines for Beginner Level ($cefr):');
      buffer.writeln('- Speak in simple, clear $targetLang sentences.');
      buffer.writeln('- Use high-frequency vocabulary suitable for $cefr.');
      buffer.writeln('- Provide friendly encouragement in your tutor persona.');
    } else {
      buffer.writeln('Guidelines for Advanced Level ($cefr):');
      buffer.writeln('- Speak entirely in natural, idiomatic $targetLang.');
      buffer.writeln('- Introduce complex sentence structures.');
    }

    return buffer.toString();
  }
}
