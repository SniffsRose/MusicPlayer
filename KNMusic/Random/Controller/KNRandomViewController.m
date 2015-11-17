//
//  KNRandomViewController.m
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import "KNRandomViewController.h"
#import "XYZPhoto.h"
#import "KNRiver.h"
#import "KNSongTool.h"
#import "ProgressHUD.h"
@interface KNRandomViewController ()

@property (nonatomic ,strong) NSMutableArray *randomArray;
@property (nonatomic ,strong) NSMutableArray *imageArray;


@end
#define IMAGEWIDTH 120
#define IMAGEHEIGHT 160
static BOOL isLoad;
@implementation KNRandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    [self initialize];
    
    
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
//    [doubleTap setNumberOfTapsRequired:2];
//    [self.view addGestureRecognizer:doubleTap];

}

- (void)initialize{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgg.jpg"]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigation.navigationBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    self.navigation.title = @"随机播放";
    isLoad = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!isLoad){
        if([KNSongTool isHaveSongMusic]){
            isLoad = YES;
            //加载riverView
            [self loadRiverView];
        }else{
            [ProgressHUD showError:@"没有可选音乐"];
        }
    }else{
        //重新加载可选数据
        [KNSongTool isHaveSongMusic];
    }
}

//加载river
- (void)loadRiverView{
    //添加9个图片到界面中
    for (int i = 0; i < 8; i++) {
        float X = arc4random()%((int)self.view.bounds.size.width - IMAGEWIDTH);
        float Y = arc4random()%((int)self.view.bounds.size.height - IMAGEHEIGHT);
        float W = IMAGEWIDTH;
        float H = IMAGEHEIGHT;
        
        XYZPhoto *photo = [[XYZPhoto alloc]initWithFrame:CGRectMake(X, Y, W, H)];
        KNRiver *river = [KNSongTool getOneRiver];
        [photo updateWithRiver:river];
        [self.view addSubview:photo];
        
        float alpha = i*1.0/10 + 0.2;
        [photo setImageAlphaAndSpeedAndSize:alpha];
    }
}

@end
