import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fromCurrency = 'USD';
  String toCurrency = 'INR';
  double amount = 1.0;
  double? result;
  double? alertThreshold;
  bool isLoading = false;
  bool showResult = false;

  final Map<String, String> currencyFlags = {
    'USD': '🇺🇸',
    'INR': '🇮🇳',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'JPY': '🇯🇵',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'CNY': '🇨🇳',
    'RUB': '🇷🇺',
    'ZAR': '🇿🇦',
  };

  List<String> get currencies => currencyFlags.keys.toList();

  Future<void> convertCurrency() async {
    setState(() {
      isLoading = true;
      showResult = false;
    });

    final rate = await ApiService.getConversionRate(fromCurrency, toCurrency, amount);

    setState(() {
      result = rate;
      isLoading = false;
      showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5FA),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currency Assistant',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 24),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        currencyFlags[fromCurrency] ?? '',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => amount = double.tryParse(val) ?? 1.0,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDropdown(fromCurrency, (val) => setState(() => fromCurrency = val))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.compare_arrows, color: Colors.white),
                    ),
                    Expanded(child: _buildDropdown(toCurrency, (val) => setState(() => toCurrency = val))),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: convertCurrency,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87))
                      : Text('Convert', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Result Panel
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: showResult && result != null
                        ? Text(
                      '${amount.toStringAsFixed(2)} $fromCurrency = ${result!.toStringAsFixed(2)} $toCurrency',
                      key: ValueKey(result),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                        : Text(
                      'Enter amount and press Convert',
                      key: ValueKey("prompt"),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Set alert if rate >',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g. 85.0',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.notifications_active),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => alertThreshold = double.tryParse(val),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String selectedValue, ValueChanged<String> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          onChanged: (val) => onChanged(val!),
          items: currencies.map((currency) {
            final flag = currencyFlags[currency]!;
            return DropdownMenuItem<String>(
              value: currency,
              child: Row(
                children: [
                  Text(flag, style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(currency),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
