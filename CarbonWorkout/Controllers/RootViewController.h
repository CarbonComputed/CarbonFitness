//
//  RootViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"



@interface RootViewController : UIViewController

@property (strong,nonatomic) NSMutableDictionary* exerciseDict;
@property (strong,nonatomic) NSMutableDictionary* workoutDict;
@property (strong,nonatomic) NSMutableDictionary* historyDict;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;


@property (strong,nonatomic) Workout* currentWorkout;

-(void) initUser;
-(void) initExercises;
-(void) initWorkouts;
-(void) initHistory;
-(void) saveHistory;
-(void) saveWorkouts;
-(void) saveUser;
@end
