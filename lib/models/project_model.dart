class Project_model {
  final String id;
  final String projectName;
  final String statusName;
  final double completionPercentage;
  final String priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tasks;
  final String? icon;
  final List<String> assignees;
  final String? link;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Project_model({
    required this.id,
    required this.projectName,
    required this.statusName,
    required this.completionPercentage,
    required this.priority,
    this.startDate,
    this.endDate,
    required this.tasks,
    this.icon,
    required this.assignees,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  factory Project_model.fromJson(Map<String, dynamic> json) {
    // Handle tasks - ensure it's always a List<String>
    List<String> tasksList = [];
    if (json['tasks'] != null) {
      if (json['tasks'] is List) {
        tasksList = List<String>.from(json['tasks'].map((item) => item.toString()));
      }
    }

    // Handle assignees - ensure it's always a List<String>
    List<String> assigneesList = [];
    if (json['assignees'] != null) {
      if (json['assignees'] is List) {
        assigneesList = List<String>.from(json['assignees'].map((item) => item.toString()));
      }
    }

    return Project_model(
      id: json['_id']?.toString() ?? '',
      projectName: json['projectName']?.toString() ?? '',
      statusName: json['statusName']?.toString() ?? '',
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      priority: json['priority']?.toString() ?? 'Not Set',
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      tasks: tasksList,
      icon: json['icon']?.toString(),
      assignees: assigneesList,
      link: json['link']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
