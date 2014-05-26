//
//  routinesViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "RoutinesViewController.h"

#import "RootViewController.h"
#import "RoutineViewController.h"

#import "Workout.h"
#import "WorkoutPlan.h"
#import "Routine.h"
#import "Exercise.h"

enum Sort {ALPHA,BODY};

@interface RoutinesViewController ()

@property UIActionSheet* sortSheet;
@property int sortType;

@end



@implementation RoutinesViewController



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
    _displayList = [NSMutableDictionary new];
    [_displayList setObject:[NSMutableArray new] forKey:@"Exercises"];
    for(Routine* r in _currentWorkout.routines){
        [[_displayList objectForKey:@"Exercises"] addObject:r];
    }
    
    self.routinesTableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
    
    _sortType = BODY;
    
    [_routinesTableView setDelegate:self];

    [_routinesTableView setDataSource:self];
    _numWorkoutsCompleted = 0;
    
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d", _currentWorkout.timeHour, _currentWorkout.timeMin, _currentWorkout.timeSec];
    [[self exerciseTimerLabel] setText:timeNow];
    if(!_currentWorkout.isCompleted){
        _workoutTimer = [NSTimer timerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(exerciseTimerDidTick:)
                                               userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_workoutTimer forMode:NSRunLoopCommonModes];
    }
    else{
        _finishButton.hidden = true;
    }
    
    _sortSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Options: " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                  @"Alphabetically",
                  @"Body Type",
                  nil];
    _sortSheet.tag = 1;

    // Do any additional setup after loading the view.
}



-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [_workoutTimer invalidate];
    }
    [super viewWillDisappear:animated];
}

-(void) exerciseTimerDidTick:(NSTimer*) theTimer{
    _currentWorkout.timeSec++;
    if (_currentWorkout.timeSec == 60)
    {
        _currentWorkout.timeSec = 0;
        _currentWorkout.timeMin++;
    }
    if(_currentWorkout.timeMin == 60){
        _currentWorkout.timeMin = 0;
        _currentWorkout.timeHour++;
    }
    //Format the string 00:00
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d", _currentWorkout.timeHour, _currentWorkout.timeMin, _currentWorkout.timeSec];
    [[self exerciseTimerLabel] setText:timeNow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Routine* r = [_currentWorkout.routines objectAtIndex:indexPath.row];
    Routine* r = [[[_displayList allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell =  [_routinesTableView dequeueReusableCellWithIdentifier:@"Cell"];;
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if(r.didComplete){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    float progress = (float)((float)_numWorkoutsCompleted / (float)[_currentWorkout.routines count]);
    [_exerciseProgress setProgress:progress animated:true];
    UIImage* image;
    if(progress >=.99){
        [_exerciseProgress setTintColor:[UIColor greenColor]];
        [self finishWorkout];
        image = [UIImage imageNamed: @"Goku4.png"];
    }
    else if(progress >= .75 ){
        
        image = [UIImage imageNamed: @"Goku3.png"];

    }
    else if(progress >= 0.5){
        image = [UIImage imageNamed: @"Goku2.png"];

    }
    else{
        image = [UIImage imageNamed: @"Goku1.png"];

    }
    [_progressImage setImage:image];
    cell.textLabel.text = r.workoutPlanRoutine.exercise.name;
    return cell;

}
-(void) viewDidAppear:(BOOL)animated {
    _numWorkoutsCompleted = 0;
    for(Routine* r in _currentWorkout.routines){
        if(r.didComplete){
            _numWorkoutsCompleted += 1;
        }
    }
    [self.routinesTableView reloadData];
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_displayList allValues] objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_displayList allValues].count;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_displayList allKeys] objectAtIndex:section];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return @[@"Upper",@"Lower",@"Core",@"Cardio"];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ExerciseSegue"])
    {
        // Get reference to the destination view controller
        RoutineViewController *evc = [segue destinationViewController];
        NSIndexPath *ip = [self.routinesTableView indexPathForSelectedRow];
        evc.routine = [[[_displayList allValues] objectAtIndex:ip.section] objectAtIndex:ip.row];;
        evc.currentWorkout = _currentWorkout;
        evc.fromHistory = _fromHistory;
    }
}

-(void)finishWorkout{
    _currentWorkout.isCompleted = true;
    [_workoutTimer invalidate];
    _finishButton.hidden = true;
}
- (IBAction)finishWorkoutButtonPressed:(id)sender {
    [self finishWorkout];
    
}

-(void)sortByBodyType{
    
    [_displayList removeAllObjects];
    for(Routine* r in _currentWorkout.routines){
        switch (r.workoutPlanRoutine.exercise.body) {
            case UPPER:
                if(![_displayList objectForKey:@"UPPER BODY"]){
                    [_displayList setObject:[NSMutableArray new] forKey:@"UPPER BODY" ];
                }
                [[_displayList objectForKey:@"UPPER BODY"] addObject:r];
                
                break;
            case LOWER:
                if(![_displayList objectForKey:@"LOWER BODY"]){
                    [_displayList setObject:[NSMutableArray new] forKey:@"LOWER BODY" ];
                }
                [[_displayList objectForKey:@"LOWER BODY"] addObject:r];
                break;
            case CORE:
                if(![_displayList objectForKey:@"CORE"]){
                    [_displayList setObject:[NSMutableArray new] forKey:@"LOWER BODY" ];
                }
                [[_displayList objectForKey:@"CORE"] addObject:r];
                
                break;
                
            default:
                break;
        }
    }
    [_routinesTableView reloadData];
    _sortType = BODY;
    
}

-(void)sortAlphabetically{
    [_displayList removeAllObjects];
    [_displayList setObject:[NSMutableArray new] forKey:@"Exercises"];
    for(Routine* r in _currentWorkout.routines){
        [[_displayList objectForKey:@"Exercises"] addObject:r];
    }
    NSMutableArray* sortedArray = [[_displayList objectForKey:@"Exercises"] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Routine *ex1 = (Routine*)a;
        Routine *ex2 = (Routine*)b;
        return [ex1.workoutPlanRoutine.exercise compare:ex2.workoutPlanRoutine.exercise];
    }];
    _sortType = ALPHA;
    
    [_displayList setObject:sortedArray forKey:@"Exercises"];
    [_routinesTableView reloadData];

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self sortAlphabetically];
                    break;
                case 1:
                    [self sortByBodyType];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (IBAction)menuPressed:(id)sender {
    [_sortSheet showInView:[UIApplication sharedApplication].keyWindow];

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
