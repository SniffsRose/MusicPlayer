//
//  KNProfileViewController.m
//  KNMusic
//
//  Created by KN on 15/9/9.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNProfileViewController.h"

@interface KNProfileViewController ()

@end

@implementation KNProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self initialize];
    
    //添加我视图
    [self addProfileView];
    
  
}

- (void)initialize{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigation.navigationBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    self.navigation.title = @"我";
}


- (void)addProfileView{
    CGRect frame = CGRectMake(0, self.navigation.size.height + self.navigation.origin.y, self.view.size.width, self.view.size.height - self.navigation.size.height - 48.0f);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"profile.jpg"];
    [self.view addSubview:imageView];
    
    
    frame.origin.y += 130;
    frame.size = [UIImage imageNamed:@"shu.gif"].size;
    frame.origin.x = (self.view.bounds.size.width - frame.size.width) / 2.0;
    
    //添加动图
    NSData *shuren = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shu" ofType:@"gif"]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:frame];
    webView.userInteractionEnabled = NO;
    [webView loadData:shuren MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:webView];
    
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(frame) + 5;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = 60;
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = @"I’m Groot";
    label.textColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}



@end
