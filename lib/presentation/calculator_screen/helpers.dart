import 'package:protein_tracker/domain/calculator/activity.dart';
import 'package:protein_tracker/domain/calculator/protein_goal.dart';

import '../../utils/localization_utils.dart';
import 'package:flutter/material.dart';

String getDropDownActivityText(Activity activity, BuildContext context) {
  switch (activity) {
    case Activity.none:
      {
        return '';
      }
    case Activity.sedentary:
      {
        return translatedText(
          "calculator_dropDownValue_activity_sedentary",
          context,
        );
      }
    case Activity.moderate:
      {
        return translatedText(
          "calculator_dropDownValue_activity_moderate",
          context,
        );
      }
    case Activity.active:
      {
        return translatedText(
          "calculator_dropDownValue_activity_active",
          context,
        );
      }

      break;
    default:
  }
}

String getDropDownProteinGoalText(ProteinGoal goal, BuildContext context) {
  switch (goal) {
    case ProteinGoal.none:
      {
        return '';
      }
    case ProteinGoal.maintenance:
      {
        return translatedText(
          "calculator_dropDownValue_activity_maintenance",
          context,
        );
      }
    case ProteinGoal.muscleGain:
      {
        return translatedText(
          "calculator_dropDownValue_activity_muscle_gain",
          context,
        );
      }
    case ProteinGoal.fatLoss:
      {
        return translatedText(
          "calculator_dropDownValue_activity_fat_loss",
          context,
        );
      }

      break;
    default:
  }
}
