import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _apiKey = 'bf3eaefbfbc991949d4de9f0998af40a';

  static Future<double?> getConversionRate(String from, String to, double amount) async {
    final url = Uri.parse(
        'https://api.exchangeratesapi.io/v1/latest?access_key=$_apiKey&symbols=$from,$to');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final fromRate = data['rates'][from];
        final toRate = data['rates'][to];
        if (fromRate == null || toRate == null) return null;
        final result = (toRate as num).toDouble() / (fromRate as num).toDouble();
        return amount * result;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<Map<DateTime, double>?> getHistoricalRates(String from, String to) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: 7));

    final url = Uri.parse(
        'https://api.exchangeratesapi.io/v1/timeseries?access_key=$_apiKey&start_date=${start.toIso8601String().split("T")[0]}&end_date=${now.toIso8601String().split("T")[0]}&base=EUR&symbols=$from,$to');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        final Map<DateTime, double> resultMap = {};
        for (var entry in rates.entries) {
          final date = DateTime.parse(entry.key);
          final fromRate = entry.value[from];
          final toRate = entry.value[to];

          if (fromRate != null && toRate != null) {
            final value = (toRate as num).toDouble() / (fromRate as num).toDouble();
            resultMap[date] = value;
          }
        }
        final sorted = Map.fromEntries(resultMap.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)));
        return sorted;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
