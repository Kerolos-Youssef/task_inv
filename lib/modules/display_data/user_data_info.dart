import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_interview_ky/cubit/cubit.dart';
import 'package:task_interview_ky/cubit/states.dart';

class UserDataInfo extends StatelessWidget {
  const UserDataInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppCubit.get(context).getData();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'User Data',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.w800,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
          body: Center(
            child: state is! AppGettingDataLoadingState
                ? Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: width * 0.05,
                      end: width * 0.05,
                      top: height * 0.03,
                      bottom: height * 0.03,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your Name is: ${AppCubit.get(context).data[(AppCubit.get(context).data.length - 1)]['name']}',
                          style: TextStyle(
                            fontSize: width * 0.07,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          'Your Age is: ${AppCubit.get(context).calcAge(AppCubit.get(context).data[(AppCubit.get(context).data.length - 1)]['birthdate']).toString()}',
                          style: TextStyle(
                            fontSize: width * 0.07,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          'Your Address is',
                          style: TextStyle(
                            fontSize: width * 0.07,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Expanded(
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController mapController) {
                              AppCubit.get(context).fillMarkers(
                                id: MarkerId(AppCubit.get(context).data[
                                        (AppCubit.get(context).data.length - 1)]
                                    ['name']),
                                position: LatLng(
                                  AppCubit.get(context).data[
                                      (AppCubit.get(context).data.length -
                                          1)]['latitude'],
                                  AppCubit.get(context).data[
                                      (AppCubit.get(context).data.length -
                                          1)]['longitude'],
                                ),
                              );
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                AppCubit.get(context).data[
                                        (AppCubit.get(context).data.length - 1)]
                                    ['latitude'],
                                AppCubit.get(context).data[
                                        (AppCubit.get(context).data.length - 1)]
                                    ['longitude'],
                              ),
                              zoom: 15,
                            ),
                            markers: AppCubit.get(context).myMarkers,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SpinKitWave(
                    color: Colors.blue,
                  ),
          ),
        );
      },
    );
  }
}
