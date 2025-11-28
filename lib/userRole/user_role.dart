enum UserRole {
  user,
  restaurant,
  wellness,
  leisure,
}

extension RoleValue on UserRole {
  String get roleValue {
    switch (this) {
      case UserRole.restaurant:
        return "restaurant";
      case UserRole.wellness:
        return "wellness";
      case UserRole.leisure:
        return "leisure";
      default:
        return "";
    }
  }
}
