//
//  EditRoutinesViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "EditRoutinesViewController.h"
#import "Set.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 3

CGFloat animatedDistance;

@interface EditRoutinesViewController ()

@property BOOL viewDidLoadCalled;
@property (weak, nonatomic) IBOutlet AdvancedSetView *advancedSetView;

@end

@implementation EditRoutinesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if(_inProgressRoutine){
            SetTrack* s = [_inProgressRoutine.setTrack copyWithZone:nil];
            _inProgressRoutine = [_inProgressRoutine initWithWorkoutPlanRoutine:_currentRoutine];
            NSInteger i =0;
            NSInteger weight=-1;
            for(Set* set in s.sets){
                if(i >= _inProgressRoutine.setTrack.sets.count){
                    break;
                }
                if(set.reps > -1){
                    [_inProgressRoutine.setTrack.sets setObject:set atIndexedSubscript:i];
                    
                }
                else{
                    if(weight<0){
                        weight = [[_inProgressRoutine.setTrack.sets objectAtIndex:i] weight];
                    }
                }
                i++;
            }
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    _viewDidLoadCalled = false;
    [super viewDidLoad];

    [self registerForKeyboardNotifications];
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    [_segmentedControl initWithItems:@[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"]];
	
	_segmentedControl.allowsMultiSelection = YES;
    
    _exerciseNameLabel.text = _currentRoutine.exercise.name;
    _exerciseDescLabel.text = _currentRoutine.exercise.description;

    


    _viewDidLoadCalled = true;
    [self.view setUserInteractionEnabled:true];

    [_containerView setUserInteractionEnabled:true];
    
    [_setsField setDelegate:self];
    [_repsField setDelegate:self];
    [_weightField setDelegate:self];
    
    [_advancedSetView.startingRepField setDelegate:self];
    [_advancedSetView.startingWeightField setDelegate:self];
    [_advancedSetView.endingRepField setDelegate:self];
    [_advancedSetView.endingWeightField setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startingRepChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedSetView.startingRepField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startingWeightChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedSetView.startingWeightField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endingRepChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedSetView.endingRepField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endingWeightChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedSetView.endingWeightField];

    
    self.advancedSetView.hidden = NO;
    [self updateTextBoxes];

    
    // Do any additional setup after loading the view.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
}

-(void)updateTextBoxes{
    NSArray* days = [_currentRoutine.days allObjects];
    for(int i = 0;i<days.count;i++){
        int j = [[days objectAtIndex:i] intValue] -1;
        
        [_segmentedControl selectSegmentWithIndex:j];
    }
    if(_currentRoutine.incrementType > 0){
        _advancedSetView.hidden = false;
    }
    else{
        _advancedSetView.hidden = true;
    }
    _currentRoutine.sets = MAX(_currentRoutine.sets, _currentRoutine.incrementType + 1);
    [_incrementControl setSelectedSegmentIndex:_currentRoutine.incrementType];

//    _maxLabel.text = [NSString stringWithFormat:@"MAX: %ld",_currentRoutine.max];
    _setsField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.sets];
    _repsField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.startingReps];
    _weightField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.startingWeight];
    _advancedSetView.startingRepField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.startingReps];
    _advancedSetView.startingWeightField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.startingWeight];
    _advancedSetView.endingRepField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.endingReps];
    _advancedSetView.endingWeightField.text = [NSString stringWithFormat:@"%ld",_currentRoutine.endingWeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setIncreaseButton:(id)sender {
    if(_currentRoutine.sets + 1 > 100){
        return;
    }
    _currentRoutine.sets += 1;
    [self updateTextBoxes];

}
- (IBAction)viewTapped:(id)sender {

    for (UIView* view in _containerView.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
    for (UIView* view in _advancedSetView.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
    for (UIView* view in _reffedView.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
    
}
- (IBAction)setDecreaseButton:(id)sender {
    if(_currentRoutine.sets - 1 < 1){
        return;
    }
    if(_currentRoutine.incrementType == 1 && _currentRoutine.sets - 1 < 2){
        return;
    }
    else if(_currentRoutine.incrementType == 2 && _currentRoutine.sets - 1 < 3){
        return;
    }
    _currentRoutine.sets -= 1;
    [self updateTextBoxes];
}
- (IBAction)repsIncreaseButton:(id)sender {
    _currentRoutine.startingReps += 1;
    [self updateTextBoxes];
}
- (IBAction)repsDecreaseButton:(id)sender {
    if(_currentRoutine.startingReps - 1 < 1){
        return;
    }
    _currentRoutine.startingReps -= 1;
    [self updateTextBoxes];
}
- (IBAction)weightIncreaseButton:(id)sender {
    _currentRoutine.startingWeight += 5;
    [self updateTextBoxes];
}
- (IBAction)weightDecreaseButton:(id)sender {
    if(_currentRoutine.startingWeight - 5 < 0){
        return;
    }
    _currentRoutine.startingWeight -= 5;
    [self updateTextBoxes];
}
- (IBAction)daysChanged:(id)sender {
    if(_viewDidLoadCalled){
        _currentRoutine.days = nil;
        _currentRoutine.days = [NSMutableSet new];
        NSUInteger index=[_segmentedControl.selectedSegmentIndice firstIndex];
        
        while(index != NSNotFound)
        {
            [_currentRoutine.days addObject:@(index+1)];
            
            index=[_segmentedControl.selectedSegmentIndice indexGreaterThanIndex: index];
        }
    }


    
}



- (IBAction)setEditingChanged:(id)sender {
    _currentRoutine.sets = [_setsField.text intValue];
    [self updateTextBoxes];
}
- (IBAction)repsEditingChaned:(id)sender {
    _currentRoutine.startingReps = [_repsField.text intValue];
    [self updateTextBoxes];

}
- (IBAction)weightEndingChanged:(id)sender {
    _currentRoutine.startingWeight = [_weightField.text intValue];
    [self updateTextBoxes];
}

- (IBAction)startingRepChanged:(id)sender {
    _currentRoutine.startingReps = [_advancedSetView.startingRepField.text intValue];
}

- (IBAction)startingWeightChanged:(id)sender {
    _currentRoutine.startingWeight = [_advancedSetView.startingWeightField.text intValue];
}

- (IBAction)endingRepChanged:(id)sender {
    _currentRoutine.endingReps = [_advancedSetView.endingRepField.text intValue];
}

- (IBAction)endingWeightChanged:(id)sender {
    _currentRoutine.endingWeight = [_advancedSetView.endingWeightField.text intValue];
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}



- (IBAction)incrementTypeChanged:(id)sender {
    _currentRoutine.incrementType = _incrementControl.selectedSegmentIndex;
    [self updateTextBoxes];
}


- (void)keyboardDidShow: (NSNotification *) notif{
    [_scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    [_scrollView setContentOffset:CGPointMake(0, -65) animated:YES];

}

@end
