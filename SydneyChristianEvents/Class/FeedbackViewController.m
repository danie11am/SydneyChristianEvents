//
//  FeedbackViewController.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 4/08/2014.
//  Copyright (c) 2014 Lamophone. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView=[[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;

    NSString *url=@"http://www.appyform.com/form/6nkVZxALgpwo";
    NSURLRequest *nsRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:nsRequest];
    [self.view addSubview:self.webView];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.activityIndicator startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView  {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
}


@end
