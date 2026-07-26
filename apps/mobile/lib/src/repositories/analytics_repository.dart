abstract class AnalyticsRepository {
  Future<Map<String, dynamic>> fetchSnapshot();
}

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  @override
  Future<Map<String, dynamic>> fetchSnapshot() async {
    return {
      'total_words': 150,
      'retention_rate': 0.92,
    };
  }
}
