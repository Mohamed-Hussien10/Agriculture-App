class ActionItemModel {
  final String title;
  final String description;

  ActionItemModel({required this.title, required this.description});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };

  factory ActionItemModel.fromJson(Map<String, dynamic> json) =>
      ActionItemModel(
        title: json['title'],
        description: json['description'],
      );
}