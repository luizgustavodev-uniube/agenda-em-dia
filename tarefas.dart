import 'package:flutter/material.dart';

class Tarefa {
  Tarefa(this.nome);

  final String nome;
  bool concluida = false;
}

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({
    super.key,
    required this.data,
    required this.tarefas,
  });

  final String data;
  final List<Tarefa> tarefas;

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  Future<void> adicionarTarefa() async {
    String nomeDigitado = '';

    final nome = await showDialog<String>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Nova tarefa'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nome da tarefa'),
            onChanged: (texto) {
              nomeDigitado = texto;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final nome = nomeDigitado.trim();

                if (nome.isEmpty) {
                  return;
                }

                Navigator.pop(contextoDialogo, nome);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    if (!mounted || nome == null) {
      return;
    }

    setState(() {
      widget.tarefas.add(Tarefa(nome));
    });
  }

  @override
  Widget build(BuildContext context) {
    final tarefasOrdenadas = List<Tarefa>.of(widget.tarefas);

    tarefasOrdenadas.sort((a, b) {
      // Se as tarefas têm status diferente, a pendente vem primeiro.
      if (a.concluida != b.concluida) {
        return a.concluida ? 1 : -1;
      }

      // Se têm o mesmo status, compara os nomes.
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4E9FF),
      appBar: AppBar(
        title: Text('Tarefas de ${widget.data}'),
        backgroundColor: const Color(0xFFF4E9FF),
      ),
      body: tarefasOrdenadas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa para este dia.'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: tarefasOrdenadas.length,
              itemBuilder: (context, indice) {
                final tarefa = tarefasOrdenadas[indice];

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: tarefa.concluida,
                      onChanged: (marcada) {
                        setState(() {
                          tarefa.concluida = marcada ?? false;
                        });
                      },
                    ),
                    title: Text(tarefa.nome),
                    subtitle: Text(tarefa.concluida ? 'Concluída' : 'Pendente'),
                    trailing: IconButton(
                      tooltip: 'Excluir tarefa',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          widget.tarefas.remove(tarefa);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: adicionarTarefa,
        backgroundColor: const Color(0xFFBE185D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar tarefa'),
      ),
    );
  }
}