//
//  ExerciseViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/9/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Workout.h"
#import "Routine.h"
#import "SetView.h"



@interface RoutineViewController : UIViewController<SetViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTimeCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToImageCon;
@property (weak, nonatomic) IBOutlet UILabel *popdownLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToLayout;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@property (weak, nonatomic) IBOutlet UIView *viewHolder;
@property (strong, nonatomic) SetView *setView;


@property (strong,nonatomic) Routine* routine;
@property Workout* currentWorkout;

@property (weak, nonatomic) IBOutlet UILabel *setTimerLabel;
@property (strong,atomic) NSTimer* setTimer;


@property int totalNotDelay;

@property BOOL popdownHidden;
@property BOOL fromHistory;


@end
