//
//  User.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/22/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "User.h"

@implementation User

static User *sharedUser;
+(User*) sharedUser{
    return sharedUser;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedUser = [[User alloc] init];
    }
}

@end
