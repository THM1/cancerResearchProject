//
//  Link.m
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//


#define MAX_X 700
#define MAX_Y 800

#define PI 3.14159265359

#import "Link.h"

static NSMutableDictionary *_factorFamilies; ///< Class Variable of the factor families involved in the regulation maps

@interface Link()
// initialise class variables
-(void)initialiseVariables;

// helpers for setting getting class variables
-(void)setPosition;
-(void)getPos:(float *)pos;
-(void)setPreviousStage:(Stage *)prev;
-(void)setNextStage:(Stage *)next;

// helpers for creating the labels for the factors at this link
-(void)loadFactorLabels;
-(NSArray *)loadFactorLabelsForArray:(NSArray *)array;

// helpers for loading the data from the text files on initialisation
-(void)loadFactorFamilyData;
-(void) loadFactorData;

// helper that creates the arrow image for this link
-(UIImageView *)loadArrow:(UIView *)view;

// helper functions for handling touch
-(BOOL)checkTouchedLabel:(CGPoint)touchPos forMapType:(enum geneRegulationMapType)mapType;  // label touched
-(BOOL)checkTouched:(CGPoint)touchPos;                                                      // arrow touched

// helpers for displaying and hiding the labels when a touch is registered
-(void)displayFactorsHelper:(enum geneRegulationMapType)mapType onView:(UIView *)view;
-(void)displayFactors:(enum geneRegulationMapType)mapType onView:(UIView *)view;
-(void)hideFactorsHelper:(enum geneRegulationMapType)mapType onView:(UIView *)view;

@end

@implementation Link

/**
 * Constructor that takes previous and next stages as input
 * and then creates the Link by allocating the relevant memory
 * and initialising all the class variables and loading all the
 * necessary data
 */
-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next
{
    self = [super init];
    
    if(self){
        
        [self initialiseVariables];
        
        // if first link created, load info for class variable
        if(![_factorFamilies count]) [self loadFactorFamilyData];
        
        [self setPreviousStage:prev];
        [self setNextStage:next];
        
        //[self calculatePos];
        // load the data for the shared class variable (only done once)
        [self loadFactorData];
        // load the data specific to this link's class attributes
        [self loadFactorLabels];
        
    }
    
    return self;
}

/**
 * Initialises the class attributes by allocating the necessary memory
 */
-(void)initialiseVariables
{
    // the class variable only allocated memory if not already assigned
    if(_factorFamilies == nil){
        _factorFamilies = [[NSMutableDictionary alloc] init];
    }
    
    // initalise alass attributes
    _factorData[UP] = [[NSMutableDictionary alloc] init];
    _factorData[DOWN] = [[NSMutableDictionary alloc] init];
    _factorData[ALL] = [[NSMutableDictionary alloc] init];

}

/**
 * Loads the data for the shared class variable dictionary
 * It should create all the Factor Family classes involved
 * in this gene regulation map
 * Currently initialises with null information relating to the factor
 */
