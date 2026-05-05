class NotificationModel {
  final String title;
  final String message;
  final String time;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
  });

  //! Convert NotificationModel to JSON for Storage Save
  Map<String, dynamic> toJson() {
    return {'title': title, 'message': message, 'time': time};
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
