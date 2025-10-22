import 'package:flutter/material.dart';

abstract class LocationServiceEvent {
  LocationServiceEvent();
}

class LocationServiceButtonPressed extends LocationServiceEvent {
  final BuildContext context;

  LocationServiceButtonPressed(this.context);
}
