//
//  Workout.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkoutPlan.h"

@interface Workout : NSObject
@property NSDate* startDate;
@property NSDate* endDate; //For time
@property int myWeight;
@property NSMutableArray* routines;

@property WorkoutPlan* currentPlan;

@property int timeSec;
@property int timeMin;
@property int timeHour;

@property BOOL isCompleted;

- (NSDictionary *)dictionaryFromData;

-(id)initWithAttributes:(NSDictionary*) attributes withExerciseDictionary:(NSDictionary*)exerciseDict;
-(id)initWithWorkoutPlan:(WorkoutPlan*)wplan;
+(Workout*) loadWorkout:(NSDictionary*)dict withWorkoutPlan:(WorkoutPlan*)wplan;


@end
