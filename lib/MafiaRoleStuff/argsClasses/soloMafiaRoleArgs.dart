import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArgs.dart';

class SoloMafiaRoleArgs {
  String gameId;
  String personName;

  SoloMafiaRoleArgs(MafiaRoleArgs args) {
    this.gameId = args.gameId;
    this.personName = args.personName;
  }
}