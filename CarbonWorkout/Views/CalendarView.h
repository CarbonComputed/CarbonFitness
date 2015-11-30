//
//  CalendarView.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/16/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellPressedDelegate
-(void)cellButtonClicked:(NSDate*)date;
@end




@interface CalendarView : UIView

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSDate *displayedDate;
@property (nonatomic) NSArray *dayCells;

@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) NSUInteger displayedYear;
@property (nonatomic) NSUInteger displayedMonth;

@property (nonatomic) UIView* weekdayBar;
@property (nonatomic) NSInteger weekBarHeight;

@property (nonatomic) NSArray* weekdayNameLabels;
- (UIButton *) cellForDate: (NSDate *) date;

@property id<CellPressedDelegate> delegate;

-(void)highlightDate:(NSDate*)date;
-(void)resetHighlights;
@end
