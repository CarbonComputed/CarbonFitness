//
//  ExerciseListViewController.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/23/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExerciseListViewControllerDelegate;

@interface ExerciseListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property id<ExerciseListViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *exerciseTableView;
@property (weak) NSDictionary* exerciseDict;

@property NSMutableArray *selectedExercises;

@end

@protocol ExerciseListViewControllerDelegate <NSObject>

-(void)exerciseListViewDone:(ExerciseListViewController*)elvc;

@end