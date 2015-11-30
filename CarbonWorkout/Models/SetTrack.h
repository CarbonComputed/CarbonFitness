//
//  SetTrack.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/21/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

enum INC_TYPE {EQUAL,RAMP,PYRAMID};


@interface SetTrack : NSObject

@property NSMutableArray* sets;

-(id)initWithSetType:(NSInteger)type
             numSets:(NSInteger)sets
         startingRep:(NSInteger)startR
           endingRep:(NSInteger)endingR
      startingWeight:(NSInteger)startW
        endingWeight:(NSInteger)endingW;

-(id) initWithAttributes:(NSDictionary*)attributes;
- (NSDictionary *)dictionaryFromData;
-(id)copyWithZone:(NSZone *)zone;

@end
