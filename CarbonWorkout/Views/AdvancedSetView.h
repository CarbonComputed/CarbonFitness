//
//  AdvancedSetView.h
//  CarbonWorkout
//
//  Created by Kevin Carbone on 4/19/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSetView : UIView
@property (weak, nonatomic) IBOutlet UITextField *startingRepField;
@property (weak, nonatomic) IBOutlet UITextField *endingRepField;
@property (weak, nonatomic) IBOutlet UITextField *startingWeightField;
@property (weak, nonatomic) IBOutlet UITextField *endingWeightField;


+ (id)customView;
@end
