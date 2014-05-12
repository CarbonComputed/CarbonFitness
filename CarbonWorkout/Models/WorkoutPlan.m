//
//  WorkoutPlan.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "WorkoutPlan.h"
#import "WorkoutPlanRoutine.h"

@implementation WorkoutPlan

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

        if(!_name){
            _name = @"";
        }
        if(!_description){
            _description = @"";
        }
        _workoutPlanRoutines = [NSMutableArray new];
    }
    return self;
}

- (id)initWithAttributes:(NSDictionary*) attributes withExerciseDictionary:(NSDictionary*)exerciseDict
{
    self = [super init];
    if (self) {
        // Custom initialization
        _wid = [[attributes objectForKey:@"wid"] intValue];
        _name = [attributes objectForKey:@"name"];
        if(!_name){
            _name = @"";
        }
        _description = [attributes objectForKey:@"description"];
        if(!_description){
            _description = @"";
        }
        _workoutPlanRoutines = [NSMutableArray new];
        NSArray* wprArray = [attributes objectForKey:@"workoutRoutines"];
        for(NSDictionary* wprAtt in wprArray){
            int eid = [[wprAtt objectForKey:@"eid"] intValue];
            Exercise* exercise = [exerciseDict objectForKey:@(eid)];
            WorkoutPlanRoutine* wpr = [[WorkoutPlanRoutine alloc] initWithAttributes:wprAtt withExercise:exercise];
            [_workoutPlanRoutines addObject:wpr];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryFromData{
    NSMutableArray *routineData = [NSMutableArray new];
    for(WorkoutPlanRoutine* r in _workoutPlanRoutines){
        [routineData addObject:[r dictionaryFromData]];
    }
    NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:@(_wid),@"wid",_name,@"name",_description,@"description",routineData,@"workoutRoutines",nil];
    return d;
}

-(id)copyWithZone:(NSZone *)zone
{
    WorkoutPlan *another = [[WorkoutPlan alloc] init];
    another.name = _name;
    another.description = _description;
    another.wid = _wid;
    another.workoutPlanRoutines = nil;
    another.workoutPlanRoutines = [NSMutableArray new];
    another.workoutPlanRoutines = [[NSMutableArray alloc] initWithArray:_workoutPlanRoutines copyItems:YES];;
    return another;
}

@end
