//
//  MainViewController.h
//  AutoHomeDemo
//
//  Created by ZhangYuanqing on 14-7-7.
//  Copyright (c) 2014年 KeyWandermen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate, UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end
