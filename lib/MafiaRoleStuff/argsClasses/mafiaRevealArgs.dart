import 'package:flutter/material.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/soloMafiaRoleArgs.dart';

class MafiaRevealArgs {
  int roleNum;
  String gameId;
  String personId;
  MafiaRevealArgs(SoloMafiaRoleArgs args, int cardNum) {
    this.roleNum = cardNum;
    this.gameId = args.gameId;
    this.personId = args.personId;
  }
}