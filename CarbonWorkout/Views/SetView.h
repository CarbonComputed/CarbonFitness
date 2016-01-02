//
//  SetView.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 5/11/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetViewDelegate
-(void)setViewResized:(NSUInteger)buttonSize;
-(void)setButtonPressed:(UIButton *)sender;
@end

@interface SetView : UIView

@property NSMutableArray *setButtons;
@property (nonatomic) NSArray *sets;
@property id<SetViewDelegate> delegate;

@end
