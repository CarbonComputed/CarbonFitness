//
//  SetView.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 5/11/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "SetView.h"
#import "Set.h"

@implementation SetView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self layoutSets];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSets];
    }
    return self;
}

-(void)layoutSets {
    for (UIButton *button in self.setButtons) {
        [button removeFromSuperview];
    }
    _setButtons = [NSMutableArray new];
    for(NSInteger i = 0;i < [self.sets count] ;i++) {
        UIButton *setButton = [self buttonAtIndex:i];
        [self addSubview:setButton];
        [self constrainButton:setButton atIndex:i];
        [_setButtons addObject:setButton];
    }
}

-(void)constrainButton:(UIButton *)button atIndex:(NSInteger)index {
    NSInteger buttonDiameter = [self diameterPerButton];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:buttonDiameter];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:buttonDiameter];
    NSInteger row = (index / [self circlesPerRow]);
    NSInteger indexOfButtonInRow = index % [self circlesPerRow];
    CGFloat totalCirclesInRow = [self circlesPerRow];
    CGFloat totalRows = ceil((CGFloat) self.sets.count / (CGFloat) [self circlesPerRow]);

    if (row == totalRows - 1&&
        self.sets.count % [self circlesPerRow] != 0) {
        totalCirclesInRow = self.sets.count % [self circlesPerRow];
        indexOfButtonInRow = totalCirclesInRow - (self.sets.count - index);
    }
    CGFloat xmultiplier = (CGFloat) (indexOfButtonInRow + 1) / (totalCirclesInRow + 1) + 0.0001;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:xmultiplier
                                                                       constant:0];

    
    
    CGFloat ySpacing = 10;
    CGFloat constant = (row) * ([self diameterPerButton] + ySpacing);

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:constant];
    [self addConstraints:@[widthConstraint, heightConstraint, leftConstraint, topConstraint]];
}

-(UIButton *)buttonAtIndex:(NSInteger)index {
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectZero];
    setButton.translatesAutoresizingMaskIntoConstraints = NO;
    setButton.backgroundColor = [UIColor clearColor];
    setButton.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    setButton.layer.borderWidth = 1;
    setButton.layer.cornerRadius = [self diameterPerButton] / 2;
    Set* set = [self.sets objectAtIndex:index];
    
    if(set.reps >= 0){
        [setButton setBackgroundColor:[UIColor colorWithCGColor:setButton.layer.borderColor]];
        
        [setButton setTitle: [NSString stringWithFormat:@"%ld", (long)set.reps] forState:UIControlStateNormal];
    }
    setButton.userInteractionEnabled = YES;
    [setButton addTarget:self action:@selector(setButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return setButton;
}

-(NSInteger)diameterPerButton {
    NSInteger buttonSize = 48;
    if([self.sets count] % 5 == 1 || [self.sets count] > 10){
        buttonSize = 38;
        
    }
    else if([self.sets count] % 5 == 2){
        buttonSize = 34;
    }
    return buttonSize;
}

-(NSInteger)circlesPerRow {
    NSInteger defaultCirclesPerRow = 6;
    if([self.sets count] % 5 == 0){
        defaultCirclesPerRow = 5;
    }
    else if([self.sets count] % 5 == 1 || [self.sets count] > 10){
        defaultCirclesPerRow = 6;
    }
    else if([self.sets count] % 5 == 2){
        defaultCirclesPerRow = 7;
    }
    else if([self.sets count] % 5 == 3){
        defaultCirclesPerRow = 5;
        
    }
    else if([self.sets count] % 5 == 4){
        defaultCirclesPerRow = 5;
        
    }
    return defaultCirclesPerRow;
}

-(void)setSets:(NSArray *)sets {
    _sets = sets;
    [self layoutSets];
    CGFloat totalRows = ceil((CGFloat) self.sets.count / (CGFloat) [self circlesPerRow]);
    CGFloat constant = (totalRows-1) * ([self diameterPerButton] + 10);
    if (totalRows > 1) {
        constant -= [self diameterPerButton] - 10;
    }
    [self.delegate setViewResized:constant];
    [self setNeedsLayout];
    [self layoutSubviews];
}

-(void)setButtonPressed:(UIButton *)sender{
    UIButton* pressed = sender;
    NSInteger index = [self.setButtons indexOfObject:sender];
    [pressed setBackgroundColor:[UIColor colorWithCGColor:pressed.layer.borderColor]];
    Set* set = [self.sets objectAtIndex:index];
    
    if(set.reps == -1 || set.reps == 0){
        set.reps = set.max_reps;
    }
    else{
        set.reps--;
    }
    [pressed setTitle: [NSString stringWithFormat:@"%ld", (long)set.reps] forState:UIControlStateNormal];

    [_delegate setButtonPressed:sender];
}

@end
