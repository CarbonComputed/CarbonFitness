//
//  SetView.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 5/11/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetViewDelegate
-(void)setViewResized:(int)buttonSize;
-(void)setButtonPressed:(UIButton *)sender;

@end


@interface SetView : UIView
@property NSMutableArray* setButtons;
@property NSMutableArray* sets;
@property id<SetViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame setArray:(NSMutableArray*)sets;

@end
