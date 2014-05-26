//
//  routinesViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Workout.h"
#import "WorkoutPlan.h"

@interface RoutinesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *routinesTableView;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTimerLabel;

@property (strong,atomic) NSTimer* workoutTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (weak, nonatomic) IBOutlet UIProgressView *exerciseProgress;

//@property (weak,nonatomic) WorkoutPlan* workoutPlan;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *workoutCompleteLabel;

@property (weak,nonatomic) Workout* currentWorkout;

@property int numWorkoutsCompleted;
@property (weak, nonatomic) IBOutlet UIImageView *progressImage;

@property NSMutableDictionary* displayList;

@property BOOL fromHistory;


@end
