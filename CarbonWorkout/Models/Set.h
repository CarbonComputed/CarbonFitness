//
//  Set.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/21/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Set : NSObject

@property int reps;
@property int max_reps;
@property int weight;

-(id)initWithReps:(int)reps
           maxReps:(int)mreps
           weight:(int)w;
-(id)copyWithZone:(NSZone *)zone;
@end
