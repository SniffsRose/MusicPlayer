//
//  KNMainTabBarController.m
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import "KNMainTabBarController.h"


#import "KNMyMusicViewController.h"
#import "KNProfileViewController.h"
#import "KNRandomViewController.h"
#import "KNSearchViewController.h"

#import "KNNavigationController.h"
#import "KNTabBarController.h"

#import "KNButtonImage.h"
#import "KNTabBar.h"

@interface KNMainTabBarController ()<UINavigationControllerDelegate,KNTabBarControllerDelegate>

@property (nonatomic ,strong) NSMutableArray *viewControllers;

@property (nonatomic ,strong) NSMutableArray *buttonImages;


@property (nonatomic ,weak) KNTabBarController *tabBarController;

@end

@implementation KNMainTabBarController

- (NSMutableArray *)buttonImages{
    if(_buttonImages == nil){
        _buttonImages = [NSMutableArray array];
    }
    return _buttonImages;
}
- (NSMutableArray *)viewControllers{
    if(_viewControllers == nil){
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //加载标签栏
    [self loadMainView];
    
    //加载开始动画
    [self loadLoadingView];
    
}


- (void)loadMainView{
    
    KNMyMusicViewController *myMusicVc = [KNMyMusicViewController new];
    [self setUpOneChildViewController:myMusicVc image:[UIImage imageNamed:@"home"] highlightedImage:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"home-on"] title:@"首页"];
    
    KNSearchViewController *searchVc = [KNSearchViewController new];
    [self setUpOneChildViewController:searchVc image:[UIImage imageNamed:@"topic"] highlightedImage:[UIImage imageNamed:@"topic"] selectedImage:[UIImage imageNamed:@"topic-on"] title:@"查找"];
    
    KNMyMusicViewController *playVc = [KNMyMusicViewController new];
    [self setUpOneChildViewController:playVc image:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search-on"] title:@"播放"];
    
    
    KNRandomViewController *randomVc = [KNRandomViewController new];
    [self setUpOneChildViewController:randomVc image:[UIImage imageNamed:@"shoppping"] highlightedImage:[UIImage imageNamed:@"shoppping"] selectedImage:[UIImage imageNamed:@"shoppping-on"] title:@"随机"];
    
    KNProfileViewController *profileVc = [KNProfileViewController new];
    [self setUpOneChildViewController:profileVc image:[UIImage imageNamed:@"my"] highlightedImage:[UIImage imageNamed:@"my"] selectedImage:[UIImage imageNamed:@"my-on"] title:@"我"];
    
    KNTabBarController *tbc = [[KNTabBarController alloc]initWithViewControllers:self.viewControllers buttonImageArray:self.buttonImages];
    self.tabBarController = tbc;
    
    [tbc.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom-bg"]];
    tbc.delegate = self;
    
    [self.view addSubview:tbc.view];
    
}
- (void)dealloc{
    NSLog(@"...");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}

//进入动画
- (void)loadLoadingView{
    
    
    UIImageView *bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth / 2, kScreenHeight)];
    CGRect frame1 = bgImageView1.frame;
    frame1.origin.x -= kScreenWidth / 2;
    
    bgImageView1.backgroundColor = [UIColor clearColor];
    bgImageView1.image = [UIImage imageNamed:@"loading_01"];
//    bgImageView1.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImageView1];
    
    
    UIImageView *bgImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 20, kScreenWidth / 2, kScreenHeight)];
    CGRect frame2 = bgImageView2.frame;
    frame2.origin.x += kScreenWidth / 2;
    
    bgImageView2.backgroundColor = [UIColor clearColor];
    bgImageView2.image = [UIImage imageNamed:@"loading_02"];
//    bgImageView2.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImageView2];
    
    [UIView animateWithDuration:2 animations:^{
        
        bgImageView1.frame = frame1;
        bgImageView2.frame = frame2;
        
    } completion:^(BOOL finished) {
        
        [bgImageView1 removeFromSuperview];
        [bgImageView2 removeFromSuperview];
        
    }];
}


- (void)setUpOneChildViewController:(UIViewController*)vc image:(UIImage*)image highlightedImage:(UIImage*)highlightImage selectedImage:(UIImage*)selectedImage title:(NSString*)title{
    
    vc.title = title;

    KNNavigationController *nav = [[KNNavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [nav.navigationBar setBackgroundColor:[UIColor redColor]];
    nav.delegate = self;
    [self.viewControllers addObject:nav];

    
    KNButtonImage *bi = [[KNButtonImage alloc]init];
    bi.defaultImage = image;
    bi.highlightedImage = highlightImage;
    bi.selectedImage = selectedImage;
    [self.buttonImages addObject:bi];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)tabBarController:(KNTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}
- (void)tabBarController:(KNTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}

@end
