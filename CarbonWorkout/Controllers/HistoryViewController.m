//
//  HistoryViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/15/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//


#import "HistoryViewController.h"
#import "RootViewController.h"
#import "RoutinesViewController.h"


@interface HistoryViewController ()


@end

@implementation HistoryViewController

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

    
    NSString *monthName = [[_calendarView.dateFormatter standaloneMonthSymbols] objectAtIndex: _calendarView.displayedMonth - 1];
    self.monthLabel.text = [NSString stringWithFormat: @"%@ %lu", monthName, _calendarView.displayedYear];
    [_calendarView setNeedsLayout];
    
    [self highlightHistory];
    _calendarView.delegate = self;

    // Do any additional setup after loading the view.
}

-(void)highlightHistory{

    UINavigationController* nav = (UINavigationController*) self.navigationController;
    RootViewController* rvc = (RootViewController*) [nav.childViewControllers objectAtIndex:0];
    NSMutableDictionary* historyDict = rvc.historyDict;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //Optionally for time zone converstions
    
    for(NSString* d in [historyDict allKeys]){
        [_calendarView highlightDate:[formatter dateFromString:d]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)swipedLeft:(id)sender {
    [self monthBackward:sender];
}

- (IBAction)swipedRight:(id)sender {
    [self monthForward:sender];
}

- (IBAction)monthForward:(id)sender {
    
    //UIView* v = _calendarView;
    
    [_calendarView resetHighlights];
    
    
	_leftConstraint.constant += _calendarView.frame.size.width;

    [UIView animateWithDuration:.3
                     animations:^{

                         [_calendarView.superview layoutIfNeeded];
                     }
                     completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
                         _leftConstraint.constant -= _calendarView.frame.size.width;
                         _leftConstraint.constant -= _calendarView.frame.size.width;
                         NSDateComponents *monthStep = [NSDateComponents new];
                         monthStep.month = -1;
                         
                         _calendarView.displayedDate = [_calendarView.calendar dateByAddingComponents: monthStep toDate: _calendarView.displayedDate options: 0];
                         NSString *monthName = [[_calendarView.dateFormatter standaloneMonthSymbols] objectAtIndex: _calendarView.displayedMonth - 1];
                         self.monthLabel.text = [NSString stringWithFormat: @"%@ %lu", monthName, _calendarView.displayedYear];
                         [_calendarView setNeedsLayout];
                         [_calendarView layoutIfNeeded];
						 _leftConstraint.constant += _calendarView.frame.size.width;

                         [UIView animateWithDuration:.3
                                          animations:^{
                                              [_calendarView layoutIfNeeded];
                                          }
                                          completion: ^(BOOL finished) {
                                              [self highlightHistory];

                                              
                                          }];
                         

                     }];
    
    
}


- (IBAction)monthBackward:(id)sender {
	[_calendarView resetHighlights];

	_leftConstraint.constant -= _calendarView.frame.size.width;
	
	[UIView animateWithDuration:.3
					 animations:^{
						 
						 [_calendarView.superview layoutIfNeeded];
					 }
					 completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
						 _leftConstraint.constant += _calendarView.frame.size.width;
						 _leftConstraint.constant += _calendarView.frame.size.width;
						 NSDateComponents *monthStep = [NSDateComponents new];
						 monthStep.month = 1;
						 
						 _calendarView.displayedDate = [_calendarView.calendar dateByAddingComponents: monthStep toDate: _calendarView.displayedDate options: 0];
						 NSString *monthName = [[_calendarView.dateFormatter standaloneMonthSymbols] objectAtIndex: _calendarView.displayedMonth - 1];
						 self.monthLabel.text = [NSString stringWithFormat: @"%@ %lu", monthName, _calendarView.displayedYear];
						 [_calendarView setNeedsLayout];
						 [_calendarView layoutIfNeeded];
						 _leftConstraint.constant -= _calendarView.frame.size.width;
						 
						 [UIView animateWithDuration:.3
										  animations:^{
											  [_calendarView layoutIfNeeded];
										  }
										  completion: ^(BOOL finished) {
											  [self highlightHistory];
											  
											  
										  }];
						 
						 
					 }];

 
}

-(void)cellButtonClicked:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    UINavigationController* nav = (UINavigationController*) self.navigationController;
    RootViewController* rvc = (RootViewController*) [nav.childViewControllers objectAtIndex:0];
    Workout* workout =[rvc.historyDict objectForKey:[formatter stringFromDate:date]];
    if(!workout.isCompleted){
        //ask to see if they would like to continue workout or
    }
    [self performSegueWithIdentifier:@"historyWorkoutSegue" sender:workout];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"historyWorkoutSegue"])
    {
        // Get reference to the destination view controller
        RoutinesViewController *evc = [segue destinationViewController];
        evc.fromHistory = true;
        Workout* w = sender;
        evc.currentWorkout = w;
        
        
    }
}


@end
