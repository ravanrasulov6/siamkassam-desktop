class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? businessId;
  final bool onboardingCompleted;

  UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.businessId,
    this.onboardingCompleted = false,
  });
}

