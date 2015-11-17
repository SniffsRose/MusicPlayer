//
//  KNImageView.h
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <UIKit/UIKit.h>

//带自定义颜色圈圈的圆形图片
@interface KNImageView : UIImageView
@property (nonatomic, assign, getter = isCacheEnabled) BOOL cacheEnabled;
@property (nonatomic, strong) UIImageView *containerImageView;

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor;
@end
