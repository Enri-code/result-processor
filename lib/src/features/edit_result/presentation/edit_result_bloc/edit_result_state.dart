part of 'edit_result_bloc.dart';

class EditResultState extends Equatable {
  EditResultState({
    this.modifyGridEvent,
    this.rows = const [],
    TextEditingController? courseTitleTEC,
    TextEditingController? courseCodeTEC,
    TextEditingController? unitsTEC,
    TextEditingController? semesterTEC,
    TextEditingController? sessiomTEC,
    TextEditingController? lecturerTEC,
  })  : courseTitleTEC = courseTitleTEC ?? TextEditingController(),
        courseCodeTEC = courseCodeTEC ?? TextEditingController(),
        unitsTEC = unitsTEC ?? TextEditingController(),
        semesterTEC = semesterTEC ?? TextEditingController(),
        sessiomTEC = sessiomTEC ?? TextEditingController(),
        lecturerTEC = lecturerTEC ?? TextEditingController();

  final TextEditingController courseTitleTEC,
      courseCodeTEC,
      unitsTEC,
      semesterTEC,
      sessiomTEC,
      lecturerTEC;

  final List<PlutoRow> rows;
  final ModifyGridEvent? modifyGridEvent;

  EditResultState copyWith({List<PlutoRow>? rows, ModifyGridEvent? event}) {
    return EditResultState(
      rows: rows ?? this.rows,
      modifyGridEvent: event,
      courseTitleTEC: courseTitleTEC,
      courseCodeTEC: courseCodeTEC,
      unitsTEC: unitsTEC,
      semesterTEC: semesterTEC,
      sessiomTEC: sessiomTEC,
      lecturerTEC: lecturerTEC,
    );
  }

  @override
  List<Object?> get props => [
        courseTitleTEC,
        courseCodeTEC,
        unitsTEC,
        semesterTEC,
        sessiomTEC,
        lecturerTEC,
        rows,
        modifyGridEvent,
      ];

  /// Dispose this State Class properties when the state is no longer used
  void dispose() {
    courseTitleTEC.dispose();
    courseCodeTEC.dispose();
    unitsTEC.dispose();
    semesterTEC.dispose();
    sessiomTEC.dispose();
    lecturerTEC.dispose();
  }
}
