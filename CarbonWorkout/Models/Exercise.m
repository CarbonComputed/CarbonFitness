//
//  Exercise.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "Exercise.h"


@implementation Exercise
@synthesize description = _description;
-(id) initWithDictionary:(NSDictionary*) attributes{
    self = [super init];
    if (self) {
        // Initialize self.
        _eid = [[attributes objectForKey:@"id"] intValue];
        _increment = 5;
        _name = [attributes objectForKey:@"name"];
        _description = [attributes objectForKey:@"description"];
        _imagePath = @"test";
        _body = [[attributes objectForKey:@"body"] intValue];
        id inc = [attributes objectForKey:@"inc"];
        id img = [attributes objectForKey:@"image"];
        if(inc){
            _increment = [inc intValue];
        }
        if(img){
            _imagePath = img;
        }
        
    }
    return self;
}

- (NSDictionary *)dictionaryFromData{
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    Exercise *another = [[Exercise alloc] init];
    another.eid = _eid;
    another.name = _name;
    another.description = _description;
    another.imagePath = _imagePath;
    another.increment = _increment;
    //another.obj = [obj copyWithZone: zone];
    
    return another;
}

- (NSComparisonResult)compare:(Exercise *)otherObject {
    return [_name compare:otherObject.name];
}
@end
