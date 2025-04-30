import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TodoController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'To-Do Manager',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<FilterOption>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: ctrl.setFilter,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOption.all,
                child: Row(
                  children: [
                    const Icon(Icons.list, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      'Semua',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterOption.active,
                child: Row(
                  children: [
                    const Icon(Icons.radio_button_unchecked,
                        color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Aktif',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterOption.completed,
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Selesai',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  context,
                  'Total',
                  ctrl.totalCount.toString(),
                  Colors.white,
                  Icons.list_alt,
                ),
                _buildStatCard(
                  context,
                  'Aktif',
                  ctrl.activeCount.toString(),
                  Colors.orange,
                  Icons.pending_actions,
                ),
                _buildStatCard(
                  context,
                  'Selesai',
                  ctrl.completedCount.toString(),
                  Colors.green,
                  Icons.task_alt,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.task, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  'Daftar Tugas',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ctrl.todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada tugas',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tekan tombol + untuk menambahkan tugas baru',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      key: ValueKey(ctrl.todos.length),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: ctrl.todos.length,
                      itemBuilder: (_, i) {
                        final t = ctrl.todos[i];
                        return Dismissible(
                          key: ValueKey(t.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          onDismissed: (_) => ctrl.removeTodo(t.id),
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Checkbox(
                                activeColor: Colors.deepPurple,
                                shape: const CircleBorder(),
                                value: t.completed,
                                onChanged: (_) => ctrl.toggleTodo(t.id),
                              ),
                              title: Row(
                                children: [
                                  if (t.isImportant)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.priority_high,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      t.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: t.completed
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        decoration: t.completed
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: t.completed
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Tugas dihapus'),
                                      action: SnackBarAction(
                                        label: 'Batal',
                                        onPressed: () {
                                          ctrl.addTodo(t.title,
                                              isImportant: t.isImportant);
                                        },
                                      ),
                                    ),
                                  );
                                  ctrl.removeTodo(t.id);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, '/add'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      Color color, IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(iconData, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
