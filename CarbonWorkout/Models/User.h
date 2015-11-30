//
//  User.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/22/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property int uid;
@property NSString* name;
@property NSInteger defaultWorkout;

@property NSMutableDictionary *workoutDict;

+(User*) sharedUser;
@end

