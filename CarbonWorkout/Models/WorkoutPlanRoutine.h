//
//  WorkoutPlanRoutine.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/22/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

enum Day {S=1,M,T,W,R,F,SA};


@interface WorkoutPlanRoutine : NSObject

@property int sets;
@property int startingReps;
@property int startingWeight;
@property int endingReps;
@property int endingWeight;

@property int max;
@property int incrementType;

@property Exercise* exercise;

@property NSMutableSet* days;

-(id)initWithExercise:(Exercise*)exercise;
-(id) initWithAttributes:(NSDictionary*) attributes withExercise:(Exercise*)exercise;
- (NSDictionary *)dictionaryFromData;
-(id)copyWithZone:(NSZone *)zone;

@end
