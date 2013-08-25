//
//  Stage.h
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//


/*! 
 \class Stage Stage.h
 \brief  Created by THM on 7/13/13. Copyright (c) 2013 THM. All rights reserved.
 
 Stage class that contains the information of a stage in a gene regulation map.
 
 Stage has two attributes; name and position on the screen in the gene regulation map
    
 */
#import <Foundation/Foundation.h>

@interface Stage : NSObject{
    NSString *_name;    //! stage name
    float _pos[3];      //! stage position
}

-(Stage *)initWithName:(NSString *)name andPosition:(float *)pos;
-(void)getPos:(float *)pos;
-(NSString *)getName;

-(CGPoint)getCGPoint;
-(UILabel *)getLabel;

@end
