//
//  Link.h
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//


/*! 
 \class Link Link.h
 \brief  Created by THM on 7/13/13. Copyright (c) 2013 THM. All rights reserved.
 
 Link is the class that represents a transition between two stages in the gene regulation map.

 It stores the previous and next stages that the link is between. This is used to load the
 factor data at that link.
 
 Link has a shared class variable "_factorFamilies", which stores all possible factor families
 that are loaded from a text file when a Link object is initialised for the first time.
 This only happens once.
 
 When initialised, Link loads all the factor data at that Link from text file.
 It has a method that obtains the p-values and odds ratios of each factor at that link, which
 it extracts and then uses to create the FactorAtLink objects. These are then stored in a dictionary
 to be accessed when required. 
 
 For each of it's factors, Link creates and stores a label representing that factor. This is better
 than creating the labels each time they are required.
 
 Each link also creates a UIImageView containing the arrow image from it's previous to next Stage,
 to be displayed on the gene regulation map.
 
 Link also has two public functions that handle a tap gesture and a swipe gesture:
 1. Tap gesture handler checks if a link or label has been selected.
 2. Swipe gesture handler changes the factors displayed on the gene regulation map to match the map type
    
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
}; //! enum geneRegulationMapType used to access correct index of factor data array

@interface Link : NSObject{
    Stage *_prev, *_next;
    float _pos[3];
    BOOL _touchFlag, _prevTouchFlag;
    UIImageView *_arrowImage;
    
    NSMutableDictionary *_factorData[3];    // up, down, all
    NSMutableArray *_factorLabels[3];       // up, down, all
    
}

-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next;

-(UIImageView *)getArrow:(UIView *)view;

-(BOOL)handleTouch:(CGPoint)touchPos withMapType:(enum geneRegulationMapType)mapType onView:(UIView *)view;
-(void)handleSwipeForMap:(enum geneRegulationMapType)mapType onView:(UIView *)view;

@end
