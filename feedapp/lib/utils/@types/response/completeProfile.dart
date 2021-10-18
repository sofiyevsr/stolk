class CompleteProfileResponse {
  final String completedAt;

  CompleteProfileResponse.fromJSON(Map<String, dynamic> res)
      : this.completedAt = res['completed_at'];
}
