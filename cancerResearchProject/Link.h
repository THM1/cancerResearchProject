//
//  Link.h
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//


/*! \class Link Link.h
    \brief  Created by THM on 7/13/13. Copyright (c) 2013 THM. All rights reserved.
 
 A more detailed class description.
 */

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "FactorFamily.h"
#import "FactorAtLink.h"
#import "Stage.h"

enum geneRegulationMapType {
    UP = 0,
    DOWN = 1,
    ALL = 2
};

@interface Link : NSObject{
    Stage *_prev, *_next;
    float _pos[3];
    BOOL _touchFlag;
    UIImageView *_arrowImage;
    
    //NSMutableDictionary *_factorsAtLink;
    //NSMutableDictionary *_pValues;
    //NSMutableDictionary *_oddsRatios;
    
    //NSMutableDictionary *_factorFamilies;
    
    NSMutableDictionary *_factorData[3];    // up, down, all
    NSMutableArray *_factorLabels[3];       // up, down, all

}

//-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next andKeys:(NSArray *)keys andPValues:(NSArray *)pVals andOddsRatios:(NSArray *)oddsRatios;
-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next;
//-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next andKeys:(NSArray *)keys andFactors:(NSArray *)factorsAtStage;
/*
-(void)setPValueWithKey:(NSString *)key andNewValue:(NSString *)newValue;
-(void)setOddsRatioWithKey:(NSString *)key andNewRatio:(NSString *)newRatio;
-(void)setFactorAtStageWithKey:(NSString *)key andNewFactor:(NSObject *)factorAtStage;

-(NSString *)getPValueWithKey:(NSString *)key;
-(NSString *)getOddsRatioWithKey:(NSString *)key;
-(NSObject *)getFactorAtStageWithKey:(NSString *)key;
*/
//-(UIBezierPath *)getArrow;
-(UIImageView *)getArrow:(UIView *)view;

-(BOOL)checkTouched:(CGPoint)touchPos;

-(void)displayFactors:(UIView *)view;

-(void) getPos:(float *)pos;

@end
