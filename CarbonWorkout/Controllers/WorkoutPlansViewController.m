//
//  WorkoutPlansViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "WorkoutPlansViewController.h"
#import "EditWorkoutPlansViewController.h"
#import "WorkoutPlan.h"
#import "User.h"

@interface WorkoutPlansViewController ()

@end

@implementation WorkoutPlansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_workoutPlansTableView setDelegate:self];
    [_workoutPlansTableView setDataSource:self];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // Routine* r = [_currentWorkout.plan.routines objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =  [_workoutPlansTableView dequeueReusableCellWithIdentifier:@"WorkoutPlanCell"];;
    NSArray* data = [_workoutDict allValues];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WorkoutPlanCell"];
    }

    WorkoutPlan* wplan = [data objectAtIndex:indexPath.row];
    if([User sharedUser].defaultWorkout == wplan.wid){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = 1;
    }

    cell.textLabel.text = wplan.name;
    cell.detailTextLabel.text = wplan.description;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    
    [_workoutDict removeObjectForKey:@([[_workoutDict.allValues objectAtIndex:indexPath.row] wid])];
    NSArray* todelete = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.workoutPlansTableView deleteRowsAtIndexPaths:todelete withRowAnimation:UITableViewRowAnimationFade];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_workoutDict allValues] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Workout Plans";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"editWorkoutPlansSegue"])
    {
        // Get reference to the destination view controller
        EditWorkoutPlansViewController *edit = [segue destinationViewController];
        NSIndexPath *ip = [self.workoutPlansTableView indexPathForSelectedRow];
        NSArray* data = [_workoutDict allValues];
        WorkoutPlan* wplan = [data objectAtIndex:ip.row];
        
        edit.workoutPlan = wplan;
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (IBAction)tableSwipeRight:(id)sender {
    [_workoutPlansTableView setEditing:true animated:true];
}

- (IBAction)tableSwipeLeft:(id)sender {
    [_workoutPlansTableView setEditing:false animated:true];
}
- (IBAction)newWorkoutPlanButton:(id)sender {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Name of new workout plan:", @"new_list_dialog")
                                                          message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [myAlertView show];

    
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 0){
        WorkoutPlan* wplan = [WorkoutPlan new];
        NSString* name = [actionSheet textFieldAtIndex:0].text;
        wplan.name = name;
        wplan.wid = name.hash;
        [_workoutDict setObject:wplan forKey:@(wplan.wid)];
        [self.workoutPlansTableView reloadData];
    }

}
- (IBAction)gestureLongPress:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateBegan){
        CGPoint p = [sender locationInView:self.workoutPlansTableView];
        
        NSIndexPath *indexPath = [self.workoutPlansTableView indexPathForRowAtPoint:p];
        if(indexPath != nil){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:@"Set Default Workout"
                        otherButtonTitles:nil];
            actionSheet.tag = indexPath.row;
            [actionSheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(buttonIndex==0){
        [User sharedUser].defaultWorkout = [[_workoutDict.allValues objectAtIndex:actionSheet.tag] wid];
        [self.workoutPlansTableView reloadData];
    }
}

@end
