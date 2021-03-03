import 'package:protein_tracker/utils/enums.dart';

class ProteinCalculatorService {
  static int calculateProtein(
      {Activity activityValue,
      ProteinGoal proteinGoalValue,
      FemaleStatus femaleStatusValue,
      double weight,
      bool currentWeightSettings}) {
    double proteinAmount = 0;
    int result;

    switch (activityValue) {
      case Activity.sedentary:
        {
          switch (proteinGoalValue) {
            case ProteinGoal.maintenance:
              {
                proteinAmount = 1.2;
              }
              break;
            case ProteinGoal.muscleGain:
              {
                proteinAmount = 1.4;
              }
              break;
            case ProteinGoal.fatLoss:
              {
                proteinAmount = 1.2;
              }
              break;

              break;
            default:
          }
        }
        break;
      case Activity.moderate:
        {
          switch (proteinGoalValue) {
            case ProteinGoal.maintenance:
              {
                proteinAmount = 1.4;
              }
              break;
            case ProteinGoal.muscleGain:
              {
                proteinAmount = 2;
              }
              break;
            case ProteinGoal.fatLoss:
              {
                proteinAmount = 1.3;
              }
              break;

            default:
          }
        }
        break;
      case Activity.active:
        {
          switch (proteinGoalValue) {
            case ProteinGoal.maintenance:
              {
                proteinAmount = 1.6;
              }
              break;
            case ProteinGoal.muscleGain:
              {
                proteinAmount = 2.7;
              }
              break;
            case ProteinGoal.fatLoss:
              {
                proteinAmount = 1.4;
              }
              break;
            default:
          }
        }
        break;
      default:
    }
    if (femaleStatusValue != FemaleStatus.none) {
      switch (femaleStatusValue) {
        case FemaleStatus.pregnant:
          {
            proteinAmount = 1.8;
          }
          break;
        case FemaleStatus.lactanting:
          {
            proteinAmount = 1.5;
          }
          break;

          break;
        default:
      }
    }
    //calculate protein intake
    result = (proteinAmount * weight).round();

    //convert lbs to kgs
    if (currentWeightSettings == false) {
      result = (result * .45359237).round();
    }
    return result;
  }
}
