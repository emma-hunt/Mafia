import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArgs.dart';

class SoloMafiaRoleArgs {
  String gameId;
  String personId;

  SoloMafiaRoleArgs(MafiaRoleArgs args) {
    this.gameId = args.gameId;
    this.personId = args.personId;
  }
}