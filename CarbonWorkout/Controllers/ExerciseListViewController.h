//
//  ExerciseListViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/23/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExerciseListViewControllerDelegate;

@interface ExerciseListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate>

@property id<ExerciseListViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *exerciseTableView;
@property (weak) NSDictionary* exerciseDict;

@property NSMutableArray *selectedExercises;
@property NSMutableDictionary* displayList;

@property UIActionSheet* sortSheet;

@end

@protocol ExerciseListViewControllerDelegate <NSObject>

-(void)exerciseListViewDone:(ExerciseListViewController*)elvc;

@end