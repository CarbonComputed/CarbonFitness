//
//  Exercise.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

enum BODY {UPPER=1,LOWER,CORE,CARDIO};
enum TYPE {REP, TIME};

@interface Exercise : NSObject <NSCopying>

@property int eid;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* description;
@property (strong,nonatomic) NSString* imagePath;
@property int increment;
@property int type;
@property enum BODY body;



-(id) initWithDictionary:(NSDictionary*) attributes;
-(id)copyWithZone:(NSZone *)zone;
- (NSComparisonResult)compare:(Exercise *)otherObject;


@end
