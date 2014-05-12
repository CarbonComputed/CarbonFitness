//
//  EditRoutinesViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutPlanRoutine.h"
#import "WLHorizontalSegmentedControl.h"
#import "AdvancedSetView.h"

@interface EditRoutinesViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet WLHorizontalSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property WorkoutPlanRoutine* currentRoutine;
@property (weak, nonatomic) IBOutlet UISegmentedControl *incrementControl;

@property (weak, nonatomic) IBOutlet UILabel *exerciseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *exerciseDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UITextField *setsField;
@property (weak, nonatomic) IBOutlet UITextField *repsField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property (weak, nonatomic) IBOutlet AdvancedSetView *reps_weightView;
@property (weak, nonatomic) IBOutlet AdvancedSetView *reffedView;
@property AdvancedSetView* advancedView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
