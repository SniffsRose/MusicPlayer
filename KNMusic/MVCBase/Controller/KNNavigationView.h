//
//  KNNavigationView.h
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

//自定义的导航
#import <UIKit/UIKit.h>

//导航左右按钮触发协议
@protocol KNNavigationViewDelegate <NSObject>

- (void)previousToViewController;
@optional
- (void)rightButtonClickEvent;

@end


@interface KNNavigationView : UIView

@property (nonatomic ,assign) id<KNNavigationViewDelegate> delegate;
@property (nonatomic ,strong) UIImage *leftImage;
@property (nonatomic ,strong) UIImage *headerImage;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,strong) UIImage *rightImage;
@property (nonatomic ,assign) UIColor *navigationBackColor;

/**
 *  样式（0，1）0没有状态栏，1有状态栏
 */
@property (nonatomic ,assign) NSInteger type;

@end
