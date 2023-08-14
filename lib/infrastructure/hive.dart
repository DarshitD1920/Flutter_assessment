import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Employee extends HiveObject {
  @HiveField(0)
  String empName;

  @HiveField(1)
  String selectedRole;

  @HiveField(2)
  String startDate;

  @HiveField(3)
  String endDate;

  Employee(this.empName, this.selectedRole, this.startDate, this.endDate);
}

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final typeId = 1;

  @override
  Employee read(BinaryReader reader) {
    return Employee(
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer.writeString(obj.empName);
    writer.writeString(obj.selectedRole);
    writer.writeString(obj.startDate);
    writer.writeString(obj.endDate);
  }
}
