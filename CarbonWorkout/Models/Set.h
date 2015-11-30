//
//  Set.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/21/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Set : NSObject


@property NSInteger reps;
@property NSInteger max_reps;
@property NSInteger weight;

-(id)initWithReps:(NSInteger)reps maxReps:(NSInteger)mreps weight:(NSInteger)w;
-(id)copyWithZone:(NSZone *)zone;
@end
