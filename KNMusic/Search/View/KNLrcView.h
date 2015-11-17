//
//  KNLrcView.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNLrcView;
@protocol KNLrcViewDelegate <NSObject>

-(void)lrcViewLongPress;

@end

@interface KNLrcView : UIView

{
    UIScrollView * _scrollView;
    NSMutableArray * keyArr;
    NSMutableArray * titleArr;
    NSMutableArray * labels;
}
@property (nonatomic ,strong) UIImageView *backgroundImageView;
@property (nonatomic ,assign) id<KNLrcViewDelegate> delegate;
-(void)setLrcSourcePath:(NSString *)path;
-(void)scrollViewMoveLabelWith:(NSString *)string;
-(void)scrollViewClearSubView;
-(void)selfClearKeyAndTitle;
-(void)setBackgroundImage:(UIImage*)image;

@end
