//
//  Processes.m
//  cancerResearchProject
//
//  Created by THM on 9/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Processes.h"

static NSMutableArray *_processList;
static NSMutableArray *_geneList[5];


@implementation Processes

-(Processes *)initWithLinkNumber:(unsigned int)number
{
    self = [super init];
    
    if(self){
        [self loadVariables:number];
        [self loadBoxes];
    }
    return self;
}

-(void)loadBoxes
{
    for(int i=0; i<5; i++){
        _processDetailsBox[i] = [[UITextView alloc] init];
        //_processDetailsBox[i].scrollEnabled = YES;
        
        UITextView *detailsText = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 200)];
        
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendFormat:@"Genes involved in %@ \n\n", _processNames[i]];
        [text appendFormat:@"%@ \n", _processDetails[i]];
        
        detailsText.text = text;
        detailsText.clipsToBounds = YES;
        
        //[detailsText sizeToFit];
        detailsText.editable = NO;
        
        _processDetailsBox[i] = detailsText;
    }
    
    _processBox = [[UITextView alloc] initWithFrame:CGRectMake(500, 70, 300, 100)];
    
    
    float ypos = 0;
    
    for(int i=0; i<5; i++){
        
        UILabel *label = [[UILabel alloc] init];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Verdana" size:14.0f];
        label.opaque = NO;
        
        label.text = _processNames[i];
        
        [label sizeToFit];
        [label setFrame:CGRectMake(0, ypos, label.frame.size.width, label.frame.size.height)];
        
        [_processBox addSubview:label];
        
        ypos += label.frame.size.height;
    }
/*
    NSMutableString *detailsText = [[NSMutableString alloc] init];
    [detailsText appendFormat:@"\n %@",_processNames[0]];
    [detailsText appendFormat:@"\n %@",_processNames[1]];
    [detailsText appendFormat:@"\n %@",_processNames[2]];
    [detailsText appendFormat:@"\n %@",_processNames[3]];
    [detailsText appendFormat:@"\n %@",_processNames[4]];
    
    _processBox.text = detailsText;
    _processBox.font = [UIFont fontWithName:@"Verdana" size:10.0f];*/
    //_processBox.opaque = NO;
    _processBox.editable = NO;
 
}

-(void)loadVariables:(unsigned int)number
{
    static int count = 0;
    
    if(!count) [self loadFileInfo];
 
    if(number > [_processList count]){
        NSLog(@"Error: outside index of processes and gene arrays");
        exit(1);
    }
    
    number--;
    NSString *comma = @",";
    
    /* load data */
    NSString *processNamesList = [_processList objectAtIndex:number];
    NSArray *processNames = [processNamesList componentsSeparatedByString:comma];
    
    for(int i=0; i< MIN(processNames.count, 5); i++){
        _processNames[i] = [processNames objectAtIndex:i];
        _processDetails[i] = [_geneList[i] objectAtIndex:number];
    }
    
    if(++number == [_processList count]){
        [self releaseInfo];
    }
    
    count = 1;
}

-(void)releaseInfo{
    [_processList removeAllObjects];
    [_geneList[0] removeAllObjects];
    [_geneList[1] removeAllObjects];
    [_geneList[2] removeAllObjects];
    [_geneList[3] removeAllObjects];
    [_geneList[4] removeAllObjects];
}

