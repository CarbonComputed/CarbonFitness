//
//  Routine.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/9/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "Routine.h"
#import "SetTrack.h"
#import "Set.h"

@implementation Routine

-(id) init{
    self = [super init];
    if (self) {
        _didComplete = false;
        _setTrack = [[SetTrack alloc] initWithSetType:0 numSets:0 startingRep:0 endingRep:0 startingWeight:0 endingWeight:0];

    }
    return self;
}

-(id) initWithAttributes:(NSDictionary*)attributes withWorkoutPlanRoutine:(WorkoutPlanRoutine*)wpr{
    self = [super init];
    if(self){
        _workoutPlanRoutine = [wpr copyWithZone:nil];
        _didComplete = [[attributes objectForKey:@"didComplete"] boolValue];
        _setTrack = [[SetTrack alloc] initWithAttributes:attributes];
    }
    return self;
}

-(id) initWithWorkoutPlanRoutine:(WorkoutPlanRoutine *)wpr{
    self = [super init];
    if (self) {
        // Initialize self.
        
        _workoutPlanRoutine = [wpr copyWithZone:nil];
        _setTrack = [[SetTrack alloc] initWithSetType:wpr.incrementType numSets:wpr.sets startingRep:wpr.startingReps endingRep:wpr.endingReps startingWeight:wpr.startingWeight endingWeight:wpr.endingWeight];
        
    }
    return self;
}

-(int)completedRoutine{
    int retval = 1;
    for(int i = 0;i<[_setTrack.sets count];i++){
        Set* set = [_setTrack.sets objectAtIndex:i];
        if(set.reps==-1){
            return -1;
        }
        if(set.reps != set.max_reps){
            _didComplete = true;
            retval = 0;;
        }
        
    }
    _didComplete = true;
    return retval;
}

-(void)incrementWeight{
//    _workoutPlanRoutine.startingWeight += 5;
//    _workoutPlanRoutine.endingWeight += 5;
}

- (NSDictionary *)dictionaryFromData{
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    [dictionary setObject:[_workoutPlanRoutine dictionaryFromData] forKey:@"workoutPlanRoutine"];
    [dictionary setObject:[[_setTrack dictionaryFromData] objectForKey:@"sets"] forKey:@"sets"];
    [dictionary setObject:@(_didComplete) forKey:@"didComplete"];
    return dictionary;
}

//+(Routine*) loadRoutine:(NSDictionary*)attributes andExercise:(Exercise*)exercise{
//    
//    Routine* routine = [[Routine alloc] initWithAttributes:attributes andExercise:exercise];
//    routine.didComplete = [[attributes objectForKey:@"didComplete"] boolValue];
//    NSDictionary* st = [attributes objectForKey:@"setTrack"];
//    NSArray* sets = [st objectForKey:@"sets"];
//    for(int i=0;i<[sets count];i++){
//        NSDictionary* s = [sets objectAtIndex:i];
//        Set* set = [routine.setTrack.sets objectAtIndex:i];
//        set.reps = [[s objectForKey:@"reps"] intValue];
//        set.weight = [[s objectForKey:@"weight"] intValue];
//        set.max_reps = [[s objectForKey:@"max_reps"] intValue];
//    }
//        
//        
//    return routine;
//}

-(id)copyWithZone:(NSZone *)zone
{
    
    Routine *another = [[Routine alloc] init];
    another.didComplete = _didComplete;
    another.workoutPlanRoutine = [_workoutPlanRoutine copyWithZone:nil];
    another.setTrack = [_setTrack copyWithZone:nil];
    return another;
}




@end
