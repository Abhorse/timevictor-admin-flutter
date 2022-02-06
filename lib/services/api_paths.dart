class APIPath {
  static String matches(String matchID) => 'matches/$matchID';
  static String addToPandingMatches(String matchID) =>
      'pendingMatches/$matchID';

  static String notification() => 'notifications';
  static String adminNotification() => 'admin/notification';
  static String createNotification(String nId) => 'notifications/$nId';

  static String allMatches() => 'matches/';
  static String allPendingMatches() => 'pendingMatches/';

  static String teamA(String matchID, String sName) =>
      'matches/$matchID/teamAStudents/$sName';
  static String pendingMatchTeamA(String matchID, String sName) =>
      'pendingMatches/$matchID/teamAStudents/$sName';

  static String teamB(String matchID, String sName) =>
      'matches/$matchID/teamBStudents/$sName';
  static String pandingMatchTeamB(String matchID, String sName) =>
      'pendingMatches/$matchID/teamBStudents/$sName';

  static String subjects(String matchID, String subject) =>
      'matches/$matchID/subjects/$subject';
  static String pandingMatchSubjects(String matchID, String subject) =>
      'pendingMatches/$matchID/subjects/$subject';

  static String teamAStudents(String matchID) =>
      'matches/$matchID/teamAStudents/';
  static String teamBStudents(String matchID) =>
      'matches/$matchID/teamBStudents/';
  static String getSubjects(String matchID) => 'matches/$matchID/subjects/';

  static String getPools(String matchID) => '/matches/$matchID/poles';
  static String getSelectedTeam(String uid, String matchID) =>
      '/users/$uid/matches/$matchID';
  static String getTeamData(String uid, String matchID, String teamName) =>
      '/users/$uid/matches/$matchID/teams/$teamName';

  static String joinContest(String uid, String matchID) =>
      'users/$uid/matches/$matchID';
  static String getJoinedPlayer(String matchID, String poolID, String userID) =>
      'matches/$matchID/poles/$poolID/joinedPlayers/$userID';
  static String getJoinedPlayers(String matchID, String poolID) =>
      'matches/$matchID/poles/$poolID/joinedPlayers/';

  static String poolsByMatch(String matchID) => 'matches/$matchID/poles';
  static String addPoolByMatch(String matchID, String poolID) =>
      'matches/$matchID/poles/$poolID';
  static String addPrizeTemplate(String tempName) => 'prizeTemplate/$tempName';
  static String getPrizeTemplate() => 'prizeTemplate/';
}
