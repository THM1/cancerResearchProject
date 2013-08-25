//
//  Stage.m
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Stage.h"

@implementation Stage

/**
 * Constructor that takes the name and position as inputs
 * Sets the attributes of the object to the input variables
 * Returns pointer to self
 */
-(Stage *)initWithName:(NSString *)name andPosition:(float *)pos
{
    self = [super init];
    
    if(self){
        [self setName:name];
        [self setPos:pos];
    }
    
    return self;
}

/**
 * Private helper function that sets the name attribute
 */
-(void)setName:(NSString *)name
{
    //NSString *newName = [[NSString alloc] initWithString:name];
    //_name = newName;
    _name = name;
}

/**
 * Private helper function that sets the position attribute
 */
-(void)setPos:(float *)pos
{
    for(int i=0; i<2; i++)
        _pos[i] = pos[i];
    
    _pos[2] = 0;
}

/**
 * Public function that returns the name of this stage
 */
-(NSString *)getName
{
    return _name;
}

/**
 * Public function that modifies the input variable to the position of this stage
 */
-(void)getPos:(float *)pos
{
    for(int i=0; i<3; i++)
        pos[i] = _pos[i];
}
/**
 * Public function that returns the position of this stage as a CGPoint
 */
-(CGPoint)getCGPoint
{
    CGPoint pos = CGPointMake(_pos[0], _pos[1]);
    return pos;
}

/**
 * Public function that creates and returns the label for this stage
 * with the input label size
 */
-(UILabel *)getLabel
{
    float labelSize[2] = {100, 40};

    CGRect stageRect = CGRectMake(_pos[0] - labelSize[0]*0.5,    // label starts at top right but we want tempPos to be the central
                                  _pos[1] - labelSize[1]*0.5,    // position of the label, so adjust by shifting half labelSize in x & y
                                  labelSize[0],
                                  labelSize[1]);
    
    UILabel *label = [[UILabel alloc] initWithFrame:stageRect];
    //[label setText:[tempStage getName]];
    label.text = [self getName];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


@end
