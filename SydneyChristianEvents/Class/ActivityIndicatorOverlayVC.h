//
//  ActivityIndicatorOverlayVC.h
//  Next Station HA
//
//  Created by Daniel Lam on 22/04/12.
//  Copyright (c) 2012 Rockable Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


/*******************************************************************************
 * CLASS DEFINITION
 *******************************************************************************
 */

/**
 *
 
 ActivityIndicatorOverlayVC allows an Actvity Indicator to appear as an 
 overlay on top of current view.
 
 This class is based on a reference from:
 http://www.markbetz.net/2010/09/30/ios-diary-showing-an-activity-spinner-over-a-uitableview/
 
 */
@interface ActivityIndicatorOverlayVC : UIViewController {
    
    UILabel *activityLabel;

    UIActivityIndicatorView *activityIndicator;

    UIView *container;

    CGRect frame;
}



/*******************************************************************************
 * METHOD DECLARATIONS
 *******************************************************************************
 */


/**
 *******************************************************************************
 *
 * @param inputFrame 
 *
 * @return id A reference to this object itself.
 */
- (id)initWithFrame: (CGRect) inputFrame;



/**
 *******************************************************************************
 *
 * loadView() is called by system whenever the view property is requested 
 * and is null.
 *
 * This function should be overriden if the view hierarchy is to be created 
 * programmatically, without using a nib.
 *
 * @return void.
 */
- (void)loadView;



@end



