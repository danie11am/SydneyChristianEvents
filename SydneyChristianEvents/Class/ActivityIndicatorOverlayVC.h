//
//  ActivityIndicatorOverlayVC.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 22/04/12.
//  Copyright (c) 2012 Lamophone. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Shows an Actvity Indicator to appear as an overlay on top of current view.
 
 This class is based on:
 http://www.markbetz.net/2010/09/30/ios-diary-showing-an-activity-spinner-over-a-uitableview/
 */
@interface ActivityIndicatorOverlayVC : UIViewController {
    
    UILabel *activityLabel;

    UIActivityIndicatorView *activityIndicator;

    UIView *container;

    CGRect frame;
}



-(id)initWithFrame:(CGRect) inputFrame;



@end

