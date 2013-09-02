//
//  DetailViewController.m
//  cancerResearchProject
//
//  Created by THM on 8/25/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.fontColourPValueKey.text = @"pval";
        self.fontSizeOddsRatioKey.text =@"odds ratio";
    }

    [self editNibNameToMapType:_currentMapType];

    // clear the screen
    for(int i=0; i<[self.view.subviews count]; i++){
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    UIImageView *myView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"factorFontKey.png"]];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, 800.0f);
    myView.transform = transform;
    myView.frame = CGRectMake(350.0f, 750.0f, 400, 50);
    
    [self.view addSubview:myView];
    
    [_GRM drawGeneMap:_currentMapType withView:self.view];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self initialiseVariables];
    
    [self configureView];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(tapRecognizer:)];
    
    [self.view addGestureRecognizer:tapRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(pinchRecognizer:)];
    
    [self.view addGestureRecognizer:pinchRecognizer];
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(panRecognizer:)];
    panRecognizer.minimumNumberOfTouches = 1;
    
    [self.view addGestureRecognizer:panRecognizer];
    
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(swipeRecognizer:)];
    
    [self.view addGestureRecognizer:swipeRecognizer];

}

-(void)swipeRecognizer: (UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if(_currentMapType == UP) _currentMapType = DOWN;
        else _currentMapType = UP;
        
        [self editNibNameToMapType:_currentMapType];
        [_GRM registerSwipeForMap:_currentMapType onView:self.view];
    }
}

-(void)panRecognizer: (UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if(_currentMapType == UP) _currentMapType = DOWN;
        else _currentMapType = UP;
        
        [self editNibNameToMapType:_currentMapType];
        [_GRM registerSwipeForMap:_currentMapType onView:self.view];
    }
}

// function to modify camera zoom when user pinches screen
-(void)pinchRecognizer: (UIPinchGestureRecognizer *)recognizer
{    
    //NSLog(@"Pinch scale: %f", recognizer.scale);
    CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    
    self.view.transform = transform;
}


-(void) tapRecognizer: (UITapGestureRecognizer *) recognizer
{
    CGPoint touch = [recognizer locationInView:self.view];
    [_GRM registerTouchAtPoint:touch forMap:_currentMapType onView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editNibNameToMapType:(enum geneRegulationMapType)mapType
{
    if(self){
        self.title = _mapNamesList[mapType];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Gene Regulation Map", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(void)initialiseVariables
{
    
    // initialise the map
    _GRM = [[GeneRegulationMap alloc] init];
    
    // ensure gene regulation map was initialised
    assert(_GRM != nil);
    
    // initialise the map names
    NSString *mapNames[2];
    mapNames[0] = NSLocalizedString(@"Gene Regulation Map: Up-regulated", @"GRM_up");
    mapNames[1] =  NSLocalizedString(@"Gene Regulation Map: Down-regulated", @"GRM_down");

    _mapNamesList = [[NSArray alloc] initWithObjects:mapNames[0],mapNames[1], nil];
}


@end

















