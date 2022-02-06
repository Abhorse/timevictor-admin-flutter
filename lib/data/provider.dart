import 'package:flutter/cupertino.dart';

class Data extends ChangeNotifier{
    String uid = '';
    bool isLogged = false;
    String userPhoneNumber = 'NA';

    bool isHomeView = true;
 
    bool isOTPSending = false;

    void toggleHomeView (bool status) {
      isHomeView = status;
      notifyListeners();
    }

    void otpLoadingToggle (bool isLoading) {
        isOTPSending = isLoading;
        notifyListeners();
    }

    void updatePhoneNumber (String verifiedNumber) {
        userPhoneNumber = verifiedNumber;
        notifyListeners();
    }

    void updateUID (String usersUID) {
        uid = usersUID;
        notifyListeners();
    }

    void loggedUser (bool status) {
        isLogged = status;
        notifyListeners();
    }

}