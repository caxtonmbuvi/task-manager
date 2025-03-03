enum UserRole {
  admin,
  teamLeader,
  worker;


  String getname() {
    switch (this) {
      case UserRole.teamLeader:
        return 'TEAM_LEADER';
      case UserRole.worker:
        return 'WORKER';
        case UserRole.admin:
        return 'ADMIN';
      }
  }

}
