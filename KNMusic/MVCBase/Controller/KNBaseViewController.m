//
//  KNBaseViewController.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNBaseViewController.h"

@interface KNBaseViewController ()

@end

@implementation KNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *systeam = [UIDevice currentDevice].systemVersion;
    float number = [systeam floatValue];
    
    CGFloat height = 0.0f;
    NSInteger type = 0;
    if(number <= 6.9){
        type = 0;
        height = 44.0f;
    }else{
        type = 1;
        height = 66.0f;
    }
    
    globle = [Globle shareGloble];
    
    self.navigation = [[KNNavigationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    self.navigation.type = type;
    
    self.navigation.delegate = self;
    self.navigation.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigation];
    
}



- (void)previousToViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightButtonClickEvent{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
