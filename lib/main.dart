import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversie monedă',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CurrencyPage(),
    );
  }
}

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final TextEditingController _amountController = TextEditingController();

  // Valoarea unei unități din fiecare valută, exprimată în MDL.
  final Map<String, double> _rates = {
    'MDL': 1.0,
    'EUR': 19.5,
    'USD': 18.0,
    'RON': 3.9,
    'GBP': 23.0,
  };

  String _sourceCurrency = 'EUR';
  String _destinationCurrency = 'MDL';
  String _result = 'Introduceți suma și apăsați „Convertește”.';

  void _convert() {
    final String input = _amountController.text.trim().replaceAll(',', '.');
    final double? amount = double.tryParse(input);

    if (amount == null || !amount.isFinite || amount < 0) {
      setState(() {
        _result = 'Introduceți o sumă validă, mai mare sau egală cu 0.';
      });
      return;
    }

    // Convertim întâi în MDL, apoi în moneda destinație.
    final double convertedAmount =
        amount * _rates[_sourceCurrency]! / _rates[_destinationCurrency]!;

    if (!convertedAmount.isFinite) {
      setState(() {
        _result = 'Suma introdusă este prea mare.';
      });
      return;
    }

    setState(() {
      _result =
          '${amount.toStringAsFixed(2)} $_sourceCurrency = '
          '${convertedAmount.toStringAsFixed(2)} $_destinationCurrency';
    });

    FocusScope.of(context).unfocus();
  }

  Widget _buildCurrencyDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: _rates.keys.map((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversie monedă'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.currency_exchange, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Suma',
                  hintText: 'Exemplu: 100',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
              ),
              const SizedBox(height: 24),
              _buildCurrencyDropdown(
                label: 'Moneda sursă',
                value: _sourceCurrency,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _sourceCurrency = value;
                      _result = 'Apăsați „Convertește” pentru noul rezultat.';
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildCurrencyDropdown(
                label: 'Moneda destinație',
                value: _destinationCurrency,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _destinationCurrency = value;
                      _result = 'Apăsați „Convertește” pentru noul rezultat.';
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Convertește',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _result,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cursuri fixe demonstrative, introduse în aplicație.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
