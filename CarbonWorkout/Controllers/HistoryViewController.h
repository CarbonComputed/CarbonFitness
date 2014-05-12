//
//  HistoryViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/15/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"

@interface HistoryViewController : UIViewController <CellPressedDelegate>
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;



@end
