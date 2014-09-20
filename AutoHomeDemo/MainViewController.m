//
//  MainViewController.m
//  AutoHomeDemo
//
//  Created by ZhangYuanqing on 14-7-7.
//  Copyright (c) 2014年 KeyWandermen. All rights reserved.
//

#import "MainViewController.h"

static NSString *postURL = @"http://9night.kimiss.com/m/?c=Mobile_AppThread&tid=1373198&page=%d&type=0";

@interface MainViewController () {
    
     UIWebView *_backWebView;
     UIWebView *_displayingWebView;
     UIWebView *_upperWebView;
    
}

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImageView *capImageView;


@property (nonatomic, strong) NSMutableArray *webViews;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion]compare:@"7.0"]!=NSOrderedAscending) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.webViews = [[NSMutableArray alloc] initWithCapacity:0];
    
    CGRect viewFrame = self.view.frame;
    
    UIWebView *firstWebView = [[UIWebView alloc] initWithFrame:viewFrame];
    firstWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    firstWebView.backgroundColor = [UIColor clearColor];
    firstWebView.delegate = self;
    firstWebView.scrollView.delegate = self;
    [self.webViews addObject:firstWebView];
    
    UIWebView *secondeWebView = [[UIWebView alloc] initWithFrame:viewFrame];
    secondeWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    secondeWebView.backgroundColor = [UIColor clearColor];
    secondeWebView.delegate = self;
    secondeWebView.scrollView.delegate = self;
    [self.webViews addObject:secondeWebView];
    
    UIWebView *thirdWebView = [[UIWebView alloc] initWithFrame:viewFrame];
    thirdWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    thirdWebView.backgroundColor = [UIColor redColor];
    thirdWebView.delegate = self;
    thirdWebView.scrollView.delegate = self;
    [self.webViews addObject:thirdWebView];
    
    _backWebView = self.webViews[0];
    _displayingWebView = self.webViews[1];
    _upperWebView = self.webViews[2];
    
    
    self.currentPage = 1;
    
    [self.view addSubview:_backWebView];
    [self.view addSubview:_displayingWebView];
    
    CGRect rect = thirdWebView.frame;
    rect.origin.y = - thirdWebView.frame.size.height;
    thirdWebView.frame = rect;
    [self.view addSubview:thirdWebView];
    
    NSURLRequest *firstRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:postURL, self.currentPage]]];
    NSURLRequest *secondRequest =  [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:postURL, self.currentPage + 1]]];
    
    [_backWebView loadRequest:secondRequest];
    [_displayingWebView loadRequest:firstRequest];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    [self.panGesture addTarget:self action:@selector(panned:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)panned:(id)sender {
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    NSLog(@"mabi");
    if (_displayingWebView.scrollView.contentOffset.y > 0 || self.currentPage == 1) {
        return;
    }
    
    CGRect originalRect;
    
    CGPoint translation = [recognizer translationInView:self.view];
    NSLog(@"the translate is %f", translation.y);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
//        originalCenter = _upperWebView.center;
        originalRect = _upperWebView.frame;
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
//        _upperWebView.center = CGPointMake(originalCenter.x + self.view.frame.size.width / 2, originalCenter.y + translation.y);
        _upperWebView.frame = CGRectMake(0, translation.y - _upperWebView.frame.size.height, _upperWebView.frame.size.width, _upperWebView.frame.size.height);
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (translation.y > 175) {
            
            [self slideToPrevious];
            
        } else {
            
            CGRect rect = self.view.frame;
            rect.origin.y = - self.view.frame.size.height;
            _upperWebView.frame = rect;
        }
    }
}

- (void)slideToPrevious {
    
    CGRect rect = _upperWebView.frame;
    rect.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        
        _upperWebView.frame = rect;
        
    } completion:^(BOOL finished) {
        
        CGRect rect = self.view.frame;
        rect.origin.y = -self.view.frame.size.height;
        _backWebView.frame = rect;
        
        [self.view insertSubview:_upperWebView aboveSubview:_displayingWebView];
        
        NSInteger displayIndex = [self.webViews indexOfObject:_displayingWebView];
        if (displayIndex < self.webViews.count - 1) {
            displayIndex += 1;
        } else {
            displayIndex = 0;
        }
        
        NSInteger upperIndex = [self.webViews indexOfObject:_upperWebView];
        if (upperIndex < self.webViews.count - 1) {
            upperIndex += 1;
        } else {
            upperIndex = 0;
        }
        
        NSInteger backIndex = [self.webViews indexOfObject:_backWebView];
        if (backIndex < self.webViews.count - 1) {
            backIndex += 1;
        } else {
            backIndex = 0;
        }
        
        _backWebView = self.webViews[backIndex];
        _displayingWebView = self.webViews[displayIndex];
        _upperWebView = self.webViews[upperIndex];
        
        _backWebView.scrollView.scrollsToTop = NO;
        _upperWebView.scrollView.scrollsToTop = NO;
        _displayingWebView.scrollView.scrollsToTop = YES;
        
        self.currentPage -= 1;
        NSURLRequest *previousRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:postURL, self.currentPage - 1]]];
        [_upperWebView loadRequest:previousRequest];
    }];
}

- (void)slideToNext {
    
    CGRect rect = _displayingWebView.frame;
    rect.origin.y = -_displayingWebView.frame.size.height;
    
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        
        _displayingWebView.frame = rect;
        
    }completion:^(BOOL finished) {
        
        _upperWebView.frame = _backWebView.frame;
        [self.view insertSubview:_upperWebView belowSubview:_backWebView];
        
        NSInteger displayIndex = [self.webViews indexOfObject:_displayingWebView];
        if (displayIndex > 0) {
            displayIndex -= 1;
        } else {
            displayIndex = self.webViews.count - 1;
        }
        
        NSInteger upperIndex = [self.webViews indexOfObject:_upperWebView];
        if (upperIndex > 0) {
            upperIndex -= 1;
        } else {
            upperIndex = self.webViews.count - 1;
        }
        
        NSInteger backIndex = [self.webViews indexOfObject:_backWebView];
        if (backIndex > 0) {
            backIndex -= 1;
        } else {
            backIndex = self.webViews.count - 1;
        }
        
        
        _backWebView = self.webViews[backIndex];
        _displayingWebView = self.webViews[displayIndex];
        _upperWebView = self.webViews[upperIndex];
        
        _backWebView.scrollView.scrollsToTop = NO;
        _upperWebView.scrollView.scrollsToTop = NO;
        _displayingWebView.scrollView.scrollsToTop = YES;
        
        self.currentPage += 1;
        
        NSURLRequest *nextRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:postURL, self.currentPage + 1]]];
        [_backWebView loadRequest:nextRequest];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - UIWebViewDelegate 

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _displayingWebView.scrollView) {
        
        if (scrollView.contentOffset.y == 0 ) {
            _displayingWebView.scrollView.bounces = NO;
            [self panned:self.panGesture];
        } else {
            _displayingWebView.scrollView.bounces = YES;
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == _displayingWebView.scrollView) {
        
        if (scrollView.contentOffset.y > scrollView.contentSize.height - self.view.frame.size.height * 3 / 4) {
            [self slideToNext];
        }
    }
}

@end
