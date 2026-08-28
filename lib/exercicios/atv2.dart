import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Média',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MediaScreen(),
    );
  }
}

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final TextEditingController _nota1Controller = TextEditingController();
  final TextEditingController _nota2Controller = TextEditingController();
  final TextEditingController _nota3Controller = TextEditingController();
  String _resultado = '';

  void _calcularMedia() {
    final double? nota1 = double.tryParse(_nota1Controller.text.replaceAll(',', '.'));
    final double? nota2 = double.tryParse(_nota2Controller.text.replaceAll(',', '.'));
    final double? nota3 = double.tryParse(_nota3Controller.text.replaceAll(',', '.'));

    if (nota1 == null || nota2 == null || nota3 == null) {
      setState(() {
        _resultado = 'Preencha as três notas com valores válidos.';
      });
      return;
    }

    final double media = (nota1 + nota2 + nota3) / 3;

    setState(() {
      _resultado = 'Média: ${media.toStringAsFixed(2)}';
    });
  }

  @override
  void dispose() {
    _nota1Controller.dispose();
    _nota2Controller.dispose();
    _nota3Controller.dispose();
    super.dispose();
  }

  Widget _buildNotaField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Média'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNotaField(_nota1Controller, 'Nota 1'),
              const SizedBox(height: 14),
              _buildNotaField(_nota2Controller, 'Nota 2'),
              const SizedBox(height: 14),
              _buildNotaField(_nota3Controller, 'Nota 3'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _calcularMedia,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Calcular Média', style: TextStyle(fontSize: 16)),
              ),
              if (_resultado.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text(
                  _resultado,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}