part of 'edit_result_bloc.dart';

class EditResultState extends Equatable {
  EditResultState({
    this.modifyGridEvent,
    this.rows = const [],
    this.status,
    TextEditingController? courseTitleTEC,
    TextEditingController? courseCodeTEC,
    TextEditingController? semesterTEC,
    TextEditingController? sessionTEC,
    TextEditingController? unitsTEC,
    TextEditingController? departmentTEC,
  })  : courseTitleTEC = courseTitleTEC ?? TextEditingController(),
        courseCodeTEC = courseCodeTEC ?? TextEditingController(),
        unitsTEC = unitsTEC ?? TextEditingController(),
        semesterTEC = semesterTEC ?? TextEditingController(),
        sessionTEC = sessionTEC ?? TextEditingController(),
        departmentTEC = departmentTEC ?? TextEditingController();

  final TextEditingController courseTitleTEC,
      courseCodeTEC,
      unitsTEC,
      semesterTEC,
      sessionTEC,
      departmentTEC;

  final List<PlutoRow> rows;
  final ModifyGridEvent? modifyGridEvent;
  final RequestStatus? status;

  EditResultState copyWith({
    List<PlutoRow>? rows,
    ModifyGridEvent? event,
    RequestStatus? status,
  }) {
    return EditResultState(
      rows: rows ?? this.rows,
      status: status ?? this.status,
      modifyGridEvent: event,
      courseTitleTEC: courseTitleTEC,
      courseCodeTEC: courseCodeTEC,
      unitsTEC: unitsTEC,
      semesterTEC: semesterTEC,
      sessionTEC: sessionTEC,
      departmentTEC: departmentTEC,
    );
  }

  @override
  List<Object?> get props => [
        courseTitleTEC,
        courseCodeTEC,
        unitsTEC,
        semesterTEC,
        sessionTEC,
        departmentTEC,
        rows,
        status,
        modifyGridEvent,
      ];

  /// Dispose this State Class properties when the state is no longer used
  void dispose() {
    courseTitleTEC.dispose();
    courseCodeTEC.dispose();
    unitsTEC.dispose();
    semesterTEC.dispose();
    sessionTEC.dispose();
    departmentTEC.dispose();
  }
}
