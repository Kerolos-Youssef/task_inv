import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_interview_ky/cubit/cubit.dart';
import 'package:task_interview_ky/cubit/states.dart';
import 'package:task_interview_ky/modules/display_data/user_data_info.dart';
import 'package:task_interview_ky/shared/components/custom_text_input_field.dart';
import 'package:task_interview_ky/shared/components/row_input_item.dart';

var formKey = GlobalKey<FormState>();

class UserInputScreen extends StatelessWidget {
  const UserInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Task with firebase',
                style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: width * 0.05,
                  end: width * 0.05,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RowInputItem(
                        labelTitle: 'Name:',
                        inputField: CustomTextInputField(
                          controller: AppCubit.get(context).nameController,
                          keyboardType: TextInputType.text,
                          hintText: 'name',
                          maxLines: 1,
                          borderRadius: 0.03,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            } else {
                              return null;
                            }
                          },
                          //autoValidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      RowInputItem(
                        labelTitle: 'Birth Date:',
                        inputField: CustomTextInputField(
                          controller: AppCubit.get(context).birthDateController,
                          hintText: 'DD/MM/YYYY',
                          borderRadius: 0.03,
                          keyboardType: TextInputType.datetime,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1921),
                              lastDate: DateTime.now(),
                            ).then((value) {
                              AppCubit.get(context).birthDateController.text =
                                  DateFormat("yyyy-MM-dd").format(value!);
                            });
                          },
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Birth Date must not be empty';
                            } else {
                              return null;
                            }
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.only(end: width * 0.03),
                            child: Text(
                              'Address:',
                              style: TextStyle(
                                fontSize: width * 0.085,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              AppCubit.get(context).getCurrentLocation();
                            },
                            child: state is! AppGettingLocationLoadingState
                                ? const Text('Locat me')
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.06),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            AppCubit.get(context).sendDataToFirebase(
                              name: AppCubit.get(context).nameController.text,
                              birthdate: AppCubit.get(context)
                                  .birthDateController
                                  .text,
                              currentLocation:
                                  AppCubit.get(context).locationData,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const UserDataInfo(),
                              ),
                            );
                          }
                          AppCubit.get(context).nameController.clear();
                          AppCubit.get(context).birthDateController.clear();
                        },
                        child: Text('Submit'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.06),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
