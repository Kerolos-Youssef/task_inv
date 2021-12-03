import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:task_interview_ky/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());
  static AppCubit get(context) => BlocProvider.of(context);

  var nameController = TextEditingController();
  var birthDateController = TextEditingController();
  late LocationData locationData;

  void getCurrentLocation() async {
    emit(AppGettingLocationLoadingState());
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    Future.delayed(
      Duration(seconds: 3),
    );
    location.getLocation().then((value) {
      locationData = value;
      emit(AppGettingLocationSuccessState());
    }).catchError((error) {
      emit(AppGettingLocationFailedState(error: error.toString()));
    });
  }

  void sendDataToFirebase({
    required String name,
    required String birthdate,
    required LocationData currentLocation,
  }) {
    FirebaseFirestore.instance.collection('userdata').add({
      'name': name,
      'birthdate': birthdate,
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'createAt': Timestamp.now(),
    }).then((value) {
      emit(AppSendingDataSuccessfullyState());
    }).catchError((error) {
      emit(AppSendingDataFailedState(error: error.toString()));
    });
  }

  List<Map<dynamic, dynamic>> data = [];
  void getData() async {
    emit(AppGettingDataLoadingState());
    await FirebaseFirestore.instance
        .collection('userdata')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        data.add({
          'name': doc['name'],
          'birthdate': doc['birthdate'],
          'latitude': doc['latitude'],
          'longitude': doc['longitude'],
          'createAt': doc['createAt'],
        });
      });
      data.sort((a, b) => (a['createAt']).compareTo(b['createAt']));
      emit(AppGettingDataSuccessState());
    }).catchError((error) {
      emit(AppGettingDataErrorState());
    });
  }

  int calcAge(String birthdate) {
    int age;
    age = DateTime.now().year - DateTime.parse(birthdate).year;
    if (DateTime.parse(birthdate).month > DateTime.now().month) {
      age--;
    } else if (DateTime.now().month == DateTime.parse(birthdate).month) {
      if (DateTime.parse(birthdate).day > DateTime.now().day) {
        age--;
      }
    }
    return age;
  }

  var myMarkers = HashSet<Marker>();
  void fillMarkers({
    required MarkerId id,
    required LatLng position,
  }) {
    myMarkers.add(Marker(markerId: id, position: position));
    emit(AppFillingMarkersState());
  }
}
