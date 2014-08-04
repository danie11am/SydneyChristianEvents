//
//  FeedbackViewController.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 4/08/2014.
//  Copyright (c) 2014 Lamophone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UIWebViewDelegate>

@property UIActivityIndicatorView *activityIndicator;
@property UIWebView *webView;

@end
