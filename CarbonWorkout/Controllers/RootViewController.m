//
//  RootViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/8/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "RootViewController.h"
#import "RoutinesViewController.h"
#import "WorkoutPlansViewController.h"

#import "User.h"
#import "Workout.h"
#import "WorkoutPlan.h"
#import "Exercise.h"
#import "Routine.h"

#import <Social/Social.h>


@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _workoutDict = [NSMutableDictionary new];
    }
    return self;
}
- (IBAction)startWorkoutButtonPressed:(id)sender {
    [self startWorkout];
}
- (void)startWorkout{

    if(_currentWorkout){
        //Do you want to continue your saved workout or start a new one?
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue?" message:@"Do you want to continue your saved workout or start a new one?" delegate:self cancelButtonTitle:@"Start New" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"Continue"];
        [alert show];
    }
    else{
        _currentWorkout = [[Workout alloc] initWithWorkoutPlan:[_workoutDict objectForKey:@([User sharedUser].defaultWorkout)]];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //Optionally for time zone converstions
        
        NSString *stringFromStartDate = [formatter stringFromDate:_currentWorkout.startDate];
        [_historyDict setObject:_currentWorkout forKey:stringFromStartDate];
        [self performSelectorInBackground:@selector(saveHistory)
                               withObject:nil];
        
        [self performSegueWithIdentifier:@"startWorkoutSegue" sender:self];

    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        _currentWorkout = nil;
        _currentWorkout = [[Workout alloc] initWithWorkoutPlan:[_workoutDict objectForKey:@([User sharedUser].defaultWorkout)]];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //Optionally for time zone converstions
        
        NSString *stringFromStartDate = [formatter stringFromDate:_currentWorkout.startDate];
        [_historyDict setObject:_currentWorkout forKey:stringFromStartDate];
        [self performSelectorInBackground:@selector(saveHistory)
                               withObject:nil];
        //Code for OK button
    }
    else{
        
    }
    [self performSegueWithIdentifier:@"startWorkoutSegue" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"startWorkoutSegue"])
    {
        // Get reference to the destination view controller
        RoutinesViewController *evc = [segue destinationViewController];

        evc.currentWorkout = _currentWorkout;
        
    }
    else if ([[segue identifier] isEqualToString:@"workoutPlansSegue"])
    {
        // Get reference to the destination view controller
        WorkoutPlansViewController *wvc = [segue destinationViewController];
        
        wvc.workoutDict = _workoutDict;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initUser{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int value = [[prefs objectForKey:@"defaultWorkout"] intValue];
    [User sharedUser].defaultWorkout = value;
    if(value==0){
        [User sharedUser].defaultWorkout = 1;
    }
    
}

-(void) saveUser{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@([User sharedUser].defaultWorkout) forKey:@"defaultWorkout"];
    [prefs synchronize];
}

-(void) initHistory{
    _historyDict = [NSMutableDictionary new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/History.json",
                          documentsDirectory];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    if(data){
        NSDictionary *historyDictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //Optionally for time zone converstions
        
        NSString *stringFromStartDate = [formatter stringFromDate:[NSDate date]];
        for(NSDictionary* workout in [historyDictJson allValues]){
            Workout* w = [[Workout alloc] initWithAttributes:workout withExerciseDictionary:_exerciseDict];
            
            NSString *strDate = [formatter stringFromDate:w.startDate];
            [_historyDict setObject:w forKey:strDate];
        }
        Workout* workout = [_historyDict objectForKey:stringFromStartDate];
        
        
        if(workout){
            if(!workout.isCompleted){
                _currentWorkout = workout;
                //_workoutDict objectForKey:@([User sharedUser].defaultWorkout)]
            }
        }
    }

  

}
- (IBAction)workoutPlansButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"workoutPlansSegue" sender:self];

}
- (IBAction)historyButtonPressed:(id)sender {
            [self performSegueWithIdentifier:@"historySegue" sender:self];
}

-(void) saveWorkouts{
    NSMutableArray* toWriteArray = [NSMutableArray new];

    for(WorkoutPlan* w in [_workoutDict allValues]){
        [toWriteArray addObject:[w dictionaryFromData]];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Workouts.json",
                          documentsDirectory];
    NSError *error = nil;
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    [outputStream open];
    
    
    
    [NSJSONSerialization writeJSONObject:toWriteArray
                                toStream:outputStream
                                 options:0
                                   error:&error];
    [outputStream close];
    
}

-(void) saveHistory{

    //readhistory
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary* toWrite = [NSMutableDictionary new];
    if(_currentWorkout){

        //Optionally for time zone converstions
        
        NSString *stringFromStartDate = [formatter stringFromDate:_currentWorkout.startDate];
        [_historyDict setObject:_currentWorkout forKey:stringFromStartDate];
    }
    for(Workout* w in [_historyDict allValues]){
        NSString *stringFromStartDate = [formatter stringFromDate:w.startDate];
        [toWrite setObject:[w dictionaryFromData] forKey:stringFromStartDate];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/History.json",
                          documentsDirectory];
    NSError *error = nil;
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    [outputStream open];
    
    
    
    [NSJSONSerialization writeJSONObject:toWrite
                                toStream:outputStream
                                 options:0
                                   error:&error];
    [outputStream close];
}

-(void) initExercises{
    _exerciseDict = [NSMutableDictionary new];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Exercises" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *exerciseArrayJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for(NSDictionary* e in exerciseArrayJson){
        Exercise* exercise = [[Exercise alloc] initWithDictionary:e];
        [_exerciseDict setObject:exercise forKey:@(exercise.eid)];
        
    }
    
    
}

-(void) initWorkouts{
    _workoutDict = [NSMutableDictionary new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Workouts.json",
                          documentsDirectory];
    NSData *dataDoc = [NSData dataWithContentsOfFile:fileName];



    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Workouts" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(dataDoc && dataDoc.length > 10){
        data = dataDoc;
    }
    NSArray *workoutArrayJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for(NSDictionary* workout in workoutArrayJson){
        WorkoutPlan* wplan = [[WorkoutPlan alloc] initWithAttributes:workout withExerciseDictionary:_exerciseDict];
        [_workoutDict setObject:wplan forKey:@(wplan.wid)];
    }
    [User sharedUser].workoutDict = _workoutDict;
    //NSDictionary* w = _workoutDict;
}

- (IBAction)shareFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // Configure Compose View Controller
        [vc setInitialText:@"Getting in shape with CarbonFitness!"];
        // Present Compose View Controller
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        // Configure Compose View Controller
        [vc setInitialText:@"Getting in shape with CarbonFitness!"];
        // Present Compose View Controller
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
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
