//
//  KNImageView.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNImageView.h"




#define rad(degrees) ((degrees) / (180.0 / M_PI))
#define kLineWidth 3.f

NSString * const spm_identifier = @"spm.imagecache.tg";


@interface KNImageView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) UIView      *progressContainer;

@end

#pragma mark - SPMImageAsyncView


@implementation KNImageView

- (id)initWithFrame:(CGRect)frame {
    return [[KNImageView alloc] initWithFrame:frame
                        backgroundProgressColor:[UIColor whiteColor]];
}

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius     = CGRectGetWidth(self.bounds)/2.f;
        //setMasksToBounds:方法告诉layer将位于它之下的layer都遮盖住。
        //遮盖的意思
        self.layer.masksToBounds    = NO;
        //裁剪
        self.clipsToBounds          = YES;
        
        CGPoint arcCenter           = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGFloat radius              = MIN(CGRectGetMidX(self.bounds)-1, CGRectGetMidY(self.bounds)-1);
        
        UIBezierPath *circlePath    = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                     radius:radius
                                                                 startAngle:-rad(90)
                                                                   endAngle:rad(360-90)
                                                                  clockwise:YES];
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.path           = circlePath.CGPath;
        _backgroundLayer.strokeColor    = [backgroundProgresscolor CGColor];
        _backgroundLayer.fillColor      = [[UIColor clearColor] CGColor];
        _backgroundLayer.lineWidth      = kLineWidth;
    }
    return self;
}
@end
