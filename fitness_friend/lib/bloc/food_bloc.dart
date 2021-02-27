import 'package:fitnessfriend/Events/add_food.dart';
import 'package:fitnessfriend/Events/delete_food.dart';
import 'package:fitnessfriend/Events/food_event.dart';
import 'package:fitnessfriend/Events/set_foods.dart';
import 'package:fitnessfriend/Events/update_food.dart';
import 'package:fitnessfriend/model/Food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class FoodBloc extends Bloc<FoodEvent, List<Food>> {

  @override
  List<Food> get initialState => List<Food>();

  @override
  Stream<List<Food>> mapEventToState(FoodEvent event) async* {
    if (event is SetFoods) {
      yield event.foodList;
    } else if (event is AddFood) {
      List<Food> newState = List.from(state);
      if (event.newFood != null) {
        newState.add(event.newFood);
      }
      yield newState;
    } else if (event is DeleteFood) {
      List<Food> newState = List.from(state);
      newState.removeAt(event.foodIndex);
      yield newState;
    } else if (event is UpdateFood) {
      List<Food> newState = List.from(state);
      newState[event.foodIndex] = event.newFood;
      yield newState;
    }
  }
}
