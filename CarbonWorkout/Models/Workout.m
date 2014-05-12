//
//  Workout.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "Workout.h"
#import "Routine.h"

@implementation Workout
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _startDate = [NSDate date];
        _endDate = [NSDate date];
        _isCompleted = false;
        _routines = [NSMutableArray new];
    }
    return self;
}

- (id)initWithAttributes:(NSDictionary*) attributes withExerciseDictionary:(NSDictionary*)exerciseDict {
    self = [super init];
    if (self) {
        NSString* startDate = [attributes objectForKey:@"startDate"];
        NSString* endDate = [attributes objectForKey:@"endDate"];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aaa"];
        _startDate = [dateFormat dateFromString:startDate];
        _endDate = [dateFormat dateFromString:endDate];
        _timeSec = [[attributes objectForKey:@"timeSec"] intValue];
        _timeMin = [[attributes objectForKey:@"timeMin"] intValue];
        _timeHour = [[attributes objectForKey:@"timeHour"] intValue];
        _myWeight = [[attributes objectForKey:@"myWeight"] intValue];
        _isCompleted = [[attributes objectForKey:@"isCompleted"] boolValue];
        _routines = [NSMutableArray new];
        NSArray* routinesData = [attributes objectForKey:@"routines"];
        for(NSDictionary* routineData in routinesData){
            NSDictionary* wprData = [routineData objectForKey:@"workoutPlanRoutine"];
            int eid = [[wprData objectForKey:@"eid"] intValue];
            Exercise* exercise = [exerciseDict objectForKey:@(eid)];
            WorkoutPlanRoutine* wpr = [[WorkoutPlanRoutine alloc] initWithAttributes:wprData withExercise:exercise];
            Routine* routine = [[Routine alloc] initWithAttributes:routineData withWorkoutPlanRoutine:wpr];
            [_routines addObject:routine];
        }
        
    }
    return self;
}


-(id)initWithWorkoutPlan:(WorkoutPlan*)wplan{
    Workout* workout = [Workout new];
    workout.currentPlan = wplan;
    for(WorkoutPlanRoutine* wpr in wplan.workoutPlanRoutines){
        Routine* routine = [[Routine alloc] initWithWorkoutPlanRoutine:wpr];
        [workout.routines addObject:routine];
    }
    
    return workout;
}

-(void)finishWorkout{
    _endDate = nil;
    _endDate = [NSDate date];
    _isCompleted = true;
}

- (NSDictionary *)dictionaryFromData{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm aaa"];
    
    //Optionally for time zone converstions
    
    NSMutableArray* routines = [NSMutableArray new];
    for(Routine* routine in _routines){
        [routines addObject:[routine dictionaryFromData]];
    }
    
    NSString *stringFromStartDate = [formatter stringFromDate:_startDate];
    NSString *stringFromEndDate = [formatter stringFromDate:_endDate];
    NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:@(_isCompleted),@"isCompleted",stringFromStartDate,@"startDate",stringFromEndDate,@"endDate",@(_myWeight),@"myWeight",@(_timeSec),@"timeSec",@(_timeMin),@"timeMin",@(_timeHour),@"timeHour",routines,@"routines",
     //... add all your Menu properties here
     nil];
    
    return d;
    
}

+(Workout*) loadWorkout:(NSDictionary*)dict withWorkoutPlan:(WorkoutPlan*)wplan{
    Workout* workout = [Workout new];
    NSString* startDate = [dict objectForKey:@"startDate"];
    NSString* endDate = [dict objectForKey:@"endDate"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aaa"];
    workout.startDate = [dateFormat dateFromString:startDate];
    workout.endDate = [dateFormat dateFromString:endDate];
    workout.timeSec = [[dict objectForKey:@"timeSec"] intValue];
    workout.timeMin = [[dict objectForKey:@"timeMin"] intValue];
    workout.timeHour = [[dict objectForKey:@"timeHour"] intValue];
    workout.myWeight = [[dict objectForKey:@"myWeight"] intValue];
    workout.isCompleted = [[dict objectForKey:@"isCompleted"] boolValue];
    workout.currentPlan = wplan;
    for(WorkoutPlanRoutine* wpr in wplan.workoutPlanRoutines){
        Routine* routine = [[Routine alloc] initWithWorkoutPlanRoutine:wpr];
        [workout.routines addObject:routine];
    }
    
    
    return workout;
}


@end
