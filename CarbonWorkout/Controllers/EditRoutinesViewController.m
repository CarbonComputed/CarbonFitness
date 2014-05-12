//
//  EditRoutinesViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/17/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "EditRoutinesViewController.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 3

@interface EditRoutinesViewController ()

@property BOOL viewDidLoadCalled;

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
    
    [_advancedView.startingRepField setDelegate:self];
    [_advancedView.startingWeightField setDelegate:self];
    [_advancedView.endingRepField setDelegate:self];
    [_advancedView.endingWeightField setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startingRepChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedView.startingRepField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startingWeightChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedView.startingWeightField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endingRepChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedView.endingRepField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endingWeightChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_advancedView.endingWeightField];

    
    
    AdvancedSetView *customView = [AdvancedSetView customView];
    _advancedView = customView;
  
    
    customView.frame = _reps_weightView.frame;
    customView.hidden = true;
    [_containerView addSubview:customView];
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
        _advancedView.hidden = false;
    }
    else{
        _advancedView.hidden = true;
    }
    _currentRoutine.sets = MAX(_currentRoutine.sets, _currentRoutine.incrementType + 1);
    [_incrementControl setSelectedSegmentIndex:_currentRoutine.incrementType];

    _maxLabel.text = [NSString stringWithFormat:@"MAX: %d",_currentRoutine.max];
    _setsField.text = [NSString stringWithFormat:@"%d",_currentRoutine.sets];
    _repsField.text = [NSString stringWithFormat:@"%d",_currentRoutine.startingReps];
    _weightField.text = [NSString stringWithFormat:@"%d",_currentRoutine.startingWeight];
    _advancedView.startingRepField.text = [NSString stringWithFormat:@"%d",_currentRoutine.startingReps];
    _advancedView.startingWeightField.text = [NSString stringWithFormat:@"%d",_currentRoutine.startingWeight];
    _advancedView.endingRepField.text = [NSString stringWithFormat:@"%d",_currentRoutine.endingReps];
    _advancedView.endingWeightField.text = [NSString stringWithFormat:@"%d",_currentRoutine.endingWeight];
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
    for (UIView* view in _advancedView.subviews) {
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
    _currentRoutine.startingReps = [_advancedView.startingRepField.text intValue];
}

- (IBAction)startingWeightChanged:(id)sender {
    _currentRoutine.startingWeight = [_advancedView.startingWeightField.text intValue];
}

- (IBAction)endingRepChanged:(id)sender {
    _currentRoutine.endingReps = [_advancedView.endingRepField.text intValue];
}

- (IBAction)endingWeightChanged:(id)sender {
    _currentRoutine.endingWeight = [_advancedView.endingWeightField.text intValue];
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}



- (IBAction)incrementTypeChanged:(id)sender {
    _currentRoutine.incrementType = _incrementControl.selectedSegmentIndex;
    [self updateTextBoxes];
}


- (void)keyboardWasShown:(NSNotification *)notification {
    
//    NSDictionary* info = [notification userInfo];
//    
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    CGPoint buttonOrigin = self.advancedView.frame.origin;
//    
//    CGFloat buttonHeight = self.advancedView.frame.size.height;
//    
//    CGRect visibleRect = self.view.frame;
//    
//    visibleRect.size.height -= keyboardSize.height;
//    
//    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
//        
//        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
//        
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
//        
//    }
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
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
