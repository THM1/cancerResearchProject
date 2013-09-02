//
//  GeneRegulationMap.h
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

/*! 
 \class GeneRegulationMap GeneRegulationMap.h
 \brief  Created by THM on 7/10/13. Copyright (c) 2013 THM. All rights reserved.
 
 GeneRegulationMap is a class that loads all the info for the stages and links involved in a
 gene regulation map, by scanning the contents of a plain text file.
 
 It initialises all the stages and links and stores them in arrays.
 
 It has public functions that allow the gene regulation map to be drawn 
 to a given view (and context), and allow touch to be registered, modifying 
 the map depending on the touch location (e.g. displaying more or less information)
 */
#import <Foundation/Foundation.h>
#import "Stage.h"
#import "Link.h"

@interface GeneRegulationMap : NSObject{
@private

    NSMutableArray* _stages;            //! array of stages
    NSMutableArray* _links;             //! array of links
    NSMutableDictionary* _stagesList;   //! dictionary of stages with their names as keys
    NSMutableDictionary* _linksList;    //! dictionary of links with "previousStageName     nextStageName" as keys
    
    enum geneRegulationMapType _currentMap;
    //NSMutableDictionary* _factors;

}

-(GeneRegulationMap *)init;
-(void)drawGeneMap:(enum geneRegulationMapType)mapType withView:(UIView *)view;

-(void)registerTouchAtPoint:(CGPoint)touchPos forMap:(enum geneRegulationMapType)mapType onView:(UIView *)view;
-(void)registerSwipeForMap:(enum geneRegulationMapType)mapType onView:(UIView *)view;
@end
