//
//  KNTabBar.h
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KNButtonImage;
@protocol KNTabBarDelegate;

@interface KNTabBar : UIView


@property (nonatomic, assign) id<KNTabBarDelegate> delegate;

/**
 *  根据按按钮图片数组创建标签栏
 *
 *  @param frame      标签栏尺寸
 *  @param imageArray (KNButtonImage)
 *
 *  @return bar
 */
- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;

- (void)selectTabAtIndex:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(KNButtonImage *)btnImage atIndex:(NSUInteger)index;

@end

@protocol KNTabBarDelegate<NSObject>
@optional

- (void)tabBar:(KNTabBar *)tabBar didSelectIndex:(NSInteger)index;

@end
