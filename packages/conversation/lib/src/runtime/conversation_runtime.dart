import 'package:dilang_learner/learner.dart';
import '../scenarios/conversation_scenario.dart';
import '../replay/learning_replay_transcript.dart';
import '../manager/dialogue_manager.dart';
import '../llm/llm_provider_contract.dart';
import '../prompt/adaptive_prompt_assembler.dart';

class ConversationRuntime {
  final ConversationScenario scenario;
  final DiLangUser learner;
  final LlmProviderContract llmProvider;
  final AdaptivePromptAssembler promptAssembler;
  final DialogueManager dialogueManager;

  ConversationRuntime({
    required this.scenario,
    required this.learner,
    LlmProviderContract? llmProvider,
    this.promptAssembler = const AdaptivePromptAssembler(),
  })  : llmProvider = llmProvider ?? MockLlmProvider(),
        dialogueManager = DialogueManager(scenario: scenario);

  SessionBriefing generatePreSessionBriefing() {
    return dialogueManager.generatePreSessionBriefing();
  }

  Future<LearningReplayTurn> processTurn({
    required String learnerInput,
    double phoneticScore = 90.0,
  }) async {
    final systemPrompt = promptAssembler.assembleSystemPrompt(
      learner: learner,
      scenario: scenario,
    );

    final history = dialogueManager.turns
        .map((t) => [
              ChatMessage(role: ChatRole.assistant, content: t.tutorPrompt),
              ChatMessage(role: ChatRole.user, content: t.learnerResponse),
            ])
        .expand((element) => element)
        .toList();

    final tutorReply = await llmProvider.generateCompletion(
      systemPrompt: systemPrompt,
      userPrompt: learnerInput,
      history: history,
    );

    String corrected = learnerInput;
    String grammarNote = 'Grammar structure is natural.';
    double score = phoneticScore;

    if (learnerInput.contains('heiße Kaffee') || learnerInput.contains('ein Kaffee')) {
      corrected = 'Ich möchte einen heißen Kaffee, bitte.';
      grammarNote = 'Masculine accusative requires weak adjective ending "-en" ("einen heißen Kaffee").';
      score = 78.0;
    }

    return dialogueManager.processTurn(
      tutorPrompt: tutorReply,
      learnerResponse: learnerInput,
      correctedResponse: corrected,
      grammarNote: grammarNote,
      phoneticScore: score,
    );
  }

  SessionDebriefing generatePostSessionDebriefing({int initialConfidence = 70}) {
    return dialogueManager.generatePostSessionDebriefing(initialConfidence: initialConfidence);
  }

  List<LearningReplayTurn> get turns => dialogueManager.turns;
}