-(void)loadFactorFamilyData
{
    // open file with factor family map details (nodes and edges)
    NSError *error = nil;
    NSStringEncoding *encoding = nil;
    NSString *filePathName = [[NSBundle mainBundle]
                              pathForResource: @"factor_graph"
                              ofType:@"plain"];
    
    NSString *factorFamilyInfo = [[NSString alloc]
                                  initWithContentsOfFile:filePathName
                                  usedEncoding:encoding
                                  error:&error];
    
    // place all words in an ordered list in an array (words are distinguished as being separated by white space characters or new line characters)
    NSArray *factorInfoWordByWord = [factorFamilyInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    unsigned int i=0;    //< counter for words in array
    
    // check start of file is correct - should be the word "graph"
    if(![factorInfoWordByWord[i++] isEqual: @"graph"]){
        // incorrect file opened
        NSLog(@"Incorrect File Type. Could not load gene regulation map");
        exit(1);
    }
    
    // scan next parts of the file for the width and height of the image and calculate scale factor
    // between position in image and position on screen
    i++;
    NSString *nextWord =  [factorInfoWordByWord objectAtIndexedSubscript:i];
    float width = [nextWord floatValue];
    
    i++;
    nextWord = [factorInfoWordByWord objectAtIndexedSubscript:i];
    float height = [nextWord floatValue];
    
    // scale to prevent overcrowded map
    float positionScale[2];
    positionScale[0]= 150.0f/width;
    positionScale[1] = 100.0f/height;
    
    // next line of file
    i++;
    
    // loop through each word in the file until all the relevant data was loaded
    while(i < [factorInfoWordByWord count]){
        nextWord = [factorInfoWordByWord objectAtIndexedSubscript:i++];
        
        // if end of file leave while loop
        if([nextWord isEqualToString:@"stop"]) break;
        if([nextWord isEqualToString:@"edge"]) break;
        
        // otherwise add the factor
        if([nextWord isEqualToString:@"node"]){
            NSString *factorName = [factorInfoWordByWord objectAtIndexedSubscript:i++];
            
            // scale position of factor by pre-calculated scale factor 
            float pos[3];
            pos[0] = [[factorInfoWordByWord objectAtIndexedSubscript:i++] floatValue] * positionScale[0];
            pos[1] = [[factorInfoWordByWord objectAtIndexedSubscript:i++] floatValue] * positionScale[1];
            pos[2] = 0;
            
            // create the factor family
            FactorFamily *newFactorFamily = [[FactorFamily alloc]
                                             initFactorFamilyName:factorName
                                             withInfo:@""
                                             andMoreInfo:@""
                                             andPos:pos];
            
            // add it to the factor family class variable dictionary
            [_factorFamilies setObject:newFactorFamily
                                forKey:factorName];
        
            // read next line of file
            i+=7;
        }

    }

}

/**
 * Helper function to set the centre position of the arrow
 * which will be used to identify whether the arrow was
 * touched
 */
-(void)setPosition
{
    float prevPos[3], nextPos[3];
    
    [_prev getPos:prevPos];
    [_next getPos:nextPos];
    
    // midway between previous and next stage positions
    for(int i=0; i<3; i++){
        _pos[i] = (prevPos[i] + nextPos[i]) * 0.5;
    }
    
}

/** Helper function for getting position of this link */
-(void)getPos:(float *)pos
{
    for(int i=0; i<3; i++){
        pos[i] = _pos[i];
    }
}

/** Helper functions for setting previous and next stages */
-(void)setPreviousStage:(Stage *)prev
{
    _prev = prev;
}

-(void)setNextStage:(Stage *)next
{
    _next = next;
}

/**
 * Function that loops through the "factor_info.txt" file
 * to obtain all the relevant factor data specific to this
 * link - in particular the p-values and odds ratios of each
 * factor at this link
 *
 * It then creates factorAtStage with data loaded for each factor
 * in the shared factor families dictionary
 *
 * For each factor family there will be three sets of data, 
 * all stored in the correct array:
 *
 * 1. UP   regulation data  _factorData[UP]
 * 2. DOWN regulation data  _factorData[DOWN]
 * 3. ALL                   _factorData[ALL]
 *
 * 
 */
-(void) loadFactorData
{
    // open file with factor details at each edge
    NSError *error = nil;
    NSStringEncoding *encoding = NULL;
    NSString *filePathName = [[NSBundle mainBundle]
                              pathForResource:@"factor_info"
                              ofType:@"txt"];
    
    NSString *factorInfo = [[NSString alloc]
                            initWithContentsOfFile:filePathName
                            usedEncoding:encoding
                            error:&error];
    
    // place all words in an ordered list in an array (words are distinguished as being separated by white space characters or new line characters)
    NSArray *factorInfoWordByWord = [factorInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    unsigned int i=0;    //< counter for words in array
    
    // check start of file is correct - should be the word "graph"
    if(![factorInfoWordByWord[i] isEqual: @"Fr.C'"]){
        // incorrect file opened
        NSLog(@"Incorrect File Type. Could not load factor info");
        exit(1);
    }
    
    NSString *prevStageName = [_prev getName];
    NSString *nextStageName = [_next getName];

    /** 
     * loop through all words in file looking for factors that have the
     * same previous and next stage as this link, and store their info
     */
    while(i<[factorInfoWordByWord count]){
        
        // get name of previous stage and check it matches the one for this link
        NSString *nextWord = [factorInfoWordByWord objectAtIndexedSubscript:i++];
        if(![nextWord isEqualToString:prevStageName]){
            i+=5;
            continue;
        }
    
        // get name of next stage and check it matches the one for this link
        nextWord = [factorInfoWordByWord objectAtIndexedSubscript:i++];
        if(![nextWord isEqualToString:nextStageName]){
            i+=4;
            continue;
        }
        
        // if prev and next stages match, get the type of regulation (up/down/all)
        nextWord = [factorInfoWordByWord objectAtIndexedSubscript:i++];
        
        // get the factor family name
        NSString *factorFamilyName = [factorInfoWordByWord objectAtIndexedSubscript:i++];
        
        // get the odds ratio and pval for this factor and convert them to floats
        float oddsRatio = [[factorInfoWordByWord objectAtIndexedSubscript:i++] floatValue];
        float pVal = [[factorInfoWordByWord objectAtIndexedSubscript:i++] floatValue];
        
        // check if the factor family already exists
        // if it doesn't, create a factor family with the obtained factor family name
        if([_factorFamilies objectForKey:factorFamilyName] == nil){
            float pos[3];
            
            FactorFamily* newFamily = [[FactorFamily alloc] initFactorFamilyName:factorFamilyName withInfo:@"" andMoreInfo:@"" andPos:pos];
            [_factorFamilies setObject:newFamily forKey:factorFamilyName];
        }
        
        // create the factor object which has the details of the p value and odds ratio for the above factor family
        FactorAtLink* newFactor = [[FactorAtLink alloc]
                                   initWithFactorFamily:[_factorFamilies objectForKey:factorFamilyName]
                                   andPValue:&pVal
                                   andOddsRatio:&oddsRatio];
        
        // add it to the correct map list - either the up regulated, down regulated, or all regulated map list
        if([nextWord isEqualToString:@"up"]){
            [_factorData[UP] setObject:newFactor
                                forKey:factorFamilyName];
        }
        
        else if([nextWord isEqualToString:@"down"]){
            [_factorData[DOWN] setObject:newFactor
                                  forKey:factorFamilyName];
        }
        
        else if([nextWord isEqualToString:@"all"]){
            [_factorData[ALL] setObject:newFactor
                                 forKey:factorFamilyName];
        }
        
        // if up/down/all is not specified then exit program as incorrect file type specified
        else{
            NSLog(@"Incorrect data format supplied. Cannot continue");
            exit(1);
        }
    }
    
}


//-(UIBezierPath *)getArrow

/**
 * Function that creates the arrow that represents this link
 * using a bezier curve to draw it
 *
 * It then places the bezier curve into a UIImage which is
 * then placed in a UIImageView
 *
 * The UIImageView is returned, and can be added as a subView to
 * the main view, consequently displaying the link arrow
 */
-(UIImageView *)loadArrow:(UIView *)view
{
    UIBezierPath* arrowPath = [[UIBezierPath alloc] init];
    
    // first and last points start at prev and end at next stage positions
    CGPoint first = [_prev getCGPoint];
    CGPoint last = [_next getCGPoint];
    
    // modify first and last vertical distance so the arrow points to
    // the top of the UILabel of the stage, rather than covering the
    // writing on the UILabel
    first.y += 20.0f;
    last.y  -= 20.0f;
    
    /** calculate positions of the left and right points of the arrowhead
     *  using basic trig
     */
    
    // direction vector is from previous to next stage and its lenght
    GLKVector2 directionVector = GLKVector2Make((last.x - first.x), (last.y - first.y));
    float directionVectorLength = sqrtf(pow(directionVector.x,2) + pow(directionVector.y,2));
    
    // normal vector perpendicular to direction vector
    GLKVector2 normalVector = GLKVector2Make(-directionVector.y, directionVector.x);
    
    // declare width of arrowhead and calculate distance of left and right points from body of arrow
    float arrowHeadWidth = 25.0f;
    float distance = arrowHeadWidth / (2 * directionVectorLength);
    
    // find point on line from which to draw the left and right arrowhead points
    CGPoint pointOnLine = CGPointMake(first.x + 0.85 * directionVector.x,
                                      first.y + 0.85 * directionVector.y);
    
    // now calculate the left and right points using the above information
    CGPoint second = CGPointMake(pointOnLine.x + distance * normalVector.x,
                                 pointOnLine.y + distance * normalVector.y);
    
    
    CGPoint third = CGPointMake(pointOnLine.x - distance * normalVector.x,
                                pointOnLine.y - distance * normalVector.y);
    
    
    /**
     * create bezier path of arrow using above points
     */
    
    [arrowPath moveToPoint:first];
    [arrowPath addLineToPoint:last];
    [arrowPath addLineToPoint:second];
    [arrowPath addLineToPoint:third];
    [arrowPath addLineToPoint:last];
    [arrowPath closePath];
    
    [arrowPath setLineWidth:2.0f];
    
    /**
     * create the UIImage with the above bezier arrow inside
     * and return the UIImageView containing the bezier image
     */
    float imageSize[2];
    imageSize[0] = abs(first.x - last.x);
    imageSize[1] = abs(first.y - last.y);
    
    // create image context
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    
    // add attributes to the image to be draw (e.g. colour)
    //CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    [arrowPath stroke];
    [arrowPath fill];
    
    UIGraphicsPopContext();
    
    // get the image on the current context
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end image creation
    UIGraphicsEndImageContext();
    
    // create image view initialised with the arrow image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:outputImage];
    
    
    // return arrowPath;
    return imageView;

}


/**
 * Function that returns the UIImageView containing the 
 * arrow representing this link, ready to be added as a
 * subView to the main view
 *
 * If the arrow has not yet been created, then initialise
 * it and create the arrow image view, then return it
 */
-(UIImageView *)getArrow:(UIView *)view
{
    // Initialise only once, and load the arrow information only once
    if(_arrowImage == nil){
        _arrowImage = [[UIImageView alloc] init];
        _arrowImage = [self loadArrow:view];
    }
    
    // Then (or otherwise) return the stored arrow image
    return _arrowImage;
    
}

-(BOOL)checkTouchedLabel:(CGPoint)touchPos forMapType:(enum geneRegulationMapType)mapType
{
    // loop through all labels at this link to see if they were selected
    for(int i=0; i<_factorLabels[mapType].count; i++){
        
        // extract label at each iteration
        UILabel *label = [_factorLabels[mapType] objectAtIndex:i];
        
        // check if the touch position was inside the label's frame
        BOOL labelSelected = CGRectContainsPoint(label.frame, touchPos);
        
        // if so then modify the label as required
        if(labelSelected){
            label.backgroundColor = [UIColor blueColor];
            return true;
        }
    }
    return false;
}

/**
 * Function that checks if the touch position corresponds
 * to the link position, and modifies the touch flag accordingly
 
 * Has an error of +/- 30 on touch position
 
 * Returns a boolean value: true if touched, false otherwise
 */
-(BOOL)checkTouched:(CGPoint)touchPos
{

    CGPoint prev = [_prev getCGPoint];
    CGPoint next = [_next getCGPoint];
    
    // find arrow position and compare with touch location
    float maxX = (prev.x > next.x)? prev.x : next.x;
    float maxY = (prev.y > next.y)? prev.y : next.y;
    float minX = (prev.x < next.x)? prev.x : next.x;
    float minY = (prev.y < next.y)? prev.y : next.y;

    // check if touch location is on arrow with error of +/- 30
    if(touchPos.x > (maxX + 30.0f)) return false;
    if(touchPos.x < (minX - 30.0f)) return false;
    if(touchPos.y > (maxY + 30.0f)) return false;
    if(touchPos.y < (minY - 30.0f)) return false;
    
    // toggle touch flag
    _touchFlag = !_touchFlag;

    //NSLog(@"TOUCHED");
    return true;

}


/**
 * Helper function for displaying the factors at this link
 */
-(void)displayFactorsHelper:(enum geneRegulationMapType)mapType onView:(UIView *)view
{
    NSUInteger factorCount = _factorLabels[mapType].count;

    // loop through array of factors and display them to the view
    for(int i=0; i<factorCount; i++){
        
        [view addSubview:[_factorLabels[mapType] objectAtIndexedSubscript:i]];
        
    }
}

/**
 * Helper function for hiding the factors at this link
 */
-(void)hideFactorsHelper:(enum geneRegulationMapType)mapType onView:(UIView *)view
{
    int factorCount = _factorLabels[mapType].count;

    // loop through array of factors and remove them from the current view
    for(int i=0; i<factorCount; i++){
        
        // get index of the UILabels in the subview array
        NSUInteger x = [view.subviews indexOfObject:[_factorLabels[mapType] objectAtIndexedSubscript:i]];
        
        // if the label is not a subview of the view then return
        if(x == NSNotFound) return;
        
        // otherwise find that label and remove it from the main view
        [[view.subviews objectAtIndex:x] removeFromSuperview];
    }
    
    return;
}

/**
 * Function that displays or hides factors from the screen
 * using helper functions depending on the touch flag being toggled
 */
-(void)displayFactors:(enum geneRegulationMapType)mapType onView:(UIView *)view
{
    
    static BOOL prevTouchFlag = false;  // static variable to compare previous data with new, to see if there has been any touch stimuli
    
    // check if touch flag has been toggled
    
    // if toggled to true then display factors using helper function
    if(prevTouchFlag != _touchFlag && prevTouchFlag == false) [self displayFactorsHelper:mapType onView:view];
    
    // if toggled to false then hide factors using helper function
    else if(prevTouchFlag != _touchFlag && prevTouchFlag == true) [self hideFactorsHelper:mapType onView:view];
    
    // set static touch flag to current touch flag
    prevTouchFlag = _touchFlag;
}


/** 
 * Helper function for creating the factor labels for a given
 * array of factor data 
 */
-(NSArray *)loadFactorLabelsForArray:(NSArray *)array
{
    // create array for the labels to be stored
    NSMutableArray *labelArray = [[NSMutableArray alloc] init];
    
    // get count of number of labels to be created
    NSUInteger count = array.count;
    
    // location of the "_next" stage label is required for relative positioning of the factor labels
    CGPoint next = [_next getCGPoint];
    
    for(int i=0; i<count; i++){
        
        FactorAtLink *tempFactor = [array objectAtIndexedSubscript:i];
        float tempPos[3];
        [tempFactor getRelativePos:tempPos];
        
        // adjust relative position to actual position using the position of the next stage
        if(next.x >= MAX_X/2) tempPos[0] = tempPos[0] + next.x;
        else tempPos[0] = next.x - tempPos[0];
        
        tempPos[1] = tempPos[1] + next.y - 130;
        CGRect factorRect = CGRectMake(tempPos[0], tempPos[1], 50, 20);
        
        // create the label for each factor and modify colour and font size
        // by calling the factor's functions getColour and getFontSize
        UILabel *label = [[UILabel alloc] initWithFrame:factorRect];
        
        label.text = [tempFactor getName];
        label.textColor = [tempFactor getColour];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:(int)[tempFactor getFontSize]];
        label.backgroundColor = [UIColor clearColor];
        
        // add the label to the label array
        [labelArray addObject:label];
    }
    
    return labelArray;
}

/**
 * Function that creates the UILabels for all the factors
 * at this link using a helper function
 */
-(void)loadFactorLabels
{
    // Initialise factorLabels arrays
    _factorLabels[UP] = [[NSMutableArray alloc] init];
    _factorLabels[DOWN] = [[NSMutableArray alloc] init];
    _factorLabels[ALL] = [[NSMutableArray alloc] init];
    
    // Load factorLabels array data by passing respective factorData
    [_factorLabels[UP] addObjectsFromArray:[self loadFactorLabelsForArray:[_factorData[UP] allValues]]];
    [_factorLabels[DOWN] addObjectsFromArray:[self loadFactorLabelsForArray:[_factorData[DOWN] allValues]]];
    [_factorLabels[ALL] addObjectsFromArray:[self loadFactorLabelsForArray:[_factorData[ALL] allValues]]];

}

-(void)handleTouch:(CGPoint)touchPos withMapType:(enum geneRegulationMapType)mapType onView:(UIView *)view
{
    // if the factors map is on display then
    // check if any of the factors have been selected
    if(_touchFlag){
        
        BOOL labelTouched = [self checkTouchedLabel:touchPos forMapType:mapType];
        
        // if a label was touched then return
        if(labelTouched) return;
    }
    
    // if no label was touched then check if this link was touched
    BOOL touched = [self checkTouched:touchPos];
    
    // if it was then display or hide factors accordingly
    if(touched){
        [self displayFactors:mapType onView:view];
        return;
    }
    
}

-(void)handleSwipeForMap:(enum geneRegulationMapType)mapType onView:(UIView *)view
{
    int factorCount = _factorLabels[mapType].count;
    
    // loop through array of factors and remove them from the current view
    for(int i=0; i<factorCount; i++){
        
        // get index of the UILabels in the subview array
        NSUInteger x = [view.subviews indexOfObject:[_factorLabels[!mapType] objectAtIndexedSubscript:i]];
        
        // if the label is not a subview of the view then check other labels
        if(x == NSNotFound) continue;
        
        // otherwise find that label and remove it from the main view
        // and add the label of the current map type
        [[view.subviews objectAtIndex:x] removeFromSuperview];
        [view addSubview:[_factorLabels[mapType] objectAtIndexedSubscript:i]];
    }
}



@end










