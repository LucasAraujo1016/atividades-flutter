import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Tarefas Diárias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TarefasScreen(),
    );
  }
}

enum Prioridade { baixa, media, alta }

extension PrioridadeLabel on Prioridade {
  String get label {
    switch (this) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }

  Color get cor {
    switch (this) {
      case Prioridade.baixa:
        return Colors.green;
      case Prioridade.media:
        return Colors.orange;
      case Prioridade.alta:
        return Colors.red;
    }
  }
}

class Tarefa {
  String nome;
  String descricao;
  bool concluida;
  Prioridade prioridade;

  Tarefa({
    required this.nome,
    required this.descricao,
    this.concluida = false,
    this.prioridade = Prioridade.media,
  });
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  Prioridade _prioridadeSelecionada = Prioridade.media;

  final List<Tarefa> _tarefas = [];

  void _adicionarTarefa() {
    final String nome = _nomeController.text.trim();
    final String descricao = _descricaoController.text.trim();
    if (nome.isEmpty) return;

    setState(() {
      _tarefas.add(Tarefa(
        nome: nome,
        descricao: descricao,
        prioridade: _prioridadeSelecionada,
      ));
      _nomeController.clear();
      _descricaoController.clear();
      _prioridadeSelecionada = Prioridade.media;
    });
  }

  void _alternarConcluida(int index, bool? valor) {
    setState(() {
      _tarefas[index].concluida = valor ?? false;
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tarefas Diárias'),
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
                  labelText: 'Nome da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição breve',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<Prioridade>(
                segments: Prioridade.values.map((prioridade) {
                  return ButtonSegment<Prioridade>(
                    value: prioridade,
                    label: Text(prioridade.label),
                  );
                }).toList(),
                selected: {_prioridadeSelecionada},
                onSelectionChanged: (novaSelecao) {
                  setState(() {
                    _prioridadeSelecionada = novaSelecao.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _adicionarTarefa,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Adicionar Tarefa', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Expanded(
                child: _tarefas.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma tarefa cadastrada.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _tarefas.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final tarefa = _tarefas[index];
                          return Card(
                            elevation: 0,
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: tarefa.concluida,
                                onChanged: (valor) => _alternarConcluida(index, valor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              title: Text(
                                tarefa.nome,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: tarefa.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: tarefa.concluida ? Colors.grey : Colors.black87,
                                ),
                              ),
                              subtitle: tarefa.descricao.isNotEmpty
                                  ? Text(
                                      tarefa.descricao,
                                      style: TextStyle(
                                        color: tarefa.concluida ? Colors.grey : Colors.grey[700],
                                      ),
                                    )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tarefa.prioridade.cor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      tarefa.prioridade.label,
                                      style: TextStyle(
                                        color: tarefa.prioridade.cor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _removerTarefa(index),
                                  ),
                                ],
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