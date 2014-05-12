//
//  Routine.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/9/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"
#import "WorkoutPlanRoutine.h"
#import "SetTrack.h"


enum Unit {lbs,kg};



@interface Routine : NSObject

@property WorkoutPlanRoutine* workoutPlanRoutine;
@property SetTrack* setTrack;
@property BOOL didComplete;


-(id) initWithAttributes:(NSDictionary*)attributes withWorkoutPlanRoutine:(WorkoutPlanRoutine*)wpr;
-(id) initWithWorkoutPlanRoutine:(WorkoutPlanRoutine*)wpr;
//-(id) initWithAttributes:(NSDictionary*) attributes andExercise:(Exercise*)exercise;
-(id)copyWithZone:(NSZone *)zone;
- (NSDictionary *)dictionaryFromData;

-(int)completedRoutine;
-(void)incrementWeight;


@end
