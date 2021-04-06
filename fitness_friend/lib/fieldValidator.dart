class fieldValidator {
  static String validateName(String value) {
    if (value.isEmpty) {
      return 'Name is Required';
    }
    return null;
  }

  static String validateCalories(String value){
    int calories = int.tryParse(value);

    if (calories == null || calories <= 0) {
      return 'Calories must be greater than 0';
    }

    return null;
  }

}