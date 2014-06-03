//
//  CalendarView.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/16/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>

#import "CalendarView.h"

static const CGFloat kGridMargin = 10;

@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
        _calendar = [NSCalendar currentCalendar];
        _weekBarHeight = 32;
        self.selectedDate = nil;
        self.displayedDate = [NSDate date];
        CGFloat top = 0;
        NSDateComponents *components = [self.calendar components: NSWeekdayCalendarUnit
                                                        fromDate: [self displayedMonthStartDate]];
        NSInteger shift = components.weekday - self.calendar.firstWeekday;
        if (shift < 0) {
            shift = 7 + shift;
        }
        
        // Calculate range
        NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit
                                           forDate:self.displayedDate];
        int padding = 4;
        //int cellHeight = self.bounds.size.height / 6.0;
        int cellHeight = 15;
        int cellWidth = (self.bounds.size.width - (kGridMargin * 2) - (padding * 6)) / 7.0;
        if (self.weekBarHeight) {
            self.weekdayBar.frame = CGRectMake(0, top, self.bounds.size.width, self.weekBarHeight);
            CGRect contentRect = CGRectInset(self.weekdayBar.bounds, kGridMargin, 0);
            for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
                UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
                label.frame = CGRectMake((kGridMargin)+((padding+cellWidth) * ((0 + i) % 7)), 0,
                                         contentRect.size.width / 7, contentRect.size.height);
            }
            top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
        } else {
            self.weekdayBar.frame = CGRectZero;
        }
        
        for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
            UIButton *cellView = [self.dayCells objectAtIndex:i];
            cellView.frame = CGRectMake((kGridMargin)+((padding+cellWidth) * ((shift + i) % 7)) ,top+(cellHeight+padding) * ((shift + i) / 7 ),
                                        cellWidth, cellHeight);
            //cellView.backgroundColor = [UIColor lightGrayColor];
            NSString* day  = [NSString stringWithFormat:@"%d",i+1];
            [cellView setTitle:day forState:UIControlStateNormal];
            [cellView setTitle:day forState:UIControlStateHighlighted];
            [cellView setTitle:day forState:UIControlStateSelected];
            [cellView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cellView setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [cellView setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
            cellView.titleLabel.textColor = [UIColor blackColor];
            cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cellView.layer.borderWidth = 1;
            cellView.backgroundColor = [UIColor whiteColor];
            cellView.hidden = i >= range.length;
            
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        // Do something
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
        _calendar = [NSCalendar currentCalendar];
        _weekBarHeight = 32;

        
        self.selectedDate = nil;
        self.displayedDate = [NSDate date];
        
                    //self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 500);
    }
    return self;
}

- (NSUInteger) displayedYear {
    NSDateComponents *components = [self.calendar components: NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    return components.year;
}

- (NSUInteger) displayedMonth {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit
                                                    fromDate: self.displayedDate];
    return components.month;
}


- (NSDate *) displayedMonthStartDate {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    components.day = 1;
    return [self.calendar dateFromComponents: components];
}

- (NSArray *) weekdayNameLabels {
    if (!_weekdayNameLabels) {
        NSMutableArray *labels = [NSMutableArray array];
        
        for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);
            
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
            label.tag = i;
            label.text = [[_dateFormatter shortWeekdaySymbols] objectAtIndex: index];
            label.font = [UIFont boldSystemFontOfSize:12];
            label.textAlignment = UITextAlignmentCenter;

            
            [labels addObject:label];
            [_weekdayBar addSubview: label];
        }
        
        [self addSubview:_weekdayBar];
        _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
    }
    return _weekdayNameLabels;
}

-(void)resetHighlights{
    
    for(UIButton* b in _dayCells){
        [b setBackgroundImage:[CalendarView imageFromColor:[UIColor whiteColor]]
                     forState:UIControlStateNormal];
    }
}

