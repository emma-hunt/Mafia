import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArgs.dart';

class SoloMafiaRoleArgs extends MafiaRoleArgs{
  // nothing to add yet... might not need to add anything?
  SoloMafiaRoleArgs(MafiaRoleArgs args) {
    super.gameId = args.gameId;
    super.personId = args.personId;
  }
}