//
//  ExerciseViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/9/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "RoutineViewController.h"
#import "EditRoutinesViewController.h"
#import "Set.h"
#import "RootViewController.h"
#import "WorkoutPlan.h"
#import <AFNetworking/AFNetworking.h>

@interface RoutineViewController ()
@property int timeSec;
@property int timeMin;
@property int timeHour;
@end

@implementation RoutineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
        
    }
    return self;
}

-(void)setViewResized:(int)buttonSize{
                _heightConstraint.constant += buttonSize;
                _distanceToTimeCon.constant -= buttonSize;
                if(_distanceToTimeCon.constant < 95 ){
                    _distanceToImageCon.constant -= buttonSize;
    
                }
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [_setView layoutIfNeeded];
                                 } completion:nil
                 ];
}

- (void)loadView
{
    [super loadView];
    [self loadWorkoutImage];
    _setView.delegate = self;
    _setView  = [_setView initWithFrame:_setView.frame setArray:_routine.setTrack.sets];
}
- (IBAction)labelSwiped:(id)sender {
    [self hideNotLabel];

}

-(void)hideNotLabel{
    [UIView animateWithDuration:.2
                     animations:^{
                         //if(_popdownHidden == false){
                         //    _popdownHidden = true;
                         _topSpaceToLayout.constant = -_popdownLabel.frame.size.height;

                             _topSpaceToLayout.constant -= _popdownLabel.frame.size.height;

                         //}
                         
                         [_popdownLabel layoutIfNeeded];
                     }
                     completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
                         

                         //_popdownLabel.hidden = finished;//if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
                     }];
}

-(void)loadWorkoutImage{
    NSURL *url = [NSURL URLWithString:_routine.workoutPlanRoutine.exercise.imagePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    postOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        _imageView.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [postOperation start];
}



-(void)showNotLabel:(NSString*)message afterDelay:(NSTimeInterval) t{
    _popdownLabel.text = message;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideNotLabel)
                                               object:nil];
    [UIView animateWithDuration:0.2
                     animations:^{
                         //if(_popdownHidden){
                         //    _popdownHidden = false;
                         _topSpaceToLayout.constant = -_popdownLabel.frame.size.height;
                             _topSpaceToLayout.constant += _popdownLabel.frame.size.height;

                         //}
                         
                         [_popdownLabel layoutIfNeeded];
                     }
                     completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
                         
                         //_popdownLabel.hidden = finished;//if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
                         if(t>0){
                             
                             [self performSelector:@selector(hideNotLabel) withObject:nil afterDelay:t];
                             

                         }

                     }];
    
}

-(void)setButtonPressed:(UIButton *)sender
{
    _timeSec = 0;
    _timeMin = 0;
    _timeHour = 0;
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d",  _timeMin, _timeSec];
    [[self exerciseTimerLabel] setText:timeNow];

    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(startSetTimer)
                                               object:nil];
    [_setTimer invalidate];
    int index = sender.tag;


    
    

    int completed = [_routine completedRoutine];
    if(completed == 0){
        NSString* str = [NSString stringWithFormat:@"Keep trying! Stick with the weight: %@", _weightLabel.text];
        [self showNotLabel:str afterDelay:5];
    }
    else if(completed == 1){

        
        if(_currentWorkout != nil){
            for(WorkoutPlanRoutine* wpr in _currentWorkout.currentPlan.workoutPlanRoutines){
                //should use an actual id here
                if(wpr.exercise.eid == _routine.workoutPlanRoutine.exercise.eid){
                    wpr.startingWeight += 5;
                    wpr.endingWeight += 5;
                    if(_routine.workoutPlanRoutine.max > wpr.max  ){
                        wpr.max = _routine.workoutPlanRoutine.max;
                    }
                }
            }
            Set* set = [_routine.setTrack.sets objectAtIndex:index];
            _weightLabel.text = [NSString stringWithFormat:@"%dlbs", set.weight];
            NSString* str = [NSString stringWithFormat:@"Nice Job! Next Starting Weight: %dlbs",_routine.workoutPlanRoutine.startingWeight+5];
            [self showNotLabel:str afterDelay:5];
        }
        
        

    }
    else{
        [self performSelector:@selector(startSetTimer) withObject:nil afterDelay:0.5];
        if(index + 1 < [_routine.setTrack.sets count]){
            Set* set2 = [_routine.setTrack.sets objectAtIndex:index+1];
            _weightLabel.text = [NSString stringWithFormat:@"%dlbs", set2.weight];
        }
    }


    // index = 1234;
}



-(void)startSetTimer{

    
    if(!_setTimer || ![_setTimer isValid]){
        _setTimer = nil;
        _setTimer = [NSTimer timerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(setTimerDidTick:)
                                          userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_setTimer forMode:NSRunLoopCommonModes];

    }

    

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [_setTimer invalidate];
    }
    [super viewWillDisappear:animated];
}

-(void)setTimerDidTick:(NSTimer*) theTimer{
    if(_timeHour==0 &&_timeMin==0 && _timeSec == 0){
        NSString* str = [NSString stringWithFormat:@"If it was easy, rest 90 sec. If not, 3 min. Next weight: %@", _weightLabel.text];
        [self showNotLabel:str afterDelay:5];
    }
    _timeSec++;
    if (_timeSec == 60)
    {
        _timeSec = 0;
        _timeMin++;
    }
    if(_timeMin == 60){
        _timeMin = 0;
        _timeHour++;
    }
    if(_timeMin == 1 && _timeSec == 0){
        NSString* str = [NSString stringWithFormat:@"60 Seconds have passed since your last set."];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotification.alertBody = str;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self showNotLabel:str afterDelay:5];
    }
    if(_timeMin == 1 && _timeSec == 30){
        NSString* str = [NSString stringWithFormat:@"90 Seconds have passed since your last set."];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotification.alertBody = str;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self showNotLabel:str afterDelay:5];
    }
    if(_timeMin == 3 && _timeSec == 0){
        NSString* str = [NSString stringWithFormat:@"3 minutes have passed since your last set."];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotification.alertBody = str;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self showNotLabel:str afterDelay:5];
    }
    if(_timeMin == 5 && _timeSec == 0){
        NSString* str = [NSString stringWithFormat:@"5 minutes have passed since your last set."];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotification.alertBody = str;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self showNotLabel:str afterDelay:5];
    }
    //Format the string 00:00
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d",  _timeMin, _timeSec];
    [[self exerciseTimerLabel] setText:timeNow];
}

-(void)clearSetTimer{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _exerciseLabel.text = [_routine.workoutPlanRoutine.exercise.name uppercaseString];
    if([_routine.setTrack.sets count] > 0){
        Set* set = [_routine.setTrack.sets objectAtIndex:0];
        
        
        _weightLabel.text = [NSString stringWithFormat:@"%dlbs", set.weight];
    }

    //_maxLabel.text =  [NSString stringWithFormat:@"Max: %dlbs", _routine.workoutPlanRoutine.max];


    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end