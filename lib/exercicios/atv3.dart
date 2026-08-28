import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Desconto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DescontoScreen(),
    );
  }
}

class Produto {
  final String nome;
  final double precoOriginal;
  final double percentualDesconto;
  final double precoFinal;

  Produto({
    required this.nome,
    required this.precoOriginal,
    required this.percentualDesconto,
    required this.precoFinal,
  });
}

class DescontoScreen extends StatefulWidget {
  const DescontoScreen({super.key});

  @override
  State<DescontoScreen> createState() => _DescontoScreenState();
}

class _DescontoScreenState extends State<DescontoScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _descontoController = TextEditingController();

  final List<Produto> _produtos = [];
  String _erro = '';

  void _adicionarProduto() {
    final String nome = _nomeController.text.trim();
    final double? preco = double.tryParse(_precoController.text.replaceAll(',', '.'));
    final double? desconto = double.tryParse(_descontoController.text.replaceAll(',', '.'));

    if (nome.isEmpty || preco == null || desconto == null) {
      setState(() {
        _erro = 'Preencha nome, preço e desconto corretamente.';
      });
      return;
    }

    final double precoFinal = preco - (preco * desconto / 100);

    setState(() {
      _produtos.add(Produto(
        nome: nome,
        precoOriginal: preco,
        percentualDesconto: desconto,
        precoFinal: precoFinal,
      ));
      _erro = '';
      _nomeController.clear();
      _precoController.clear();
      _descontoController.clear();
    });
  }

  void _removerProduto(int index) {
    setState(() {
      _produtos.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descontoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Desconto'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do produto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Preço original (R\$)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descontoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Desconto (%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _adicionarProduto,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Adicionar Produto', style: TextStyle(fontSize: 16)),
              ),
              if (_erro.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _erro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              Expanded(
                child: _produtos.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum produto cadastrado.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _produtos.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final produto = _produtos[index];
                          return Card(
                            elevation: 0,
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                produto.nome,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'De R\$ ${produto.precoOriginal.toStringAsFixed(2)} (-${produto.percentualDesconto.toStringAsFixed(0)}%)\nPor R\$ ${produto.precoFinal.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _removerProduto(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}