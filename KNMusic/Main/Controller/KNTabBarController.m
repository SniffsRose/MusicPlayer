//
//  KNTabBarController.m
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import "KNTabBarController.h"
#import "KNTabBar.h"
#import "Globle.h"
#import "KNMusicViewController.h"
#define kTabBarHeight 58.0f
#define kTabBarWidth kScreenWidth

#define kScreenWidth    [[UIScreen mainScreen] applicationFrame].size.width
#define kScreenHeight   [[UIScreen mainScreen] applicationFrame].size.height

static KNTabBarController *knTabBarController;

@implementation UIViewController (KNTabBarControllerSupport)

- (KNTabBarController *)knTabBarController{
    
    return knTabBarController;
}

@end



@interface KNTabBarController ()<KNTabBarDelegate>
{
    //tabBar的可视区域
    UIView      *containerView;
    
    //去除tabBar的view
    UIView		*transitionView;
    
    NSMutableArray *viewControllers;
}

@end

@implementation KNTabBarController

- (instancetype)initWithViewControllers:(NSArray *)vcs buttonImageArray:(NSArray *)arr{
    
    if(self = [super init]){
        viewControllers = [NSMutableArray arrayWithArray:vcs];
        containerView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        transitionView = [[UIView alloc]initWithFrame:containerView.bounds];//CGRectMake(0, 0, kScreenWidth, containerView.bounds.size.height - kTabBarHeight)];
        transitionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _tabBar = [[KNTabBar alloc] initWithFrame:CGRectMake(0, containerView.bounds.size.height - kTabBarHeight, kTabBarWidth, kTabBarHeight) buttonImages:arr];
        _tabBar.delegate = self;
        
        //单例
        knTabBarController = self;
        _animateDriect = 0;
        _tabBarHidden = NO;
       
        
    }
    return self;
}

- (void)loadView{
    
    [super loadView];
    
    [containerView addSubview:transitionView];
    [containerView addSubview:_tabBar];
    
    self.view = containerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首次加载为第一页
    self.selectedIndex = 0;
    
}

//是否透明TabBar
- (void)setTabBarTransparent:(BOOL)yesOrNo{
    
    _tabBarTransparent = yesOrNo;
    
    if(_tabBarTransparent == YES){
        
        [containerView bringSubviewToFront:transitionView];
    }else{
        [containerView bringSubviewToFront:_tabBar];
    }
}
//隐藏tabBar
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated{
    
    [self hidesTabBar:yesOrNO animated:animated driect:self.animateDriect];
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect{
    
    // driect: 0 -- 上下  1 -- 左右
    
    if (yesOrNO == YES)//隐藏的情况下且tabBar已近隐藏直接reture
    {
        if (driect == 0)
        {
            if (self.tabBar.frame.origin.y == self.view.frame.size.height)
            {
                return;
            }
        }
        else
        {
            if (self.tabBar.frame.origin.x == 0 - kTabBarWidth)
            {
                return;
            }
        }
    }
    else//不隐藏的情况下且tabBar已近不隐藏直接reture
    {
        if (driect == 0)
        {
            if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
            {
                return;
            }
        }
        else
        {
            if (self.tabBar.frame.origin.x == 0)
            {
                return;
            }
        }
    }
    
    if (animated == YES)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
    }
    if (yesOrNO == YES)
    {
        if (driect == 0)
        {
            CGRect frame = self.tabBar.frame;
            frame.origin.y += kTabBarHeight;
            self.tabBar.frame = frame;
            
        }
        else
        {
            CGRect frame = self.tabBar.frame;
            frame.origin.x -= kTabBarWidth;
            self.tabBar.frame = frame;
        }
    }
    else
    {
        if (driect == 0)
        {
            CGRect frame = self.tabBar.frame;
            frame.origin.y = self.view.bounds.size.height - kTabBarHeight;
            self.tabBar.frame = frame;
        }
        else
        {
            CGRect frame = self.tabBar.frame;
            frame.origin.x = 0;
            self.tabBar.frame = frame;
        }
    }
    if(animated == YES){
        
        [UIView commitAnimations];
    }
    
    _tabBarHidden = yesOrNO;

}

//选中那个控制器
- (UIViewController *)selectedViewController{
    
    return [viewControllers objectAtIndex:self.selectedIndex];
}

//设置选中某个控制器
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    //show this ViewController
    [self displayViewAtIndex:selectedIndex];
    
    //seleted tabBar button
    [self.tabBar selectTabAtIndex:selectedIndex];
}

//移除某个标签
- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [self.tabBar removeTabAtIndex:index];
}
//添加某个标签
- (void)insertViewController:(UIViewController *)vc withImageDic:(KNButtonImage *)dict atIndex:(NSUInteger)index
{
    //inset ViewController to array
    [viewControllers insertObject:vc atIndex:index];
    //inset barButton to tabBar
    [self.tabBar insertTabWithImageDic:dict atIndex:index];
}


//显示某个标签
- (void)displayViewAtIndex:(NSUInteger)index{
    
    // Before change index, ask the delegate should change the index.
    if([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]){
        
        if(![self.delegate tabBarController:self shouldSelectViewController:[viewControllers objectAtIndex:index]]){
            return;
        }
    }
    
    // If target index if equal to current index, do nothing.
    if(_selectedIndex == index && [[transitionView subviews] count] != 0){
        return;
    }
    _selectedIndex = index;
    
    
    if(index == 2){
        
        if([Globle isPlaying] && self.ordIndex){
            KNMusicViewController *musicVc = [KNMusicViewController shareMusicViewController];
            musicVc.isTabBar = self.ordIndex;
            [viewControllers[self.ordIndex - 10] pushViewController:musicVc animated:YES];
        }
        
    }else{
        
        UIViewController *selectedVc = [viewControllers objectAtIndex:index];
        selectedVc.view.frame = transitionView.frame;
        
        //返回一个布尔值指出接收者是否是给定视图的子视图或者指向那个视图
        //如果是该界面子视图推出到最前
        if([selectedVc.view isDescendantOfView:transitionView]){
            //bringSubviewToFront（）方法可以将指定的视图推送到前面，而 sendSubviewToBack()则可以将指定的视图推送到背面
            [transitionView bringSubviewToFront:selectedVc.view];
        }else{
            //干掉多余的子视图
            for (UIView *subView in transitionView.subviews) {
                if(subView != viewControllers[1]){
                    [subView removeFromSuperview];
                }
            }
            
            [transitionView addSubview:selectedVc.view];
            if (self.ordIndex) {
                UIViewController *oldVc = [viewControllers objectAtIndex:self.ordIndex -10];
                [oldVc.view removeFromSuperview];
            }
          
            
        }
        // Notify the delegate, the viewcontroller has been changed.
        if([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]){
            
            [_delegate tabBarController:self didSelectViewController:selectedVc];
        }
        
        self.ordIndex = index + 10;
    }
    
   
    
    
}


#pragma mark - tabBarDelegate
- (void)tabBar:(KNTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    [self displayViewAtIndex:index];
}






@end
