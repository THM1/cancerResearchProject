//
//  FactorFamily.h
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

/*! 
 \class FactorFamily FactorFamily.h
 \brief  Created by THM on 7/13/13. Copyright (c) 2013 THM. All rights reserved.
 
 FactorFamily class is the parent of the FactorAtLink class.
 
 The Link class contains an array of FactorFamily as a class variable, since EACH Link must have
 the FactorAtLink details for EACH FactorFamily
 
 It contains general information of a gene regulation factor:
    1. the name
    2. string with basic info (such as what processes this regulation factor is involved in)
    3. string with even more info (such as all the genes it regulates)
 
    4. it's relative position in the factor map (created by Graphviz), which can be used to calculate 
       it's actual position on the screen, depending on the Link's position
 */

#import <Foundation/Foundation.h>

@interface FactorFamily : NSObject{
@private
    NSString *_name;            //! name of the factor family
    NSString *_basicInfo;       //! basic info of this factor family such as what processes it is involved in
    NSString *_evenMoreInfo;    //! more info such as a list of all the genes regulated by this factor
    
    float _relativePos[3];
}

-(FactorFamily *)initFactorFamilyName:(NSString *)name withInfo:(NSString *)info andMoreInfo:(NSString *)moreInfo andPos:(float *)pos;
-(FactorFamily *)initWithFactorFamily:(FactorFamily *)factorFamily;

//-(void) setName:(NSString *)name;
//-(void) setBasicInfo:(NSString *)basicInfo andMoreInfo:(NSString *)moreInfo;

-(NSString *) getName;
-(NSString *) getBasicInfo;
-(NSString *) getMoreInfo;

-(void) getRelativePos:(float *)pos;
@end
