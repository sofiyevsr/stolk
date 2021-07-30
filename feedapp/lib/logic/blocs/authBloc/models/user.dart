import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String firstName, lastName, email, createdAt;
  final int serviceTypeId, id;
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
    required this.serviceTypeId,
  });

  User.fromJSON(Map<String, dynamic> json)
      : this(
          id: json["user_id"],
          firstName: json['first_name'],
          lastName: json['last_name'],
          email: json['email'],
          createdAt: json['created_at'],
          serviceTypeId: json['service_type_id'],
        );

  @override
  List get props => [
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.createdAt,
        this.serviceTypeId,
      ];
}
