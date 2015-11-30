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
- (id)initWithFrame:(CGRect)frame setArray:(NSMutableArray*)sets
{
    self = [super initWithFrame:frame];
    if (self) {
        _sets = sets;
        _setButtons = [NSMutableArray new];
        
		NSInteger plusy = -5;
        NSInteger row = 0;
        NSUInteger buttonsLeft = [_sets count];
        NSInteger defaultCirclesPerRow = 5;
        NSInteger buttonsInRow = 0;
        NSInteger viewWidth = frame.size.width;
        NSInteger viewHeight = frame.size.height;
        NSInteger buttonSize = 45;
        if([_sets count] % 5 == 0){
            defaultCirclesPerRow = 5;
        }
        else if([_sets count] % 5 == 1){
            defaultCirclesPerRow = 6;
            buttonSize = 38;
            
        }
        else if([_sets count] % 5 == 2){
            
            defaultCirclesPerRow = 7;
            buttonSize = 34;
            
        }
        else if([_sets count] % 5 == 3){
            
            defaultCirclesPerRow = 5;
            
        }
        else if([_sets count] % 5 == 4){
            
            defaultCirclesPerRow = 5;
            
        }
        if([_sets count] > 10){
            buttonSize = 38;
            defaultCirclesPerRow = 6;
            
        }
        
        for(int i=0;i<[_sets count];i++){
            
            
            
            if(buttonsInRow == defaultCirclesPerRow){
                buttonsInRow = 0;
                plusy += buttonSize + 5;
                buttonsLeft -= defaultCirclesPerRow;
                row += 1;
                if(row % 2==1 && [_sets count] % 5 != 0){
                    //defaultCirclesPerRow = 4;
                }
                else{
                    //defaultCirclesPerRow = 5;
                    
                }
               [_delegate setViewResized:buttonSize];
            }
            
            
            NSUInteger circlesPerRow = MIN(defaultCirclesPerRow, buttonsLeft);
            
            CGFloat xmultiplier = (((2*(buttonsInRow%circlesPerRow) + 2) / (CGFloat)(circlesPerRow + 1)))/2;
            //CGFloat ymultiplier = (((2*(row) + 2) / (CGFloat)(row + 1)))/2;

            NSUInteger x = xmultiplier * viewWidth;
            NSUInteger y = plusy + ((viewHeight/2) - (buttonSize/2));
            //int y = (ymultiplier * viewHeight);
            
            //NSLog(@"%d,%d,%f",plusy,y,xmultiplier);
            UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(x-buttonSize/2, y, buttonSize, buttonSize)];
            setButton.backgroundColor = [UIColor clearColor];
            setButton.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
            setButton.layer.borderWidth = 1;
            setButton.layer.cornerRadius = buttonSize/2;
            setButton.tag = i;
            Set* set = [_sets objectAtIndex:i];
            
            if(set.reps != -1){
                [setButton setBackgroundColor:[UIColor colorWithCGColor:setButton.layer.borderColor]];
                
                [setButton setTitle: [NSString stringWithFormat:@"%ld", (long)set.reps] forState:UIControlStateNormal];
            }
            setButton.userInteractionEnabled = YES;
            [setButton addTarget:self action:@selector(setButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_setButtons addObject:setButton];
            [self addSubview:setButton];
            buttonsInRow++;
            
        // Initialization code
      
        }
    }
    return self;
}

-(void)setSets:(NSMutableArray *)sets{
    
    _sets = sets;
    _setButtons = nil;
    _setButtons = [NSMutableArray new];
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }

    CGRect frame = self.frame;
    NSInteger plusy = -5;
    NSInteger row = 0;
    NSUInteger buttonsLeft = [_sets count];
    NSUInteger defaultCirclesPerRow = 5;
    NSUInteger buttonsInRow = 0;
    NSUInteger viewWidth = frame.size.width;
    NSUInteger viewHeight = frame.size.height;
    NSUInteger buttonSize = 45;
    if([_sets count] % 5 == 0){
        defaultCirclesPerRow = 5;
    }
    else if([_sets count] % 5 == 1){
        defaultCirclesPerRow = 6;
        buttonSize = 38;
        
    }
    else if([_sets count] % 5 == 2){
        
        defaultCirclesPerRow = 7;
        buttonSize = 34;
        
    }
    else if([_sets count] % 5 == 3){
        
        defaultCirclesPerRow = 5;
        
    }
    else if([_sets count] % 5 == 4){
        
        defaultCirclesPerRow = 5;
        
    }
    if([_sets count] > 10){
        buttonSize = 38;
        defaultCirclesPerRow = 6;
        
    }
    
    for(int i=0;i<[_sets count];i++){
        
        
        
        if(buttonsInRow == defaultCirclesPerRow){
            buttonsInRow = 0;
            plusy += buttonSize + 5;
            buttonsLeft -= defaultCirclesPerRow;
            row += 1;
            if(row % 2==1 && [_sets count] % 5 != 0){
                //defaultCirclesPerRow = 4;
            }
            else{
                //defaultCirclesPerRow = 5;
                
            }
            [_delegate setViewResized:buttonSize];
        }
        
        
        NSUInteger circlesPerRow = MIN(defaultCirclesPerRow, buttonsLeft);
        
        CGFloat xmultiplier = (((2*(buttonsInRow%circlesPerRow) + 2) / (CGFloat)(circlesPerRow + 1)))/2;
        //CGFloat ymultiplier = (((2*(row) + 2) / (CGFloat)(row + 1)))/2;
        
        NSUInteger x = xmultiplier * viewWidth;
        NSUInteger y = plusy + ((viewHeight/2) - (buttonSize/2));
        //int y = (ymultiplier * viewHeight);
        
        //NSLog(@"%d,%d,%f",plusy,y,xmultiplier);
        UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(x-buttonSize/2, y, buttonSize, buttonSize)];
        setButton.backgroundColor = [UIColor clearColor];
        setButton.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        setButton.layer.borderWidth = 1;
        setButton.layer.cornerRadius = buttonSize/2;
        setButton.tag = i;
        Set* set = [_sets objectAtIndex:i];
        
        if(set.reps != -1){
            [setButton setBackgroundColor:[UIColor colorWithCGColor:setButton.layer.borderColor]];
            
            [setButton setTitle: [NSString stringWithFormat:@"%ld", (long)set.reps] forState:UIControlStateNormal];
        }
        setButton.userInteractionEnabled = YES;
        [setButton addTarget:self action:@selector(setButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_setButtons addObject:setButton];
        [self addSubview:setButton];
        buttonsInRow++;
    }
}

-(void)setButtonPressed:(UIButton *)sender{
    NSInteger index = sender.tag;
    UIButton* pressed = [_setButtons objectAtIndex:index];
    [pressed setBackgroundColor:[UIColor colorWithCGColor:pressed.layer.borderColor]];
    Set* set = [_sets objectAtIndex:index];
    
    if(set.reps == -1 || set.reps ==0){
        set.reps = set.max_reps;
    }
    else{
        set.reps--;
    }
    [pressed setTitle: [NSString stringWithFormat:@"%ld", (long)set.reps] forState:UIControlStateNormal];

    [_delegate setButtonPressed:sender];
}

@end
