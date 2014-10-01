//
//  ViewController.m
//  MySafari
//
//  Created by Wade Sellers on 10/1/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
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
}

- (IBAction)onBackButtonPressed:(id)sender {
    //[self updateAddressBarText:self.webView.request.URL];
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    //[self updateAddressBarText:self.webView.request.URL];
    [self.webView goForward];
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
        self.webAddress = urlString;
    }
    else if ([webAddress containsString:@".com"]) {
        NSString *httpPrefix = @"http://www.";
        NSString *urlString = [httpPrefix stringByAppendingString:webAddress];
        self.webAddress = urlString;
    }
    else {
        NSString *googleBaseURL = @"https://www.google.com/#q=";
        NSString *googleSearch = [googleBaseURL stringByAppendingString:webAddress];
        self.webAddress = googleSearch;
    }

    if (![self.webAddress isEqualToString:@""]) {

        [self loadURLString:self.webAddress];
    }
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

@end
