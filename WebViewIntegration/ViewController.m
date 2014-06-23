//
//  ViewController.m
//  WebViews
//
//  Created by Scott Chapman on 6/9/14.
//  Copyright (c) 2014 Scott Chapman. All rights reserved.
//

#import "ViewController.h"
#import "Favorites.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize theWebView;
@synthesize activityIndicator;


Favorites *favs ;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //NEED THIS....IMPORTANT!!! Can do it in code or in Storyboard.
    theWebView.delegate = self;
    
    favs = [[Favorites alloc] init];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WebViewIntegrationIndex" ofType:@"html"]];
    [theWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
//    NSString *listString = @"";
//    for (int i = 0; i <  [favs.userFavorites count]; i++){
//        listString = [listString stringByAppendingFormat:@"%i. %@\n", i+1, [favs.userFavorites objectAtIndex:i]];
//    }
//    
//    NSLog(@"Favorites File: %@", listString);

    
    [activityIndicator startAnimating];
    
}

-(void)viewDidAppear:(BOOL)animated{
    //NEED THIS....IMPORTANT!!! Can do it in code or in Storyboard.
    theWebView.delegate = self;
    

    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    [activityIndicator stopAnimating];
    activityIndicator.hidden = TRUE;
    
    //CHECK IF THIS PAGE IS FAVORITED AND ADJUST ICON ACCORDINGLY
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"location.pathname.substring(location.pathname.lastIndexOf('/') + 1);"];
    NSLog(@"Current Page title: %@", title);

    if (![favs isFavorite:title]){
       NSLog(@"Page NOT A Favorite");
        
    }
    else{
       NSLog(@"Page IS A Favorite");
       //Change the icon

        NSString *html = [theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('iconFavorite').className = document.getElementById('iconFavorite').className + ' ui-alt-icon'"];
        NSLog(@"Class HMTL: %@", html);
    }

    //Embed the list in the HTML if it is the favorites.html page
    if([title  isEqual: @"Favorites.html"]){
        NSString *favoriteListString = @"";
        for (int i = 0; i <  [favs.userFavorites count]; i++){
            favoriteListString = [favoriteListString stringByAppendingFormat:@"<p>%@</p>", [favs.userFavorites objectAtIndex:i]];
        }
        NSString *javascript = [[NSString alloc] initWithFormat: @"document.getElementById('divFavoritesList').innerHTML = '%@'", favoriteListString];
        [theWebView stringByEvaluatingJavaScriptFromString:javascript];
    }
    else if ([title  isEqual: @"Preferences.html"]){
        NSString *storedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"];
        NSString *storedCompany = [[NSUserDefaults standardUserDefaults] stringForKey:@"Company"];
        
        if ([storedCompany length] != 0) {
            NSString *javascript = [[NSString alloc] initWithFormat: @"document.getElementById('txtCompany').value = '%@'", storedCompany];
            [theWebView stringByEvaluatingJavaScriptFromString:javascript];

        }
        
        if ([storedName length] != 0) {
            NSString *javascript = [[NSString alloc] initWithFormat: @"document.getElementById('txtName').value = '%@'", storedName];
            [theWebView stringByEvaluatingJavaScriptFromString:javascript];
            
        }
        
        NSLog(@"Stored Name is %@", storedName);
        NSLog(@"Stored Company is %@", storedCompany);
        
    }
    else if ([title  isEqual: @"Welcome.html"]){
        NSString *storedName = [[[NSUserDefaults standardUserDefaults] stringForKey:@"Name"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *storedCompany = [[[NSUserDefaults standardUserDefaults] stringForKey:@"Company"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
   
        
        
        NSString *welcomeMessage = [NSString stringWithFormat:@"%@%@%@%@", @"Welcome ", storedName, @" from ", storedCompany];
        NSString *javascript = [[NSString alloc] initWithFormat: @"document.getElementById('divWelcomeMessage').innerHTML = '%@'", welcomeMessage];
        [theWebView stringByEvaluatingJavaScriptFromString:javascript];
    }
    
    NSLog(@"Web View Load End!");
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Web View Load Start!");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
     NSLog(@"Web View Load Error!");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    //PROCESS ANY URL COMMANDS
    NSString *urlCommand = [[request URL] absoluteString];
    
    //NSLog(@"URL Command: %@", urlCommand);
    
    
    if ([urlCommand rangeOfString:@"action:favorite"].location != NSNotFound)
    {
        
        NSArray *commandPaths = [urlCommand componentsSeparatedByString:@":"];
        NSString *favoriteFileName = commandPaths[2];
        
        //Add or remove page to favorite file in local storage
         if ([favs isFavorite:favoriteFileName]){
            [favs removeFavorite:favoriteFileName];
            NSLog(@"Removed Favorite: %@",favoriteFileName);
            //Update the Favorite Icon in the HTML
            [theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('iconFavorite').className = document.getElementById('iconFavorite').className.replace(' ui-alt-icon', '')"];

        }
        else{
            //NSLog(@"indexOfTheObject: %i",indexOfTheObject);
          [favs addFavorite:favoriteFileName];
           NSLog(@"Added Favorite: %@",favoriteFileName);
           //Update the Favorite Icon in the HTML
          [theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('iconFavorite').className = document.getElementById('iconFavorite').className + ' ui-alt-icon'"];
        }

        
        
        NSLog(@"Favs: %@", favs.userFavorites);
        
        
        NSString *listString = @"";
        for (int i = 0; i <  [favs.userFavorites count]; i++){
            listString = [listString stringByAppendingFormat:@"%i. %@\n", i+1, [favs.userFavorites objectAtIndex:i]];
        }
        
        
        //Do not reload web view
        return NO;
    }
    else if ([urlCommand rangeOfString:@"action:SavePreferences"].location != NSNotFound) {
      NSString* enteredName = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('txtName').value"];
      NSString* enteredCompany = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('txtCompany').value"];
        
        
      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:enteredName forKey:@"Name"];
        [defaults setObject:enteredCompany forKey:@"Company"];
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WebViewIntegrationIndex" ofType:@"html"]];
        [theWebView loadRequest:[NSURLRequest requestWithURL:url]];
        
        
        return NO;
    }
    else if ([urlCommand rangeOfString:@"action:CancelPreferences"].location != NSNotFound) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WebViewIntegrationIndex" ofType:@"html"]];
        [theWebView loadRequest:[NSURLRequest requestWithURL:url]];
        
        
        return NO;
    }
    else
    {
        return YES;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
