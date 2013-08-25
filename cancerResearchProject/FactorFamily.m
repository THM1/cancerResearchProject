//
//  FactorFamily.m
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "FactorFamily.h"

@implementation FactorFamily

/**
 * Constructor that takes a FactorFamily as input to construct itself
 * Returns pointer to self object
 */
-(FactorFamily *)initWithFactorFamily:(FactorFamily *)factorFamily
{
    self = [super init];
    
    if(self){
        [self setName:[factorFamily getName]];
        [self setBasicInfo:[factorFamily getBasicInfo]
               andMoreInfo:[factorFamily getMoreInfo]];
        
        float pos[3];
        [factorFamily getRelativePos:pos];
        
        [self setPos:pos];
    }
    
    return self;
}

/**
 * Constructor that takes the name, basic info and more info as string inputs, and the position as a float input
 * Uses helper functions to initalise each of the class attributes
 * Returns pointer to self object
 */
-(FactorFamily *)initFactorFamilyName:(NSString *)name withInfo:(NSString *)info andMoreInfo:(NSString *)moreInfo andPos:(float *)pos
{
    self = [super init];
    
    if(self){
        [self setName:name];
        [self setBasicInfo:info
              andMoreInfo:moreInfo];
        [self setPos:pos];
    }
    
    return self;
}

/**
 * Private helper function that sets the name attribute
 */
-(void) setName:(NSString *)name
{
    _name = name;
}

/**
 * Private helper function that sets the basic info and more info attributes
 */
-(void) setBasicInfo:(NSString *)basicInfo andMoreInfo:(NSString *)moreInfo
{
    _basicInfo = basicInfo;
    _evenMoreInfo = moreInfo;
}

/**
 * Private helper function that sets the relative position attribute
 */
-(void) setPos:(float *)pos
{
    for(int i=0; i<3; i++)
        _relativePos[i] = pos[i];
}

/**
 * Public function that returns the name of this object (this factor family)
 */
-(NSString *) getName
{
    return _name;
}
/**
 * Public function that returns the basic info of this object (this factor family)
 */
-(NSString *) getBasicInfo
{
    return _basicInfo;
}
/**
 * Public function that returns the detailed info of this object (this factor family)
 */
-(NSString *) getMoreInfo
{
    return _evenMoreInfo;
}
/**
 * Public function that returns the relative position of this object (this factor family)
 */
-(void)getRelativePos:(float *)pos
{
    for(int i=0; i<3; i++)
        pos[i] = _relativePos[i];

}
@end
