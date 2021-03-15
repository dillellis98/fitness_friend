import 'package:fitnessfriend/model/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseListTile extends StatelessWidget {
  final Exercise exercise;
  final bool isSelected;
  final ValueChanged<Exercise> onSelectedExercise;

  const ExerciseListTile({
    Key key,
    @required this.exercise,
    @required this.isSelected,
    @required this.onSelectedExercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final style = isSelected
        ? TextStyle(
      fontSize: 18,
      color: selectedColor,
      fontWeight: FontWeight.bold,
    )
        : TextStyle(fontSize: 18);

    return ListTile(
      onTap: () => onSelectedExercise(exercise),
      title: Text(
        exercise.exerciseName,
      ),
      trailing:
      isSelected ? Icon(Icons.check, color: selectedColor, size: 26) : null,
    );
  }
}