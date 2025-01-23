part of '../pages/pluto_grid_grading_page.dart';

class _HeaderSection extends StatefulWidget {
  const _HeaderSection();

  @override
  State<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<_HeaderSection> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const widthSpacing = SizedBox(width: 8);
    const heightSpacing = SizedBox(height: 8);
    return BlocListener<SaveResultBloc, SaveResultState>(
      listenWhen: (p, c) => c is ValidateResultState,
      listener: (context, state) {
        if ((state as ValidateResultState).status is RequestSuccess) {
          if (formKey.currentState!.validate()) {
            final tab = context.read<ResultTabBloc>().state.getCurrentTab!;
            if (state.savedResultStates.containsKey(tab)) {
              context.read<SaveResultBloc>().add(UpdateEditedResultEvent(
                    editState: context.read<EditResultBloc>().state,
                    tab: tab,
                  ));
            } else {
              context.read<SaveResultBloc>().add(SaveEditedResultEvent(
                    editState: context.read<EditResultBloc>().state,
                    tab: tab,
                  ));
            }
          }
        }
      },
      child: Padding(
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 9.5,
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: BlocSelector<EditResultBloc, EditResultState,
                          TextEditingController>(
                        selector: (state) => state.courseTitleTEC,
                        builder: (context, tec) {
                          return HeaderTitleTextField(
                            labelText: "Course Title",
                            controller: tec,
                          );
                        },
                      ),
                    ),
                    widthSpacing,
                    Flexible(
                      flex: 3,
                      child: BlocSelector<EditResultBloc, EditResultState,
                          TextEditingController>(
                        selector: (state) => state.courseCodeTEC,
                        builder: (context, tec) {
                          return HeaderTitleTextField(
                            labelText: "Course Code",
                            controller: tec,
                          );
                        },
                      ),
                    ),
                    widthSpacing,
                    Flexible(
                      flex: 2,
                      child: BlocSelector<EditResultBloc, EditResultState,
                          TextEditingController>(
                        selector: (state) => state.unitsTEC,
                        builder: (context, tec) {
                          return HeaderTitleTextField(
                            labelText: "Units",
                            controller: tec,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value?.isEmpty ?? true) return '';
                              if (int.tryParse(value!) == null) return '';
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                heightSpacing,
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: BlocSelector<EditResultBloc, EditResultState,
                          TextEditingController>(
                        selector: (state) => state.departmentTEC,
                        builder: (context, tec) {
                          return HeaderTitleTextField(
                            labelText: "Department",
                            controller: tec,
                          );
                        },
                      ),
                    ),
                    widthSpacing,
                    Flexible(
                      flex: 3,
                      child: BlocSelector<EditResultBloc, EditResultState,
                          TextEditingController>(
                        selector: (state) => state.semesterTEC,
                        builder: (context, tec) {
                          return DropdownButtonFormField2(
                            value: tec.text,
                            key: ValueKey(tec),
                            items: const [
                              DropdownMenuItem(
                                value: 'First',
                                child: Text('First'),
                              ),
                              DropdownMenuItem(
                                value: 'Second',
                                child: Text('Second'),
                              ),
                            ],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 32,
                              padding: EdgeInsets.only(left: 12),
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Semester',
                              errorStyle: TextStyle(fontSize: 0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 6),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return '';
                              return null;
                            },
                            onChanged: (value) => tec.text = value ?? '',
                          );
                        },
                      ),
                    ),
                    widthSpacing,
                    Flexible(
                      flex: 2,
                      child: BlocSelector<EditResultBloc, EditResultState,
                          TextEditingController>(
                        selector: (state) => state.sessionTEC,
                        builder: (context, tec) {
                          return HeaderTitleTextField(
                            labelText: "Session",
                            hintText: 'Eg: 2023-2024',
                            controller: tec,
                            validator: (value) {
                              if (!RegExp(r"^\d{4}-\d{4}$").hasMatch(value!)) {
                                return '';
                              } else {
                                if (value.split('-').fold(0, (p, e) {
                                      return int.parse(e) - p;
                                    }) !=
                                    1) {
                                  return '';
                                }
                              }

                              return null;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
