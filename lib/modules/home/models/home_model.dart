class HomeModel {
  String? title;
  String? description;
  String? date;
  String? time;
  String? status;
  String? priority;
  bool isDone;

  HomeModel({
    this.title,
    this.description,
    this.date,
    this.time,
    this.status,
    this.priority,
    this.isDone = false,
  });

  //! Convert HomeModel to JSON for Storage Save
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'status': status,
      'priority': priority,
      'isDone': isDone,
    };
  }

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'Pending',
      priority: json['priority'] ?? 'Low',
      isDone: json['isDone'] ?? false,
    );
  }
}
