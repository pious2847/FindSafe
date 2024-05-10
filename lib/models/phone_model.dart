class Phone {
  final String name;
  final String imageUrl;

  Phone({required this.name, required this.imageUrl});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      name: json['devicename'],
      imageUrl: json['image'],
    );
  }
}
