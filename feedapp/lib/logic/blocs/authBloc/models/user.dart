class User {
  final String firstName, lastName, createdAt;
  final String? confirmedAt, bannedAt, completedAt, email;
  final int? serviceTypeId;
  final int id;
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
    required this.completedAt,
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
          completedAt: json['completed_at'],
          bannedAt: json['banned_at'],
          serviceTypeId: json['service_type_id'],
        );
  User completeProfile(String completedAt) => User(
        id: this.id,
        email: this.email,
        lastName: this.lastName,
        bannedAt: this.bannedAt,
        firstName: this.firstName,
        createdAt: this.createdAt,
        completedAt: completedAt,
        confirmedAt: this.confirmedAt,
        serviceTypeId: this.serviceTypeId,
      );
}
