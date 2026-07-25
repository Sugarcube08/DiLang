import '../models/user.dart';
import '../models/language_profile.dart';
import '../models/learning_preferences.dart';

abstract class IdentityRepository {
  Future<User?> loadUser();
  Future<void> createUser(User user);
  Future<void> updateUser(User user);

  Future<LanguageProfile?> loadLanguageProfile(String userId);
  Future<void> saveLanguageProfile(LanguageProfile profile);

  Future<LearningPreferences> loadPreferences();
  Future<void> savePreferences(LearningPreferences prefs);
}
