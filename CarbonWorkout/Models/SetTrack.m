//
//  SetTrack.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/21/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "SetTrack.h"
#import "Set.h"

@interface SetTrack ()


@end

@implementation SetTrack

int roundTo(double number, int r){
    return (int)round(number/r) * r;
}


-(id) initWithAttributes:(NSDictionary*)attributes{
    self = [super init];
    if(self){
        _sets = [NSMutableArray new];
        NSArray* setsData = [attributes objectForKey:@"sets"];
        for(NSDictionary* setData in setsData){
            Set* set = [Set new];
            set.reps = [[setData objectForKey:@"reps"] intValue];
            set.max_reps = [[setData objectForKey:@"max_reps"] intValue];
            set.weight = [[setData objectForKey:@"weight"] intValue];
            [_sets addObject:set];

        }
    }
    return self;
}

-(id)initWithSetType:(int)type
             numSets:(int)nsets
         startingRep:(int)startR
           endingRep:(int)endingR
      startingWeight:(int)startW
        endingWeight:(int)endingW{
    self = [super init];
    if(self){

        _sets = [NSMutableArray new];
        if(type==EQUAL){
            int weight = startW;
            
            weight = roundTo(weight, 5);
            for(int i = 0;i<nsets;i++){
            
//                if(roundTo(weight, 5) > endingW){
//                    weight -= 5;
//                }
                Set* set = [[Set alloc] initWithReps:-1 maxReps:startR weight:weight] ;
                [_sets addObject:set];
            }
        }
        else if(type==RAMP){
            int repSlope = (endingR - startR) / (nsets - 1);
            int weightSlope = (endingW - startW) / (nsets - 1);
            int rep = startR;
            int weight = startW;
            for(int i = 0;i<nsets;i++){
                if(roundTo(weight, 5) > endingW){
                    weight -= 5;
                }
                weight = MIN(endingW, weight);
                Set* set = [[Set alloc] initWithReps:-1 maxReps:rep weight:roundTo(weight, 5)];
                [_sets addObject:set];
                rep += repSlope;

                weight += weightSlope;
            }
            
        }
        else if(type==PYRAMID){
            int repSlope = (endingR - startR) / ((nsets/2) + 1 - 1);
            int weightSlope = (endingW - startW) / ((nsets/2) + 1 - 1);
            int rep = startR;
            int weight = startW;
            for(int i = 0;i<nsets;i++){
//                if(roundTo(weight, 5) > endingW){
//                    weight -= 5;
//                }
                weight = MIN(endingW, weight);
                Set* set = [[Set alloc] initWithReps:-1 maxReps:rep weight:roundTo(weight, 5)];
                [_sets addObject:set];
                rep += repSlope;
                weight += weightSlope;
                if(i==(nsets/2) - 1){
                    repSlope = -repSlope;
                }
                if(weight>=endingW){
                    weightSlope = -weightSlope;
                }
            }
        }
        
    }
    return self;
    
}

- (NSDictionary *)dictionaryFromData{
    NSMutableDictionary* setData = [NSMutableDictionary new];
    NSMutableArray * sets = [NSMutableArray new];
    for(Set* set in _sets){
        NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:@(set.max_reps),@"max_reps",
                           @(set.reps),@"reps",@(set.weight),@"weight",
                           //... add all your Menu properties here
                           nil];
        [sets addObject:d];
    }
    [setData setObject:sets forKey:@"sets"];
    return setData;

}


-(id)copyWithZone:(NSZone *)zone{
    SetTrack* another = [SetTrack new];
    for(Set* set in _sets){
        [another.sets addObject:[set copyWithZone:nil]];
    }
    return another;
}

@end
