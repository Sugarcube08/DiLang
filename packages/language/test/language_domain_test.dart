import 'package:test/test.dart';
import 'package:dilang_language/language.dart';

void main() {
  group('Language Intelligence Domain Tests', () {
    test('1. CefrLevel ordering & comparisons work as expected', () {
      expect(CefrLevel.a1.isAtLeast(CefrLevel.a1), isTrue);
      expect(CefrLevel.b2.isAtLeast(CefrLevel.a2), isTrue);
      expect(CefrLevel.a2.isAtLeast(CefrLevel.c1), isFalse);
    });

    test('2. VocabularyEntry constructs rich linguistic models', () {
      const lemma = Lemma(
        id: 'lem_haus',
        text: 'Haus',
        partOfSpeech: PartOfSpeech.noun,
        languageCode: 'de-DE',
        ipaTranscription: '/haʊ̯s/',
      );

      const surfaceFormPlural = SurfaceForm(
        text: 'Häuser',
        grammaticalTag: 'nominative_plural',
        ipa: '/ˈhɔɪ̯zɐ/',
      );

      const entry = VocabularyEntry(
        id: 'voc_haus',
        lemma: lemma,
        surfaceForms: [surfaceFormPlural],
        translations: ['house', 'building'],
        exampleSentences: ['Das Haus ist groß.'],
        cefrLevel: CefrLevel.a1,
        frequencyRank: 150,
      );

      expect(entry.lemma.text, equals('Haus'));
      expect(entry.surfaceForms.first.text, equals('Häuser'));
      expect(entry.cefrLevel, equals(CefrLevel.a1));
    });

    test('3. GrammarRule prerequisites and negative examples work', () {
      const v2Rule = GrammarRule(
        id: 'g_v2',
        code: 'GER_V2_ORDER',
        title: 'Verb-Second Word Order',
        explanation: 'In main clauses, the conjugated verb occupies the second position.',
        category: GrammarCategory.syntax,
        cefrLevel: CefrLevel.a1,
        positiveExamples: ['Heute gehe ich nach Hause.'],
        negativeExamples: ['Heute ich gehe nach Hause.'],
      );

      expect(v2Rule.code, equals('GER_V2_ORDER'));
      expect(v2Rule.negativeExamples.first, contains('ich gehe'));
    });

    test('4. Phrase graph captures communicative intents', () {
      const coffeePhrase = Phrase(
        id: 'phr_coffee',
        text: 'Ich hätte gerne einen Kaffee, bitte.',
        intentCode: 'ORDER_FOOD',
        formality: FormalityLevel.polite,
        cefrLevel: CefrLevel.a1,
        translations: ['I would like a coffee, please.'],
        alternativePhrases: ['Einen Kaffee, bitte.'],
      );

      expect(coffeePhrase.intentCode, equals('ORDER_FOOD'));
      expect(coffeePhrase.formality, equals(FormalityLevel.polite));
    });
  });
}
