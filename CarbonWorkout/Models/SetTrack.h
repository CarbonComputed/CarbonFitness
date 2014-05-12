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

-(id)initWithSetType:(int)type
             numSets:(int)sets
         startingRep:(int)startR
           endingRep:(int)endingR
      startingWeight:(int)startW
        endingWeight:(int)endingW;

-(id) initWithAttributes:(NSDictionary*)attributes;
- (NSDictionary *)dictionaryFromData;
-(id)copyWithZone:(NSZone *)zone;

@end
