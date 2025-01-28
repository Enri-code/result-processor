part of '../pages/pluto_grid_grading_page.dart';

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return MultiBlocListener(
      listeners: [
        BlocListener<SaveResultBloc, SaveResultState>(
          listenWhen: (p, c) => c is ResultValidateState,
          listener: (context, state) {
            if ((state as ResultValidateState).status is RequestLoading) {
              if (formKey.currentState!.validate()) {
                context.read<SaveResultBloc>().add(
                      const ValidateResultEvent(RequestSuccess()),
                    );
                final tab = context.read<ResultTabBloc>().state.getCurrentTab!;
                if (tab is SavedResultTab) {
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
              } else {
                context.read<SaveResultBloc>().add(
                      const ValidateResultEvent(RequestError()),
                    );
              }
            }
          },
        ),
        BlocListener<SaveResultBloc, SaveResultState>(
          listener: (context, state) {
            if (state is ResultDeleteState && state.status is RequestSuccess) {
              context.read<ResultTabBloc>().add(const CloseResultTabEvent());
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodyLarge: const TextStyle(fontSize: 12, color: Colors.black),
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
                            key: ValueKey(tec),
                            labelText: "Course Title",
                            hintText: 'Eg: Project Report',
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
                            key: ValueKey(tec),
                            labelText: "Course Code",
                            hintText: 'Eg: COS 409',
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
                            key: ValueKey(tec),
                            labelText: "Units",
                            hintText: 'Eg: 3',
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
                            key: ValueKey(tec),
                            labelText: "Department",
                            hintText: 'Eg: Computer Science',
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
                          return SemesterFormField(
                            key: ValueKey(tec),
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
                        selector: (state) => state.sessionTEC,
                        builder: (context, tec) {
                          return HeaderTitleTextField(
                            key: ValueKey(tec),
                            labelText: "Session",
                            hintText: 'Eg: 2023-2024',
                            controller: tec,
                            validator: sessionTFValidator,
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
