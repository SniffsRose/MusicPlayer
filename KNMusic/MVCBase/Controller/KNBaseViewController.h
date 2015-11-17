//
//  KNBaseViewController.h
//  KNMusic
//
//  Created by  KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNNavigationView.h"
#import "KNImageView.h"
#import "KNSingerModel.h"
#import "KNSongListModel.h"
#import "KNSongModel.h"
#import "ProgressHUD.h"
#import "Globle.h"

//带自定义导航navigation，的基类
@interface KNBaseViewController : UIViewController<KNNavigationViewDelegate>
{
    //世界对象
    Globle *globle;
}
/**
 *  自定义的导航
 */
@property (nonatomic ,strong) KNNavigationView *navigation;

@end
