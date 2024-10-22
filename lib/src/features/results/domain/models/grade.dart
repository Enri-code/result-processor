class Grade {
  final int id;
  final int resultId;
  final String fullName, regNo;
  final int? ca, test, exam;

  Grade({
    required this.id,
    required this.resultId,
    this.fullName = '',
    this.regNo = '',
    this.ca,
    this.test,
    this.exam,
  });
}
