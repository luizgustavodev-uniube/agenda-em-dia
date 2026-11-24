import 'package:flutter/material.dart';

import 'tarefas.dart';

class TelaCalendario extends StatefulWidget {
  const TelaCalendario({super.key});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime diaSelecionado = DateTime.now();
  final Map<DateTime, List<Tarefa>> tarefasPorDia = {};

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      appBar: AppBar(
        title: const Text('Agenda em Dia'),
        backgroundColor: const Color(0xFFF3E8FF),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6D28D9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.calendar_month, color: Colors.white, size: 44),
                const SizedBox(height: 12),
                const Text(
                  'Organize seu dia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecione uma data no calendário',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CalendarDatePicker(
                    initialDate: diaSelecionado,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100, 12, 31),
                    onDateChanged: (data) {
                      setState(() {
                        diaSelecionado = data;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dia escolhido: ${formatarData(diaSelecionado)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    final dia = DateUtils.dateOnly(diaSelecionado);
                    final tarefas = tarefasPorDia.putIfAbsent(
                      dia,
                      () => <Tarefa>[],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaTarefas(
                          data: formatarData(dia),
                          tarefas: tarefas,
                        ),
                      ),
                    );
                  },
                  child: const Text('Ver tarefas do dia'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
