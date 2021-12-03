abstract class AppStates {}

class AppIntialState extends AppStates {}

class AppGettingLocationLoadingState extends AppStates {}

class AppGettingLocationSuccessState extends AppStates {}

class AppGettingLocationFailedState extends AppStates {
  final String? error;
  AppGettingLocationFailedState({this.error});
}

class AppSendingDataSuccessfullyState extends AppStates {}

class AppSendingDataFailedState extends AppStates {
  final String? error;
  AppSendingDataFailedState({this.error});
}

class AppGettingDataLoadingState extends AppStates {}

class AppGettingDataSuccessState extends AppStates {}

class AppGettingDataErrorState extends AppStates {
  final String? error;
  AppGettingDataErrorState({this.error});
}

class AppFillingMarkersState extends AppStates {}
