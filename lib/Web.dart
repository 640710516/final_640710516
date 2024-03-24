class Web {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  //final bool completed;

  Web({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    //required this.completed,
  });

  factory Web.fromJson(Map<String, dynamic> json) {
    return Web(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
      //completed: json['completed'],
    );
  }
}
