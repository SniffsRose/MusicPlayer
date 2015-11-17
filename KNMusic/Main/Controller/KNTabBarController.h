//
//  KNTabBarController.h
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KNTabBarControllerDelegate;
@class KNTabBar,KNButtonImage;

@interface KNTabBarController : UIViewController

@property (nonatomic ,assign) id <KNTabBarControllerDelegate> delegate;
@property (nonatomic ,readonly) UIViewController *selectedViewController;
@property (nonatomic ,assign) NSUInteger selectedIndex;


@property (nonatomic ,readonly) KNTabBar *tabBar;

// Default is NO, if set to YES, content will under tabbar
// transitionView覆盖tabBar
@property (nonatomic ,assign) BOOL tabBarTransparent;

@property (nonatomic ,assign) BOOL tabBarHidden;

// driect: 0 -- 上下  1 -- 左右
@property (nonatomic ,assign) NSInteger animateDriect;

@property (nonatomic ,assign) NSInteger ordIndex;
/**
 *  初始化tabBar
 *
 *  @param vcs 控制器数组(ViewController)
 *  @param arr 按钮图片数组(KNButtonImage)
 *
 *  @return tabBar
 */
- (instancetype)initWithViewControllers:(NSArray*)vcs buttonImageArray:(NSArray*)arr;

//隐藏tabBar
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect;


// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(KNButtonImage *)dict atIndex:(NSUInteger)index;


@end

@protocol KNTabBarControllerDelegate <NSObject>

/**
 *  将要显示选中的控制器
 */
- (BOOL)tabBarController:(KNTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 *  显示选中的控制器后
 */
- (void)tabBarController:(KNTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end


//UIViewController的扩展类，获取已有的knTabBarController的单例对象
@interface UIViewController (KNTabBarControllerSupport)

@property (nonatomic ,readonly) KNTabBarController *knTabBarController;

@end
