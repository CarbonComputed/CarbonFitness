//
//  ExerciseListViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/23/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "ExerciseListViewController.h"
#import "Exercise.h"

@interface ExerciseListViewController ()

@end

@implementation ExerciseListViewController

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
    _selectedExercises = [NSMutableArray new];
    [self.exerciseTableView setDelegate:self];
    [self.exerciseTableView setDataSource:self];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Routine* r = [_currentWorkout.plan.routines objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =  [_exerciseTableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];;
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExerciseCell"];
    }
    Exercise* r = [_exerciseDict.allValues objectAtIndex:indexPath.row];
    cell.textLabel.text = r.name;
    cell.detailTextLabel.text = r.description;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_exerciseDict allValues].count;
}
- (IBAction)donePressed:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(exerciseListViewDone:)]) {
        // self is passed as the LoginViewController argument to the delegate methods
        // in this way our delegate can serve as the delegate of multiple login view controllers, if needed
        
        [self.delegate exerciseListViewDone:self];
        [self dismissViewControllerAnimated:YES completion:nil];
        
//    }
}
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)exerciseListViewDone:(ExerciseListViewController*)elvc{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_exerciseTableView cellForRowAtIndexPath:indexPath];
    if (![_selectedExercises containsObject:[_exerciseDict.allValues objectAtIndex:indexPath.row]])  // if not available
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedExercises addObject: [_exerciseDict.allValues objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedExercises removeObject: [_exerciseDict.allValues objectAtIndex:indexPath.row]];
    }
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

@end
