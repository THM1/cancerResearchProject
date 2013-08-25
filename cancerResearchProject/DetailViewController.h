//
//  DetailViewController.h
//  cancerResearchProject
//
//  Created by THM on 8/25/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneRegulationMap.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    GeneRegulationMap *_GRM;
}
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
