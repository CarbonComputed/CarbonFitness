//
//  AdvancedSetView.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/19/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "AdvancedSetView.h"

@implementation AdvancedSetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)customView
{
    AdvancedSetView *customView = [[[NSBundle mainBundle] loadNibNamed:@"AdvancedSetView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[AdvancedSetView class]])
        return customView;
    else
        return nil;
}
- (IBAction)startingRepIncButton:(id)sender {
    int current = [_startingRepField.text intValue];
    _startingRepField.text = [NSString stringWithFormat:@"%d",current+1];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];

}
- (IBAction)startingRepDecButton:(id)sender {
    int current = [_startingRepField.text intValue];
    if(current - 1 < 1){
        return;
    }
    _startingRepField.text = [NSString stringWithFormat:@"%d",current-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)endingRepDecButton:(id)sender {
    int current = [_endingRepField.text intValue];
    if(current - 1 < 1){
        return;
    }
    _endingRepField.text = [NSString stringWithFormat:@"%d",current-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)endingRepIncButton:(id)sender {
    int current = [_endingRepField.text intValue];
    _endingRepField.text = [NSString stringWithFormat:@"%d",current+1];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)startingWeightDecButton:(id)sender {
    int current = [_startingWeightField.text intValue];
    if(current - 5 < 1){
        return;
    }
    _startingWeightField.text = [NSString stringWithFormat:@"%d",current-5];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)startingWeightIncButton:(id)sender {
    int current = [_startingWeightField.text intValue];
    _startingWeightField.text = [NSString stringWithFormat:@"%d",current+5];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)endingWeightDecButton:(id)sender {
    int current = [_endingWeightField.text intValue];
    if(current - 5 < 1){
        return;
    }
    _endingWeightField.text = [NSString stringWithFormat:@"%d",current-5];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)endingWeightIncButton:(id)sender {
    int current = [_endingWeightField.text intValue];
    _endingWeightField.text = [NSString stringWithFormat:@"%d",current+5];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
