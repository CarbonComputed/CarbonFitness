//
//  WorkoutPlanRoutine.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/22/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "WorkoutPlanRoutine.h"

@implementation WorkoutPlanRoutine

-(id)initWithExercise:(Exercise*)exercise{
    self = [super init];
    if(self){
        _exercise = exercise;
        _days = [NSMutableSet new];
        _incrementType = 0;
        _max = 0;
        _sets = 1;
        _startingReps = 1;
        _startingWeight = 0;
        _endingReps = 1;
        _endingWeight = 0;

    }
    return self;
}

-(id) initWithAttributes:(NSDictionary*) attributes withExercise:(Exercise*)exercise{
    self = [super init];
    if (self) {
        // Initialize self.
        
        _exercise = exercise;
        _max = [[attributes objectForKey:@"max"] intValue];
        _incrementType = [[attributes objectForKey:@"incrementType"] intValue];
        _sets = [[attributes objectForKey:@"sets"] intValue];
        
        _startingReps = [[attributes objectForKey:@"startingReps"] intValue];
        _startingWeight = [[attributes objectForKey:@"startingWeight"] intValue];
        _endingReps = [[attributes objectForKey:@"endingReps"] intValue];
        _endingWeight = [[attributes objectForKey:@"endingWeight"] intValue];
        
        _days = [NSMutableSet new];
        
        
        for(NSString* day in [attributes objectForKey:@"days"]){
            
            if([day  isEqual: @"S"]){
                [_days addObject:@(S)];
            }
            if([day  isEqual: @"M"]){
                [_days addObject:@(M)];
            }
            if([day  isEqual: @"T"]){
                [_days addObject:@(T)];
            }
            if([day  isEqual: @"W"]){
                [_days addObject:@(W)];
            }
            if([day  isEqual: @"R"]){
                [_days addObject:@(R)];
            }
            if([day  isEqual: @"F"]){
                [_days addObject:@(F)];
            }
            if([day  isEqual: @"SA"]){
                [_days addObject:@(SA)];
            }
        }
        
        
    }
    return self;
}

- (NSDictionary *)dictionaryFromData{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSMutableArray *dayData = [NSMutableArray new];
    for(NSValue *day in _days){
        
        if([day  isEqual: @(S)]){
            [dayData addObject:@"S"];
        }
        if([day  isEqual: @(M)]){
            [dayData addObject:@"M"];
        }
        if([day  isEqual: @(T)]){
            [dayData addObject:@"T"];
        }
        if([day  isEqual: @(W)]){
            [dayData addObject:@"W"];
        }
        if([day  isEqual: @(R)]){
            [dayData addObject:@"R"];
        }
        if([day  isEqual: @(F)]){
            [dayData addObject:@"F"];
        }
        if([day  isEqual: @(SA)]){
            [dayData addObject:@"SA"];
        }
    }
    [dictionary setObject:@(_sets) forKey:@"sets"];
    [dictionary setObject:@(_startingReps) forKey:@"startingReps"];
    [dictionary setObject:@(_endingReps) forKey:@"endingReps"];
    [dictionary setObject:@(_startingWeight) forKey:@"startingWeight"];
    [dictionary setObject:@(_endingWeight) forKey:@"endingWeight"];
    [dictionary setObject:@(_exercise.eid) forKey:@"eid"];
    [dictionary setObject:@(_max) forKey:@"max"];
    [dictionary setObject:@(_incrementType) forKey:@"incrementType"];

    [dictionary setObject:dayData forKey:@"days"];

    return dictionary;
}

-(id)copyWithZone:(NSZone *)zone{
    WorkoutPlanRoutine* another = [WorkoutPlanRoutine new];
    another.sets = _sets;
    another.startingReps = _startingReps;
    another.startingWeight = _startingWeight;
    another.endingReps = _endingReps;
    another.endingWeight = _endingWeight;
    another.incrementType = _incrementType;
    another.max = _max;
    another.days = [NSMutableSet new];
    for(id i in _days){
        [another.days addObject:[i copyWithZone:nil]];
    }
    another.exercise = _exercise;
    return another;

}

@end
