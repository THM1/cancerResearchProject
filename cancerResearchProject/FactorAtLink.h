//
//  FactorAtStage.h
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

/*! 
 \class FactorAtLink FactorAtLink.h
 \brief  Created by THM on 7/13/13. Copyright (c) 2013 THM. All rights reserved.
 
 FactorAtLink class inherits from the general FactorFamily class, and contains the attributes
 of the factor depending on the link. 
 
 Each Link object creates an array of FactorAtLink objects, initialised with the correct
 attributes.
 
 FactorAtLink has two attributes; _pValue and _oddsRatio (properties of a gene factor) 
 */

#import <Foundation/Foundation.h>
#import "FactorFamily.h"

@interface FactorAtLink : FactorFamily{
@private
    float _pValue;       //! pValue of the factor, represented by the colour of it's label
    float _oddsRatio;    //! odds ratio of the factor, represented by the font size of it's label
}

-(FactorAtLink *) initWithFactorFamily: (FactorFamily *)factorFam andPValue:(float *)pVal andOddsRatio: (float *)oddsRatio;

-(void) setPValue: (float *)pVal;
-(void) setOddsRatio: (float *)oddsRatio;

-(UIColor *)getColour;
-(float)getFontSize;

//-(UILabel *)getLabel;
@end
