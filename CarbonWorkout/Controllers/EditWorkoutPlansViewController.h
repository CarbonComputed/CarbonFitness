//
//  EditWorkoutPlansViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutPlan.h"
#import "ExerciseListViewController.h"

@interface EditWorkoutPlansViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,ExerciseListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *editRoutinesTableView;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak) WorkoutPlan* workoutPlan;


@end
