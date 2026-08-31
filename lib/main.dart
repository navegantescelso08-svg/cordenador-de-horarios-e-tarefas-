import 'package:flutter/material.dart';
import 'models/task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coordenador de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(
      id: 1,
      userId: 1,
      title: 'Estudar Framework Laravel 11',
      description: 'Revisar rotas, controllers e migrations para o projeto.',
      scheduledAt: '2026-09-01 14:00',
      priority: 'alta',
      status: 'pendente',
    ),
    Task(
      id: 2,
      userId: 1,
      title: 'Configurar ambiente Flutter',
      description: 'Testar componentes de UI e modelos de dados.',
      scheduledAt: '2026-09-01 16:00',
      priority: 'media',
      status: 'em_andamento',
    ),
  ];

  String _searchQuery = '';
  String _selectedStatusFilter = 'todos';

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'concluida':
        return Colors.green;
      case 'em_andamento':
        return Colors.blue;
      default:
        return Colors.amber.shade800;
    }
  }

  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatusFilter == 'todos' || task.status == _selectedStatusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _openAddTaskModal() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String priority = 'media';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nova Tarefa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: priority,
              decoration: const InputDecoration(
                labelText: 'Prioridade',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'baixa', child: Text('Baixa')),
                DropdownMenuItem(value: 'media', child: Text('Média')),
                DropdownMenuItem(value: 'alta', child: Text('Alta')),
              ],
              onChanged: (val) => priority = val ?? 'media',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                setState(() {
                  _tasks.add(
                    Task(
                      id: DateTime.now().millisecondsSinceEpoch,
                      userId: 1,
                      title: titleController.text,
                      description: descriptionController.text,
                      scheduledAt: '2026-09-01 18:00',
                      priority: priority,
                      status: 'pendente',
                    ),
                  );
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Salvar Tarefa'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordenador de Tarefas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar tarefa...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedStatusFilter,
                  items: const [
                    DropdownMenuItem(value: 'todos', child: Text('Todos')),
                    DropdownMenuItem(value: 'pendente', child: Text('Pendente')),
                    DropdownMenuItem(value: 'em_andamento', child: Text('Em Andamento')),
                    DropdownMenuItem(value: 'concluida', child: Text('Concluída')),
                  ],
                  onChanged: (val) => setState(() => _selectedStatusFilter = val!),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(child: Text('Nenhuma tarefa encontrada.'))
                : ListView.builder(
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      final isDone = task.status == 'concluida';

                      return Dismissible(
                        key: Key(task.id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          setState(() => _tasks.removeWhere((t) => t.id == task.id));
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: Checkbox(
                              value: isDone,
                              onChanged: (bool? checked) {
                                setState(() {
                                  final targetIndex = _tasks.indexWhere((t) => t.id == task.id);
                                  if (targetIndex != -1) {
                                    _tasks[targetIndex] = Task(
                                      id: task.id,
                                      userId: task.userId,
                                      title: task.title,
                                      description: task.description,
                                      scheduledAt: task.scheduledAt,
                                      priority: task.priority,
                                      status: checked == true ? 'concluida' : 'pendente',
                                    );
                                  }
                                });
                              },
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Text('${task.description ?? ''}\nHorário: ${task.scheduledAt}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Chip(
                                  labelStyle: const TextStyle(fontSize: 10, color: Colors.white),
                                  backgroundColor: _getStatusColor(task.status),
                                  label: Text(task.status),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}