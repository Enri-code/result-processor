part of '../pages/pluto_grid_grading_page.dart';

// class _TitleTextField0 extends StatelessWidget {
//   const _TitleTextField0({
//     this.controller,
//     required this.labelText,
//     this.inputFormatters,
//   });

//   final TextEditingController? controller;
//   final String labelText;
//   final List<TextInputFormatter>? inputFormatters;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 4),
//           child: Text(labelText),
//         ),
//         TextField(controller: controller, inputFormatters: inputFormatters),
//       ],
//     );
//   }
// }

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    const widthSpacing = SizedBox(width: 10);
    const heightSpacing = SizedBox(height: 10);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                bodyLarge: const TextStyle(fontSize: 12, color: Colors.black),
              ),
          inputDecorationTheme: const InputDecorationTheme(
            isDense: true,
            filled: true,
            fillColor: AppColor.lightGrey1,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.lightGrey3),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: BlocSelector<EditResultBloc, EditResultState,
                      TextEditingController>(
                    selector: (state) => state.courseTitleTEC,
                    builder: (context, tec) {
                      return _TitleTextField(
                        labelText: "Course Title",
                        controller: tec,
                      );
                    },
                  ),
                ),
                widthSpacing,
                Flexible(
                  child: BlocSelector<EditResultBloc, EditResultState,
                      TextEditingController>(
                    selector: (state) => state.courseCodeTEC,
                    builder: (context, tec) {
                      return _TitleTextField(
                        labelText: "Course Code",
                        controller: tec,
                      );
                    },
                  ),
                ),
                widthSpacing,
                Flexible(
                  child: BlocSelector<EditResultBloc, EditResultState,
                      TextEditingController>(
                    selector: (state) => state.unitsTEC,
                    builder: (context, tec) {
                      return _TitleTextField(
                        labelText: "Units",
                        controller: tec,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            heightSpacing,
            Row(
              children: List.of([
                Flexible(
                  flex: 2,
                  child: BlocSelector<EditResultBloc, EditResultState,
                      TextEditingController>(
                    selector: (state) => state.lecturerTEC,
                    builder: (context, tec) {
                      return _TitleTextField(
                        labelText: "Lecturer",
                        controller: tec,
                      );
                    },
                  ),
                ),
                widthSpacing,
                Flexible(
                  child: BlocSelector<EditResultBloc, EditResultState,
                      TextEditingController>(
                    selector: (state) => state.semesterTEC,
                    builder: (context, tec) {
                      return _TitleTextField(
                        labelText: "Semester",
                        controller: tec,
                      );
                    },
                  ),
                ),
                widthSpacing,
                Flexible(
                  child: BlocSelector<EditResultBloc, EditResultState,
                      TextEditingController>(
                    selector: (state) => state.sessiomTEC,
                    builder: (context, tec) {
                      return _TitleTextField(
                        labelText: "Session",
                        controller: tec,
                      );
                    },
                  ),
                ),
              ],growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleTextField extends StatelessWidget {
  const _TitleTextField({
    this.controller,
    required this.labelText,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String labelText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

// class _HeaderSection0 extends StatelessWidget {
//   const _HeaderSection0();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           textTheme: Theme.of(context).textTheme.copyWith(
//                 bodyLarge: const TextStyle(fontSize: 13, color: Colors.black),
//               ),
//           inputDecorationTheme: const InputDecorationTheme(
//             isDense: true,
//             filled: true,
//             fillColor: AppColor.lightGrey1,
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(4)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: AppColor.lightGrey3),
//               borderRadius: BorderRadius.all(Radius.circular(6)),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//           ),
//         ),
//         child: DefaultTextStyle(
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//             fontSize: 10,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: BlocBuilder<EditResultBloc, EditResultState>(
//                   builder: (context, state) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Wrap(
//                           spacing: 16,
//                           runSpacing: 8,
//                           children: [
//                             SizedBox(
//                               width: 250,
//                               child: _TitleTextField0(
//                                 labelText: "Course Title",
//                                 controller: state.courseTitleTEC,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 120,
//                               child: _TitleTextField0(
//                                 controller: state.courseCodeTEC,
//                                 labelText: "Course Code",
//                               ),
//                             ),
//                             SizedBox(
//                               width: 80,
//                               child: _TitleTextField0(
//                                 controller: state.unitsTEC,
//                                 labelText: "Units",
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Wrap(
//                           spacing: 16,
//                           runSpacing: 8,
//                           children: [
//                             SizedBox(
//                               width: 120,
//                               child: _TitleTextField0(
//                                 controller: state.semesterTEC,
//                                 labelText: "Semester",
//                               ),
//                             ),
//                             SizedBox(
//                               width: 150,
//                               child: _TitleTextField0(
//                                 controller: state.sessiomTEC,
//                                 labelText: "Session",
//                               ),
//                             ),
//                             SizedBox(
//                               width: 300,
//                               child: _TitleTextField0(
//                                 controller: state.lecturerTEC,
//                                 labelText: "Lecturer",
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
