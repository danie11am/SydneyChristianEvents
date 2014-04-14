//
//  ActivityIndicatorOverlayVC.m
//  Next Station HA
//
//  Created by Daniel Lam on 22/04/12.
//  Copyright (c) 2012 Rockable Apps. All rights reserved.
//

#import "ActivityIndicatorOverlayVC.h"

@implementation ActivityIndicatorOverlayVC


#pragma mark - Initialisation



/**
 *******************************************************************************
 */
-(id)initWithFrame:(CGRect) inputFrame {

    //NSLog(@"ActivityIndicatorOverlayVC.m: init(): called.");

    if (self = [super init]) {

        frame = inputFrame;
        self.view.frame = inputFrame;

    }

    return self;

}



#pragma mark - Memory Management



/**
 *******************************************************************************
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle



/**
 *******************************************************************************
 */
- (void) loadView
{
    // Debugging.
    //NSLog(@"ActivityIndicatorOverlayVC.m: loadView(): called");

    [super loadView];

    // Container is a UIView that contains two components inside it,
    // the text "Loading" and the Activity Indicator.
    //
    container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];


    // Set the color of the container.
    //
    // It's clear color (transparent) by default.
    //
    //container.backgroundColor = [UIColor blackColor];


    // Set the center of the containr.
    //
    // This is with respect to the top-left corner of the boundary.
    //
    container.center = CGPointMake(frame.size.width/2, 
                                   frame.size.height/3);


    // Set the background color of the containr.
    //
    //self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 
                                                green:0.0 
                                                 blue:0.0 
                                                alpha:0.7];


    //-----------------------------------------------------------
    // Step 1 - Create the label "Loading..."

    
    // Create the text in the view.
    activityLabel = [[UILabel alloc] init];

    // Set the text.
    activityLabel.text = NSLocalizedString(@"Loading", 
                                           @"Text to indicate loading.");

    // Set the color of the text.
    //activityLabel.textColor = [UIColor lightGrayColor];
    //activityLabel.textColor = [UIColor blackColor];
    activityLabel.textColor = [UIColor whiteColor];


    // Set the background color.
    activityLabel.backgroundColor = [UIColor clearColor];

    // Set the font.
    activityLabel.font = [UIFont boldSystemFontOfSize:17];

    // Set the frame for the label.
    activityLabel.frame = CGRectMake(0, 3, 70, 25);


    // Add the label to the container.
    [container addSubview:activityLabel];




    //-----------------------------------------------------------
    // Step 2 - Create the Activity Indicator.


    activityIndicator = [[UIActivityIndicatorView alloc] 
                         initWithActivityIndicatorStyle:
                         UIActivityIndicatorViewStyleWhite
                         ];

    [activityIndicator startAnimating];

    activityIndicator.frame = CGRectMake(80, 0, 30, 30);

    [container addSubview:activityIndicator];



    //-----------------------------------------------------------

    // Add the container to self.
    //
    [self.view addSubview:container];


    
}



/**
 *******************************************************************************
 */
-(void)viewWillAppear:(BOOL) animated {

    [super viewWillAppear:animated];

    // In the original example, the following is supposed to trigger the 
    // animation of the Activity Indicator. However, this viewWillAppear()
    // did not get called for some reason. So, startAnimating() 
    // is called in loadView() instead.
    //
    [activityIndicator startAnimating];
}



/**
 *******************************************************************************
 */
-(void)viewWillDisappear:(BOOL) animated {

    [super viewWillDisappear:animated];

    [activityIndicator stopAnimating];
}



/**
 *******************************************************************************
 * viewDidLoad() is not overridden because the view hierarchy has been loaded
 * programmatically using loadView(). viewDidLoad() is typically used to
 * do more setup after views are created, typically after loading NIB file.
 */
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}



/**
 *******************************************************************************
 */
- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



/**
 *******************************************************************************
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{

    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end


