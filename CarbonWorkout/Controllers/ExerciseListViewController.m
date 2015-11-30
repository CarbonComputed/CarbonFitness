//
//  ExerciseListViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/23/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "ExerciseListViewController.h"
#import "Exercise.h"

enum Sort {ALPHA,BODY};

@interface ExerciseListViewController ()

@property int sortType;
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
    _displayList = [NSMutableDictionary new];
    _selectedExercises = [NSMutableArray new];
    [self.exerciseTableView setDelegate:self];
    [self.exerciseTableView setDataSource:self];
    _sortSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Options: " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Alphabetically",
                            @"Body Type",
                            nil];
    _sortSheet.tag = 1;
    //[_sortSheet showInView:[UIApplication sharedApplication].keyWindow];
    [self sortByBodyType];
    _sortType = BODY;
        // Do any additional setup after loading the view.
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

-(void)sortByBodyType{
    
    [_displayList removeAllObjects];
    for(Exercise* e in _exerciseDict.allValues){
        switch (e.body) {
            case UPPER:
                if(![_displayList objectForKey:@"UPPER BODY"]){
                    [_displayList setObject:[NSMutableArray new] forKey:@"UPPER BODY" ];
                }
                [[_displayList objectForKey:@"UPPER BODY"] addObject:e];
                
                break;
            case LOWER:
                if(![_displayList objectForKey:@"LOWER BODY"]){
                    [_displayList setObject:[NSMutableArray new] forKey:@"LOWER BODY" ];
                }
                [[_displayList objectForKey:@"LOWER BODY"] addObject:e];
                
                break;
            case CORE:
                if(![_displayList objectForKey:@"CORE"]){
                    [_displayList setObject:[NSMutableArray new] forKey:@"CORE" ];
                }
                [[_displayList objectForKey:@"CORE"] addObject:e];
                
                break;
                
            default:
                break;
        }
    }
    for(NSString* key in _displayList.allKeys){
        NSArray* sortedArray = [[_displayList objectForKey:key] sortedArrayUsingComparator:^NSComparisonResult(Exercise *ex1, Exercise *ex2) {
            return [ex1 compare:ex2];
        }];
        [_displayList setObject:sortedArray forKey:key];
    }
    _sortType = BODY;

    [_exerciseTableView reloadData];
}

-(void)sortAlphabetically{
    [_displayList removeAllObjects];
    [_displayList setObject:[NSMutableArray new] forKey:@"Exercises"];
    for(Exercise* e in _exerciseDict.allValues){
        [[_displayList objectForKey:@"Exercises"] addObject:e];
    }
    NSArray* sortedArray = [[_displayList objectForKey:@"Exercises"] sortedArrayUsingComparator:^NSComparisonResult(Exercise *ex1, Exercise *ex2) {
        return [ex1 compare:ex2];
    }];
    _sortType = ALPHA;

    [_displayList setObject:sortedArray forKey:@"Exercises"];
    [_exerciseTableView reloadData];
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
    Exercise* r = [_displayList.allValues[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = r.name;
    cell.detailTextLabel.text = r.description;
    if([_selectedExercises containsObject:r]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_displayList allValues].count;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_displayList allKeys] objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_displayList.allValues[section] count];
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
    if (![_selectedExercises containsObject:[_displayList.allValues[indexPath.section] objectAtIndex:indexPath.row]])  // if not available
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedExercises addObject: [_displayList.allValues[indexPath.section] objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedExercises removeObject: [_displayList.allValues[indexPath.section] objectAtIndex:indexPath.row]];
    }
}
- (IBAction)sortPressed:(id)sender {
    [_sortSheet showInView:[UIApplication sharedApplication].keyWindow];
}


@end