-(void)highlightDate:(NSDate*)date{
    if (!date) {
        return;
    }
    UIButton* b = [self cellForDate:date];
    [b setBackgroundImage:[CalendarView imageFromColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]]
                      forState:UIControlStateNormal];
    
    
}

+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIView *) weekdayBar {
    if (!_weekdayBar) {
        _weekdayBar = [[UIView alloc] init];
        _weekdayBar.backgroundColor = [UIColor clearColor];
        
    }
    return _weekdayBar;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat top = 0;
    NSDateComponents *components = [self.calendar components: NSWeekdayCalendarUnit
                                                    fromDate: [self displayedMonthStartDate]];
    NSInteger shift = components.weekday - self.calendar.firstWeekday;
    if (shift < 0) {
        shift = 7 + shift;
    }
    
    // Calculate range
    NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit
                                       forDate:self.displayedDate];
    int padding = 4;
    int cellHeight = 40;
    int cellWidth = (self.frame.size.width - (kGridMargin * 2) - (padding * 6)) / 7.0;
    if (self.weekBarHeight) {
        self.weekdayBar.frame = CGRectMake(0, top, self.frame.size.width, self.weekBarHeight);
        CGRect contentRect = CGRectInset(self.weekdayBar.frame, kGridMargin, 0);
        for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
            UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
            label.frame = CGRectMake((kGridMargin)+((padding+cellWidth) * ((0 + i) % 7)), 0,
                                     contentRect.size.width / 7, contentRect.size.height);
        }
        top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
    } else {
        self.weekdayBar.frame = CGRectZero;
    }
    
    for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
        UIButton *cellView = [self.dayCells objectAtIndex:i];
        cellView.frame = CGRectMake((kGridMargin)+((padding+cellWidth) * ((shift + i) % 7)) ,top+(cellHeight+padding) * ((shift + i) / 7 ),
                                    cellWidth, cellHeight);
        //cellView.backgroundColor = [UIColor lightGrayColor];
        NSString* day  = [NSString stringWithFormat:@"%d",i+1];
        [cellView setTitle:day forState:UIControlStateNormal];
        [cellView setTitle:day forState:UIControlStateHighlighted];
        [cellView setTitle:day forState:UIControlStateSelected];
        [cellView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cellView setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [cellView setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        cellView.titleLabel.textColor = [UIColor blackColor];
        cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cellView.layer.borderWidth = 1;
        cellView.backgroundColor = [UIColor whiteColor];
        cellView.hidden = i >= range.length;
        
    }

    
    
//    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,self.bounds.size.width, self.bounds.size.height+25);
}


- (UIButton *) cellForDate: (NSDate *) date{
    if (!date) {
        return nil;
    }
    
    NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                    fromDate: date];
    if (components.month == self.displayedMonth &&
        components.year == self.displayedYear &&
        [self.dayCells count] >= components.day) {
        
        return [self.dayCells objectAtIndex: components.day - 1];
    }
    return nil;
}



- (void) touchedCellView: (UIButton *) cellView {

    NSDateComponents *components = [_calendar components:NSYearCalendarUnit|NSMonthCalendarUnit
                                               fromDate:self.displayedDate];
    components.day = cellView.tag;
    self.selectedDate = [_calendar dateFromComponents:components];;
    [_delegate cellButtonClicked:self.selectedDate];
}


- (NSArray *) dayCells {
    if (!_dayCells) {
        NSMutableArray *cells = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 31; ++i) {
            UIButton *cell = [UIButton buttonWithType:UIButtonTypeCustom];
            cell.tag = i;
            //cell.day = i;
            [cell addTarget: self
                     action: @selector(touchedCellView:)
           forControlEvents: UIControlEventTouchUpInside];
            //cell.layer.cornerRadius = self.bounds.size.height / 12;

            
            [cells addObject:cell];
            [self addSubview: cell];
        }
        _dayCells = [[NSArray alloc] initWithArray:cells];
    }
    return _dayCells;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
