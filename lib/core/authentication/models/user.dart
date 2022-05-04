class User {
  final String? fullname;
  final String? email;

  User({this.fullname, this.email});

  @override
  String toString() => 'User { fullname: $fullname, email: $email}';
}
