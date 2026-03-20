class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? bizName;
  final String? bizCategory;
  final int? bizEmployeeCount;
  final String? businessId;
  final bool onboardingCompleted;

  UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.bizName,
    this.bizCategory,
    this.bizEmployeeCount,
    this.businessId,
    this.onboardingCompleted = false,
  });
}

