library mafia.session;
// README!! when adding a field it needs to be initialized... not sure why, but won't work otherwise.

String playerName = '';
String gameID = '';
String playerID = '';
bool isOwner = false;
List<dynamic> playerList = [];
List<dynamic> allRoles = [];

void resetSession() {
  playerName = '';
  gameID = '';
  playerID = '';
  isOwner = false;
  playerList = [];
  allRoles = [];
}