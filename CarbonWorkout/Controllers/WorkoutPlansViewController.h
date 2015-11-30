//
//  WorkoutPlansViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutPlansViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *workoutPlansTableView;
@property (weak) NSMutableDictionary* workoutDict;



@end
