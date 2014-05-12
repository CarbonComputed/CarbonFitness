//
//  Set.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/21/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "Set.h"

@implementation Set

-(id)initWithReps:(int)reps
          maxReps:(int)mreps
           weight:(int)w{
    self = [super init];
    if(self){
        _reps = reps;
        _max_reps = mreps;
        _weight = w;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    Set* another = [Set new];
    another.reps = _reps;
    another.max_reps = _max_reps;
    another.weight = _weight;
    return another;
}

@end
