//
//  ViewController.m
//  MySafari
//
//  Created by Wade Sellers on 10/1/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UILabel *websiteTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;

    self.webView.scrollView.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // This selects all the text in the textfield when a user selects the textfield
    [textField selectAll:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self checkAndLoadURLString:textField.text];
    [self checkIfWebViewCanGoOrForward];

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self checkIfWebViewCanGoOrForward];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateAddressBarText:self.webView.request.URL];
    [self.urlTextField resignFirstResponder];
    NSString *websiteTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.websiteTitle.text = websiteTitle;

}

- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
    [self updateAddressBarText:self.webView.request.URL];

}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
    [self updateAddressBarText:self.webView.request.URL];

}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Coming Soon!";
    [alertView addButtonWithTitle:@"Awesome!"];
    [alertView show];
}

- (void)checkAndLoadURLString: (NSString *)webAddress {

    if ([webAddress containsString:@"http://"]) {
        [self loadURLString:webAddress];
    }
    else if ([webAddress containsString:@"www."]) {
        NSString *httpPrefix = @"http://";
        NSString *urlString = [httpPrefix stringByAppendingString:webAddress];
        [self loadURLString:urlString];
    }
    else if ([webAddress containsString:@".com"]) {
        NSString *httpPrefix = @"http://www.";
        NSString *urlString = [httpPrefix stringByAppendingString:webAddress];
        [self loadURLString:urlString];
    }
    else {
        NSString *googleBaseURL = @"https://www.google.com/#q=";
        NSString *googleSearch = [googleBaseURL stringByAppendingString:webAddress];
        [self loadURLString:googleSearch];
    }


    //This is Richmond's solution to adding more suffixes it will allow to send as a NSURL instead of a google search.
    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".(com|org|co|net|edu)$" options:0 error:&error];
    //NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.urlTextField.text options:0 range:NSMakeRange(0, [self.urlTextField.text length])];

}

- (void)loadURLString: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];

    [self updateAddressBarText:self.webView.request.URL];

    //[self updatePlaceHolderTextInTextField:urlString];
}

- (void) checkIfWebViewCanGoOrForward {
    if (self.webView.canGoBack){
        self.backButton.enabled = YES;
    }
    else {
        self.backButton.enabled = NO;
    }

    if (self.webView.canGoForward) {
        self.forwardButton.enabled = YES;
    }
    else {
        self.forwardButton.enabled = NO;
    }
}

- (void) updateAddressBarText: (NSURL *)currentURL {
    NSString *urlString = [currentURL absoluteString];
    self.urlTextField.text = urlString;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"Test");
    //NSLog(@"View Height: %f", self.webView.bounds.size.height);

    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];

    if(translation.y > 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.urlTextField.alpha = 1.0;

            CGRect newFrame = self.webView.frame;

            newFrame.size.width = self.webView.frame.size.width;
            newFrame.origin.y = 60;
            newFrame.size.height = self.webView.bounds.size.height - newFrame.origin.y;

            [self.webView setFrame:newFrame];
        }];
    } else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.urlTextField.alpha = 0.0;

            CGRect newFrame = self.webView.frame;

            newFrame.size.width = self.webView.frame.size.width;
            newFrame.size.height = self.webView.bounds.size.height + newFrame.origin.y;
            newFrame.origin.y = 20;
            [self.webView setFrame:newFrame];
        }];
    }
}

@end
