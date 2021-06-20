import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? firstName, lastName, email, createdAt;
  final int? serviceTypeId, accountTypeId;
  const User({
    this.firstName,
    this.lastName,
    this.email,
    this.createdAt,
    this.serviceTypeId,
    this.accountTypeId,
  });

  User.fromJSON(Map<String, dynamic> json)
      : this(
          firstName: json['first_name'],
          lastName: json['last_name'],
          email: json['email'],
          createdAt: json['created_at'],
          serviceTypeId: json['service_type_id'],
          accountTypeId: json['account_type_id'],
        );

  @override
  List get props => [
        this.firstName,
        this.lastName,
        this.email,
        this.createdAt,
        this.serviceTypeId,
        this.accountTypeId,
      ];
}
