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
