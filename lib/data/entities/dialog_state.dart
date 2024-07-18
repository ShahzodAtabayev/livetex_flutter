import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/entities/employee.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class DialogState extends BaseEntity {
  DialogStatus status;
  EmployeeStatus employeeStatus;
  Employee? employee;
  bool showInput;

  DialogState({
    this.status = DialogStatus.UNASSIGNED,
    this.employeeStatus = EmployeeStatus.OFFLINE,
    this.employee,
    this.showInput = true,
  });

  bool canShowInput() {
    return showInput;
  }

  factory DialogState.fromJson(Map<String, dynamic> json) {
    DialogStatus dialogStatus = DialogStatus.UNASSIGNED;
    EmployeeStatus employeeStatus = EmployeeStatus.OFFLINE;
    try {
      dialogStatus = DialogStatus.values.byName(json['status']);
    } catch (_) {}
    return DialogState(
      status: dialogStatus,
      employeeStatus: employeeStatus,
      showInput: json['showInput'] ?? true,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'employeeStatus': employeeStatus.name,
      'employee': employee?.toJson(),
      'showInput': showInput,
    };
  }

  @override
  ChatEventType get type => ChatEventType.state;
}

enum DialogStatus {
  UNASSIGNED,
  QUEUE,
  ASSIGNED,
  BOT,
}

enum EmployeeStatus {
  ONLINE,
  OFFLINE,
}
