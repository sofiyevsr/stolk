class User {
  final String firstName, lastName, email, createdAt;
  final String? confirmedAt, bannedAt;
  final int? serviceTypeId;
  final int id;
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
    required this.serviceTypeId,
    required this.confirmedAt,
    required this.bannedAt,
  });

  User.fromJSON(Map<String, dynamic> json)
      : this(
          id: json["user_id"],
          firstName: json['first_name'],
          lastName: json['last_name'],
          email: json['email'],
          createdAt: json['created_at'],
          confirmedAt: json['confirmed_at'],
          bannedAt: json['banned_at'],
          serviceTypeId: json['service_type_id'],
        );
}
