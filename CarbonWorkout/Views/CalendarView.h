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

    @property NSCalendar *calendar;
    @property NSDate *selectedDate;
    @property NSDate *displayedDate;
    @property NSArray *dayCells;

    @property NSDateFormatter *dateFormatter;

    @property NSUInteger displayedYear;
    @property NSUInteger displayedMonth;

    @property UIView* weekdayBar;
    @property int weekBarHeight;

    @property NSArray* weekdayNameLabels;
    - (UIButton *) cellForDate: (NSDate *) date;

    @property id<CellPressedDelegate> delegate;

-(void)highlightDate:(NSDate*)date;
-(void)resetHighlights;
@end
