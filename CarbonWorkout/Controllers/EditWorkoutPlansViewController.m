//
//  EditWorkoutPlansViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "EditWorkoutPlansViewController.h"
#import "RootViewController.h"
#import "EditRoutinesViewController.h"
#import "ExerciseListViewController.h"
#import "WorkoutPlanRoutine.h"

@interface EditWorkoutPlansViewController ()

@end

@implementation EditWorkoutPlansViewController

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
    _nameTextField.text = _workoutPlan.name;
    _descriptionTextField.text = _workoutPlan.description;
    [_editRoutinesTableView setDelegate:self];
    [_editRoutinesTableView setDataSource:self];
    [_nameTextField setDelegate:self];
    [_descriptionTextField setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Routine* r = [_currentWorkout.plan.routines objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =  [_editRoutinesTableView dequeueReusableCellWithIdentifier:@"EditRoutineCell"];;
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EditRoutineCell"];
    }
    WorkoutPlanRoutine* r = [_workoutPlan.workoutPlanRoutines objectAtIndex:indexPath.row];
    cell.textLabel.text = r.exercise.name;
    cell.detailTextLabel.text = r.exercise.description;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _workoutPlan.workoutPlanRoutines.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Exercises";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    [_workoutPlan.workoutPlanRoutines removeObjectAtIndex:indexPath.row];
    NSArray* todelete = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.editRoutinesTableView deleteRowsAtIndexPaths:todelete withRowAnimation:UITableViewRowAnimationFade];

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"editRoutineSegue"])
    {
        // Get reference to the destination view controller
        EditRoutinesViewController *edit = [segue destinationViewController];
        NSIndexPath *ip = [_editRoutinesTableView indexPathForSelectedRow];
        WorkoutPlanRoutine* routine = [_workoutPlan.workoutPlanRoutines objectAtIndex:ip.row];
        edit.currentRoutine = routine;
        
    }
    if ([[segue identifier] isEqualToString:@"exerciseListSegue"])
    {
        // Get reference to the destination view controller
        ExerciseListViewController *e = [segue destinationViewController];
        [e setDelegate:self];
        UINavigationController* nav = (UINavigationController*) self.navigationController;
        RootViewController* rvc = (RootViewController*) [nav.childViewControllers objectAtIndex:0];
        e.exerciseDict = rvc.exerciseDict;
    }
}

-(void)exerciseListViewDone:(ExerciseListViewController*)elvc{
    for(Exercise* exercise in elvc.selectedExercises){
        WorkoutPlanRoutine* wpr = [[WorkoutPlanRoutine alloc] initWithExercise:exercise];
        [_workoutPlan.workoutPlanRoutines addObject:wpr];
    }
    [self.editRoutinesTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)nameFieldEdited:(id)sender {
    _workoutPlan.name = _nameTextField.text;
}
- (IBAction)desciptionFieldChanged:(id)sender {
    _workoutPlan.description = _descriptionTextField.text;
}
- (IBAction)tableSwipedRight:(id)sender {
    [_editRoutinesTableView setEditing:true animated:true];
}
- (IBAction)tableSwipedLeft:(id)sender {
    [_editRoutinesTableView setEditing:false animated:true];
}

@end
