class Task {
  final int id;
  final int userId;
  final int? categoryId;
  final String title;
  final String? description;
  final String scheduledAt;
  final String priority;
  final String status;

  Task({
    required this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    this.description,
    required this.scheduledAt,
    required this.priority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      scheduledAt: json['scheduled_at'],
      priority: json['priority'],
      status: json['status'],
    );
  }
}