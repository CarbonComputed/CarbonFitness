//
//  WorkoutPlan.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Exercise.h"

@interface WorkoutPlan : NSObject <NSCopying>

@property NSInteger wid;
@property NSString* name;
@property NSString* description;
@property NSMutableArray* workoutPlanRoutines;

- (id)initWithAttributes:(NSDictionary*) attributes withExerciseDictionary:(NSDictionary*)exerciseDict;
-(id)copyWithZone:(NSZone *)zone;
- (NSDictionary *)dictionaryFromData;

@end