-(void)loadFileInfo{
    // open file with GOT processes listed
    NSError *error = nil;
    NSStringEncoding *encoding = nil;
    NSString *filePathName = [[NSBundle mainBundle] pathForResource: @"GOT_processes"
                                                             ofType:@"plain"];
    
    NSString *fileInfo = [[NSString alloc] initWithContentsOfFile:filePathName
                                                     usedEncoding:encoding
                                                            error:&error];
    
    // store them, word by word, in the processes list class variable
    _processList = [[NSMutableArray alloc] initWithArray:[fileInfo componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    
    
    // load gene terms for first process and place them in gene list class variable
    filePathName = [[NSBundle mainBundle] pathForResource: @"GOT_first"
                                                   ofType:@"plain"];
    
    fileInfo = [[NSString alloc] initWithContentsOfFile:filePathName
                                           usedEncoding:encoding
                                                  error:&error];
    
    _geneList[0] = [[NSMutableArray alloc] initWithArray:[fileInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    // load gene terms for second process and place them in gene list class variable
    filePathName = [[NSBundle mainBundle] pathForResource: @"GOT_second"
                                                   ofType:@"plain"];
    
    fileInfo = [[NSString alloc] initWithContentsOfFile:filePathName
                                           usedEncoding:encoding
                                                  error:&error];
    _geneList[1] = [[NSMutableArray alloc] initWithArray:[fileInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    // load gene terms for third process and place them in gene list class variable
    filePathName = [[NSBundle mainBundle] pathForResource: @"GOT_third"
                                                   ofType:@"plain"];
    
    fileInfo = [[NSString alloc] initWithContentsOfFile:filePathName
                                           usedEncoding:encoding
                                                  error:&error];
    _geneList[2] = [[NSMutableArray alloc] initWithArray:[fileInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    // load gene terms for fourth process and place them in gene list class variable
    filePathName = [[NSBundle mainBundle] pathForResource: @"GOT_fourth"
                                                   ofType:@"plain"];
    
    fileInfo = [[NSString alloc] initWithContentsOfFile:filePathName
                                           usedEncoding:encoding
                                                  error:&error];
    _geneList[3] = [[NSMutableArray alloc] initWithArray:[fileInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    // load gene terms for fifth process and place them in gene list class variable
    filePathName = [[NSBundle mainBundle] pathForResource: @"GOT_fifth"
                                                   ofType:@"plain"];
    
    fileInfo = [[NSString alloc] initWithContentsOfFile:filePathName
                                           usedEncoding:encoding
                                                  error:&error];
    _geneList[4] = [[NSMutableArray alloc] initWithArray:[fileInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
}

-(void)displayTextBoxes:(UIView *)view
{
    /*NSUInteger checkView = [view.subviews indexOfObject:_processDetailsBox[0]];
    
    if(checkView == NSNotFound) [view addSubview:_processDetailsBox[0]];
    else [[view.subviews objectAtIndex:checkView] removeFromSuperview];*/
    
    NSUInteger checkView = [view.subviews indexOfObject:_processBox];
    
    if(checkView == NSNotFound) [view addSubview:_processBox];
    else [[view.subviews objectAtIndex:checkView] removeFromSuperview];

}

-(BOOL)selectedProcess:(CGPoint)touch onView:(UIView *)view
{
    CGPoint relativeTouch = CGPointMake(touch.x - _processBox.frame.origin.x,
                                        touch.y - _processBox.frame.origin.y);
    
    for(int i=1; i<[_processBox.subviews count]; i++){
        
        UILabel *label = [_processBox.subviews objectAtIndex:i];
        BOOL touched = CGRectContainsPoint(label.frame, relativeTouch);
        
        if(touched){
            
            if([view.subviews indexOfObject:_processDetailsBox[i-1]] == NSNotFound){
                
                for(int j=0; j<5; j++){
                    
                    NSUInteger index = [view.subviews indexOfObject:_processDetailsBox[j]];
                    
                    if(index != NSNotFound){
                        [[view.subviews objectAtIndex:index] removeFromSuperview];
                        UILabel *currentTouchedProcess = [_processBox.subviews objectAtIndex:(j+1)];
                        currentTouchedProcess.textColor = [UIColor blackColor];
                    }
                }
                
                [view addSubview:_processDetailsBox[i-1]];
                label.textColor = [UIColor redColor];
                
            }
            
            else{
                NSUInteger index = [view.subviews indexOfObject:_processDetailsBox[i-1]];
                [[view.subviews objectAtIndex:index] removeFromSuperview];
                label.textColor = [UIColor blackColor];
            }
            
            return true;
            
        }
    }
    
    return false;
}


-(void)deselect:(UIView *)view
{
    NSUInteger index = [view.subviews indexOfObject:_processBox];
    
    if(index == NSNotFound) return;
    
    else{
        
        [[view.subviews objectAtIndex:index] removeFromSuperview];
        
        for(int i=0; i<5; i++){
            index = [view.subviews indexOfObject:_processDetailsBox[i]];
            
            if(index != NSNotFound){
                [[view.subviews objectAtIndex:index] removeFromSuperview];
                UILabel *label = [_processBox.subviews objectAtIndex:(i+1)];
                label.textColor = [UIColor blackColor];
            }
        }
    }
}

@end
























