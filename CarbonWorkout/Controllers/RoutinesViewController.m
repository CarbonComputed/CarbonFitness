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

enum Sort {ALPHA,BODY,DAY};

@implementation NSDictionary (Extra)

-(NSArray *) sortedKeys {
    return [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

-(NSArray *) allValuesSortedByKey {
    return [self objectsForKeys:self.sortedKeys notFoundMarker:[NSNull null]];
}

-(id) firstKey {
    return [self.sortedKeys firstObject];
}

-(id) firstValue {
    return [self valueForKey: [self firstKey]];
}

@end

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
    [_displayList removeAllObjects];
    for(Routine* r in _currentWorkout.routines){
        for(NSValue *day in r.workoutPlanRoutine.days){
            
            if(![_displayList objectForKey:day]){
                [_displayList setObject:[NSMutableArray new] forKey:day ];
            }
            [[_displayList objectForKey:day] addObject:r];
        }
        if(r.workoutPlanRoutine.days.count == 0){
            NSValue* day = @(10);
            if(![_displayList objectForKey:day]){
                [_displayList setObject:[NSMutableArray new] forKey:day ];
            }
            [[_displayList objectForKey:day] addObject:r];
        }
        
    }
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"e"];
    int today = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    if(![_displayList objectForKey:@(today)]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Workouts listed for today"
                                                          message:@"Adding all routines to current workout. You can edit your workout plans to add some to this day of the week."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [_displayList removeAllObjects];
        NSValue* day = @(11);
        [_displayList setObject:[NSMutableArray new] forKey:day ];
        for(Routine* r in _currentWorkout.routines){
            [[_displayList objectForKey:day] addObject:r];
            
        }
        [message show];
    }
    _sortType = DAY;
   // [self sortByDay];

//    [_displayList setObject:[NSMutableArray new] forKey:@"Exercises"];
//    for(Routine* r in _currentWorkout.routines){
//        [[_displayList objectForKey:@"Exercises"] addObject:r];
//    }
    
    self.routinesTableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
    
    //_sortType = BODY;
    
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
                  @"Day",
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

-(float) getProgress{
    float nCompleted = 0;
    float totalRoutines = 0;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"e"];
    NSValue* today = [[_displayList sortedKeys] objectAtIndex:0];
    int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    if(_sortType == DAY && ![today isEqualToValue:@(11)]){

        for(Routine* r in _currentWorkout.routines){
            if([r.workoutPlanRoutine.days containsObject:@(day)]){
                if(r.didComplete){
                    nCompleted++;
                }
                totalRoutines++;
            }
        }
    }
    else{
        for(NSArray* dict in [_displayList allValues]){
            for(Routine* r in dict){
                //if([r.workoutPlanRoutine.days containsObject:@(day)]){
                    if(r.didComplete){
                        nCompleted++;
                    }
                    totalRoutines++;
               // }
            }
        }
        //nCompleted =(float)_numWorkoutsCompleted;
        //totalRoutines = (float) _currentWorkout.routines.count;
    }
    if(totalRoutines == 0){
        return 0;
    }
    return nCompleted/totalRoutines;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Routine* r = [_currentWorkout.routines objectAtIndex:indexPath.row];
    Routine* r = [[[_displayList allValuesSortedByKey] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell =  [_routinesTableView dequeueReusableCellWithIdentifier:@"Cell"];;
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if(r.didComplete){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    float progress = [self getProgress];
    //float progress = (float)((float)_numWorkoutsCompleted / (float)[_currentWorkout.routines count]);
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
    return [[[_displayList allValuesSortedByKey] objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_displayList allValuesSortedByKey].count;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(_sortType==DAY){
        NSValue* day = [[_displayList sortedKeys] objectAtIndex:section];
        if([day  isEqual: @(S)]){
            return @"SUNDAY";
        }
        if([day  isEqual: @(M)]){
            return @"MONDAY";
        }
        if([day  isEqual: @(T)]){
            return @"TUESDAY";
        }
        if([day  isEqual: @(W)]){
            return @"WEDNESDAY";
        }
        if([day  isEqual: @(R)]){
            return @"THURSAY";
        }
        if([day  isEqual: @(F)]){
            return @"FRIDAY";
        }
        if([day  isEqual: @(SA)]){
            return @"SATURDAY";
        }
        if([day  isEqual: @(10)]){
            return @"NO DAYS";
        }
        if([day  isEqual: @(11)]){
            return @"Today";
        }
    }

    
    return [[_displayList sortedKeys] objectAtIndex:section];
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
        evc.routine = [[[_displayList allValuesSortedByKey] objectAtIndex:ip.section] objectAtIndex:ip.row];;
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
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"e"];
    int today = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    for(Routine* r in _currentWorkout.routines){
        if(![r.workoutPlanRoutine.days containsObject:@(today)]){
            continue;
        }
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
                    [_displayList setObject:[NSMutableArray new] forKey:@"CORE" ];
                }
                [[_displayList objectForKey:@"CORE"] addObject:r];
                break;
			case CARDIO:
				break;

        }
    }
    if(_displayList.count == 0){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Workouts listed for today"
                                                          message:@"Adding all routines to current workout. You can edit your workout plans to add some to this day of the week."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
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
                        [_displayList setObject:[NSMutableArray new] forKey:@"CORE" ];
                    }
                    [[_displayList objectForKey:@"CORE"] addObject:r];
                    break;
				case CARDIO:
					break;
                    
            }
        }
    }

    for(NSString* key in _displayList.allKeys){
        NSArray* sortedArray = [[_displayList objectForKey:key] sortedArrayUsingComparator:^NSComparisonResult(Routine *r1, Routine *r2) {
            return [r1.workoutPlanRoutine.exercise compare:r2.workoutPlanRoutine.exercise];
        }];
        [_displayList setObject:sortedArray forKey:key];
    }

    _sortType = BODY;

    [_routinesTableView reloadData];
    
}

