import 'package:fitnessfriend/fieldValidator.dart';
import 'package:fitnessfriend/foodForm.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('Empty name test', () {
    var result = fieldValidator.validateName('');
    expect(result, 'Name is Required');
  });

  test('Calorie input test', () {
    var result = fieldValidator.validateCalories('');
    expect(result, 'Calories must be greater than 0');
  });


}