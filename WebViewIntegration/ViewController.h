//
//  ViewController.h
//  WebViews
//
//  Created by Scott Chapman on 6/9/14.
//  Copyright (c) 2014 Scott Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



@end