-(void)sortByDay{
    
    [_displayList removeAllObjects];
    for(Routine* r in _currentWorkout.routines){
        for(NSValue *day in r.workoutPlanRoutine.days){

            if(![_displayList objectForKey:day]){
                [_displayList setObject:[NSMutableArray new] forKey:day ];
            }
            [[_displayList objectForKey:day] addObject:r];
        }
        if(r.workoutPlanRoutine.days.count == 0){
            NSValue* day = @(10);
            if(![_displayList objectForKey:day]){
                [_displayList setObject:[NSMutableArray new] forKey:day ];
            }
            [[_displayList objectForKey:day] addObject:r];
        }

    }
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"e"];
    int today = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    if(![_displayList objectForKey:@(today)]){
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Workouts listed for today"
//                                                          message:@"Adding all routines to current workout. You can edit your workout plans to add some to this day of the week."
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
        [_displayList removeAllObjects];
        NSValue* day = @(11);
        [_displayList setObject:[NSMutableArray new] forKey:day ];
        for(Routine* r in _currentWorkout.routines){
             [[_displayList objectForKey:day] addObject:r];
            
        }

    }
    _sortType = DAY;

    [_routinesTableView reloadData];
    
}

-(void)sortAlphabetically{
    [_displayList removeAllObjects];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"e"];
    int today = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [_displayList setObject:[NSMutableArray new] forKey:@"Exercises"];
    for(Routine* r in _currentWorkout.routines){
        if(![r.workoutPlanRoutine.days containsObject:@(today)]){
            continue;
        }
        [[_displayList objectForKey:@"Exercises"] addObject:r];
    }
    NSArray* sortedArray = [[_displayList objectForKey:@"Exercises"] sortedArrayUsingComparator:^NSComparisonResult(Routine *r1, Routine *r2) {
        return [r1.workoutPlanRoutine.exercise compare:r2.workoutPlanRoutine.exercise];
    }];
    
    if(sortedArray.count == 0){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Workouts listed for today"
                                                          message:@"Adding all routines to current workout. You can edit your workout plans to add some to this day of the week."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        for(Routine* r in _currentWorkout.routines){
            
            [[_displayList objectForKey:@"Exercises"] addObject:r];
        }
    }

    sortedArray = [[_displayList objectForKey:@"Exercises"] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
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
                case 2:
                    [self sortByDay];
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
