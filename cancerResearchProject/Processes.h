//
//  Processes.h
//  cancerResearchProject
//
//  Created by THM on 9/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Processes : NSObject{

    NSString *_processNames[5];
    NSString *_processDetails[5];
    
    UITextView *_processBox;
    UITextView *_processDetailsBox[5];
    
}

-(Processes *) initWithLinkNumber:(unsigned int)number;

-(void)displayTextBoxes:(UIView *)view;
-(BOOL)selectedProcess:(CGPoint)touch onView:(UIView *)view;
-(void)deselect:(UIView *)view;
@end


