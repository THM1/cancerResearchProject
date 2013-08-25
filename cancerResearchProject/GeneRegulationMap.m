//
//  GeneRegulationMap.m
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#define MAX_X 700
#define MAX_Y 800

#import "GeneRegulationMap.h"

@implementation GeneRegulationMap

/**
 * Constructor that initialises the GeneRegulationMap 
 * object and returns a pointer to itself
 */
-(GeneRegulationMap *)init
{
    self = [super init];
    
    if(self){
        [self initialiseVariables];
        [self setupStages];
    }
    
    return self;
}

/**
 * Private helper function that initialises the the arrays and dictionaries
 */
-(void)initialiseVariables
{
    _stagesList = [[NSMutableDictionary alloc] init];
    _linksList = [[NSMutableDictionary alloc] init];
    _links = [[NSMutableArray alloc] init];
    _stages = [[NSMutableArray alloc] init];
}

/**
 * Private helper function that loads all the stage and link information
 * from a plain text file called regulation_graph.plain
 *
 * It contains all the information on the stages and links involved in that
 * gene regulation map, and how they are connected, and their positions
 *
 * Using this information it initialises the Stages and Links and stores them
 * in the arrays
 */
-(void)setupStages
{
    // open file with gene regulation map details (nodes and edges)
    NSError *error = nil;
    NSStringEncoding *encoding = nil;
    NSString *filePathName = [[NSBundle mainBundle]pathForResource: @"regulation_graph" ofType:@"plain"];
    NSString *stagesInfo = [[NSString alloc] initWithContentsOfFile:filePathName usedEncoding:encoding error:&error];
    
    // place all words in an ordered list in an array (words are distinguished as being separated by white space characters or new line characters)
    NSArray *stagesInfoWordByWord = [stagesInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // initialise variables
    //_stagesList = [[NSMutableDictionary alloc] init];
    //_linksList = [[NSMutableDictionary alloc] init];
    //_links = [[NSMutableArray alloc] init];
    
    // counter for words in array
    unsigned int i=0;

    // check start of file is correct - should be the word "graph"
    if(![stagesInfoWordByWord[i++] isEqual: @"graph"]){
        // incorrect file opened
        NSLog(@"Incorrect File Type. Could not load gene regulation map");
        exit(1);
    }
    
    // scan next parts of the file for the width and height of the image and calculate scale factor
    // between position in image and position on screen
    i++;
    NSString *nextWord =  [stagesInfoWordByWord objectAtIndexedSubscript:i];
    float width = [nextWord floatValue];
    
    i++;
    nextWord = [stagesInfoWordByWord objectAtIndexedSubscript:i];
    float height = [nextWord floatValue];
    
    // scale to screen size
    float positionScale[2];
    positionScale[0]= MAX_X/width;
    positionScale[1] = MAX_Y/height;
    
    // next line of file
    i++;
    while(i<[stagesInfoWordByWord count]){
        
        nextWord = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
        
        // if end of file leave while loop
        if([nextWord isEqualToString:@"stop"]) break;
        
        // lines starting with the word "node" contain the information for that node (or stage)
        if([nextWord isEqualToString:@"node"]){
            
            // get stage name
            NSString *stageName = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
            
            // get stage position and scale x and y positions to size of screen
            float pos[2];
            pos[0] = [[stagesInfoWordByWord objectAtIndexedSubscript:i++] floatValue] * positionScale[0];
            pos[1] = MAX_Y - [[stagesInfoWordByWord objectAtIndexedSubscript:i++] floatValue] * positionScale[1];
            
            // create stage with above name and position and add to stages array
            Stage *newStage = [[Stage alloc] initWithName:stageName andPosition:pos];
            [_stages addObject:newStage];
            [_stagesList setObject:newStage forKey:stageName];
            // go to end of line (6 extra words for node information not required)
            i+=7;
        }
        
        else if([nextWord isEqualToString:@"edge"]){
            
            // get names of prev and next stage for the edge
            NSString *prevStage = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
            NSString *nextStage = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
            
            /*int *prevIndex=0, *nextIndex=0;
            
            // find the stages with the given names by searching in the stages array
            for(int j=0; j<[_stages count]; j++){
                if(![_stages[j] isEqualToString:prevStage]) *prevIndex=j;
                if(![_stages[j] isEqualToString:nextStage]) *nextIndex=j;
            }

            // create link with above prev and next stages and add to links array
            Link *newLink = [[Link alloc] initWithPrev:[_stages objectAtIndexedSubscript:*prevIndex] andNext:[_stages objectAtIndexedSubscript:*nextIndex]];*/
            
            Link *newLink = [[Link alloc] initWithPrev:[_stagesList objectForKey:prevStage] andNext:[_stagesList objectForKey:nextStage]];
            //Link *newLink = [[Link alloc] initWithPrev:[tempStages objectForKey:prevStage] andNext:[tempStages objectForKey:nextStage]];

            [_links addObject:newLink];
            
            NSString *linkName = [[NSString alloc] initWithFormat:@"%@\t%@",prevStage,nextStage];
            [_linksList setObject:newLink forKey:linkName];
            // go to end of line (11 extra words for node information not required)
            i+=11;
        }
    }
    
    //[stagesInfo dealloc];
    //[stagesInfoWordByWord dealloc];
}

/**
 * Public function that draws the gene regulation map on the view that is 
 * passed to it
 *
 * It calls the getLabel function for each Stage in the stages array
 * It calls the getArrow function for each Link in the links array
 *
 * It displays the obtained labels (UILabel) and arrows (UIImageView) to
 * the provided view
 *
 * It has a static counter so that the map is only drawn once to the screen
 */
-(void)drawGeneMapWithView:(UIView *)view
{
    static int count = 0;
        
    if(!count){

        unsigned int stageCount = [_stagesList count];
        unsigned int linksCount = [_linksList count];
        
        // loop through all the stage objects
        for(int i=0; i<stageCount; i++){
            
            Stage *tempStage = [_stages objectAtIndexedSubscript:i];
            
            // obtain the UILabel for above stage
            UILabel *label = [tempStage getLabel];
            
            // display the label to the screen
            [view addSubview:label];
            
        }
        
        // loop through all the link objects
        for(int i=0; i<linksCount; i++){
            
            Link *tempLink = [_links objectAtIndexedSubscript:i];

            // obtain the UIImageView of the arrow for above link
            UIImageView *imageView = [tempLink getArrow:view];
            
            // display the imageView to the screen
            [view addSubview:imageView];
        }
    }
    
    count = 1;
}

/**
 * Public function that takes as input a CGPoint of the touch position
 * and the view which was touched
 *
 * It loops through all the link objects to see if the touch location
 * was in and around the links in the map
 *
 * It modifies the view depending on the touch position. If no link was 
 * touched then no modification to the view is made
 */
-(void)registerTouchAtPoint:(CGPoint)touchPos onView:(UIView *)view
{
    NSUInteger count = [_links count];
    
    // loop through all link objects and check if a link was touched
    for(int i=0; i<count; i++){
        
        Link *tempLink = [_links objectAtIndexedSubscript:i];
        
        // check if above link was touched
        BOOL touched = [tempLink checkTouched:touchPos];
        
        // if touched call the displayFactors function to display the factor map
        // for the touched link or to remove the factor map from the display if it
        // already on the display
        if(touched){
            [tempLink displayFactors:view];
            return;
        }
    }
}
@end












