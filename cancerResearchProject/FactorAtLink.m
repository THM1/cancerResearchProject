//
//  FactorAtStage.m
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "FactorAtLink.h"

@implementation FactorAtLink

/**
 * FactorAtLink constructor
 * Input variables are FactorFamily (parent object), pValue and oddsRatio
 * Calls the constructor of the parent object, passing the input variable FactorFamily
 * Initialises the pValue and oddsRatio of the object
 * Returns pointer to itself
 */
-(FactorAtLink *) initWithFactorFamily: (FactorFamily *)factorFam andPValue:(float *)pVal andOddsRatio: (float *)oddsRatio
{
    // parent constructor
    self = [super initWithFactorFamily:factorFam];
    
    if(self){
        [self setPValue:pVal];
        [self setOddsRatio:oddsRatio];
    }

    return self;
}

/**
 * Helper function that sets the pValue to the pValue passed in
 */
-(void) setPValue:(float *)pVal
{
    _pValue = *pVal;
}
/**
 * Helper function that sets the oddsRatio to the oddsRatio passed in
 */
-(void) setOddsRatio:(float *)oddsRatio
{
    _oddsRatio = *oddsRatio;
}

/**
 * Private function that returns the colour (for the label) depending on the pValue
 */
-(UIColor *) getColourForPValue: (float *)pVal
{
    UIColor *colour;
    
    if(*pVal > 0.05f) colour = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    else if(*pVal > 10e-2) colour = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
    else if(*pVal > 10e-5) colour = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
    else if(*pVal > 10e-10) colour = [UIColor blackColor];
    else if(*pVal > 10e-20) colour = [UIColor colorWithRed:1.0f green:0.8f blue:0.8f alpha:1.0f];
    else if(*pVal > 10e-50) colour = [UIColor colorWithRed:1.0f green:0.6f blue:0.6f alpha:1.0f];
    else if(*pVal > 10e-100) colour = [UIColor colorWithRed:1.0f green:0.4f blue:0.4f alpha:1.0f];
    else colour = [UIColor redColor];

    return colour;
}

/**
 * Private function that returns the font size (for the label) depending on the odds Ratio
 */
-(float) getFontSizeForOddsRatio:(float *)oddsRatio
{
    float fontsize = 8.0f;
    
    if(*oddsRatio > 4.0f) fontsize = 15.0f;
    else if(*oddsRatio > 3.5f) fontsize = 14.0f;
    else if(*oddsRatio > 3.0f) fontsize = 13.0f;
    else if(*oddsRatio > 2.5f) fontsize = 12.0f;
    else if(*oddsRatio > 2.0f) fontsize = 11.0f;
    else if(*oddsRatio > 1.5f) fontsize = 10.0f;
    else if(*oddsRatio > 1.1f) fontsize = 9.0f;

    return fontsize;
}

/**
 * Public function that uses a helper function to get the colour of the label
 * Returns the colour
 */
-(UIColor *)getColour
{
    UIColor *colour = [[UIColor alloc] init];
    colour = [self getColourForPValue:&(_pValue)];
    return colour;
}

/**
 * Public function that uses a helper function to get the font size of the label
 * Returns the font size
 */
-(float)getFontSize
{
    return [self getFontSizeForOddsRatio:&_oddsRatio];
}


-(UILabel *)getLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    return label;
}

@end












