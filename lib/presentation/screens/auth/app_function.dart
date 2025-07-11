
class AppFunction{
 static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

 static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

 static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    } else if (!RegExp(r'^\d{9,15}$').hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

 static String? validateNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return "National ID is required";
    } else if (!RegExp(r'^\d{14}$').hasMatch(value)) {
      return "National ID must be 14 digits";
    }
    return null;
  }

 static String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }
}




