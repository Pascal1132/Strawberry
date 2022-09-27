import 'package:flutter/widgets.dart';

class UpdatedCpuInfosEvent {
  final data;
  UpdatedCpuInfosEvent(this.data);
}

class WebSocketConnectionEvent {
  final String message;
  final bool success;
  WebSocketConnectionEvent([this.message = '', this.success = false]);
}

class UpdatedServicesEvent {
  final data;
  UpdatedServicesEvent(this.data);
}

class UpdatedPm2InfosEvent {
  final data;
  UpdatedPm2InfosEvent(this.data);
}

abstract class WSSendMessage {
  final String tag;
  final data;
  WSSendMessage(this.tag, this.data);
}

class RestartPm2ProcessEvent extends WSSendMessage {
  RestartPm2ProcessEvent(String processName)
      : super('restartPm2Process', processName);
}

class ResurrectPm2Event extends WSSendMessage {
  ResurrectPm2Event() : super('resurrectPm2', null);
}

class SavePm2Event extends WSSendMessage {
  SavePm2Event() : super('savePm2', null);
}

class StartPm2ProcessEvent extends WSSendMessage {
  StartPm2ProcessEvent(String processName)
      : super('startPm2Process', processName);
}

class StopPm2ProcessEvent extends WSSendMessage {
  StopPm2ProcessEvent(String processName)
      : super('stopPm2Process', processName);
}

class DeletePm2ProcessEvent extends WSSendMessage {
  DeletePm2ProcessEvent(String processName)
      : super('deletePm2Process', processName);
}

class ServerAddressIpUpdatedEvent {
  final String ip;
  ServerAddressIpUpdatedEvent(this.ip);
}
