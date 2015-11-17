//
//  KNNavigationView.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNNavigationView.h"

@interface KNNavigationView ()

{
    UIButton * leftBtn;
    UIButton * rightBtn;
    UIImageView * headerImageView;
    UILabel * titleLabel;
    
    UIImageView * statusBack;
    UIImageView * navigationBack;
    
}

@end


@implementation KNNavigationView

//@synthesize leftImage = _leftImage;
//@synthesize rightImage = _rightImage;
//@synthesize headerImage = _headerImage;
//@synthesize title = _title;
//@synthesize delegate =_delegate;
//@synthesize navigationBackColor = _navigaionBackColor;


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        
        statusBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        [self addSubview:statusBack];
        
        navigationBack = [[UIImageView alloc]initWithFrame: CGRectMake(0, statusBack.frame.size.height, self.frame.size.width, self.frame.size.height - statusBack.frame.size.height)];
        navigationBack.userInteractionEnabled = YES;
        [self addSubview:navigationBack];
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(8, self.frame.size.height/2-_leftImage.size.height/2, _leftImage.size.width, _leftImage.size.height);
        [leftBtn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [navigationBack addSubview:leftBtn];
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.frame.size.width-_rightImage.size.width-5, self.frame.size.height/2-_rightImage.size.height/2, _rightImage.size.width, _rightImage.size.height);
        [rightBtn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [navigationBack addSubview:rightBtn];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [navigationBack addSubview:titleLabel];
        
        headerImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(0,0,0,0)];
        [navigationBack addSubview:headerImageView];
    }
    return self;
}
//左边按钮图片
-(void)setLeftImage:(UIImage *)leftImage
{
    leftBtn.frame = CGRectMake(8-10, navigationBack.frame.size.height/2-leftImage.size.height/2-5, leftImage.size.width+20, leftImage.size.height+10);
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
}
//右边按钮图片
-(void)setRightImage:(UIImage *)rightImage
{
    rightBtn.frame = CGRectMake(navigationBack.frame.size.width-rightImage.size.width-8, navigationBack.frame.size.height/2-rightImage.size.height/2, rightImage.size.width, rightImage.size.height);
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
}

//头视图图片
-(void)setHeaderImage:(UIImage *)headerImage
{
    headerImageView.frame =  CGRectMake(navigationBack.frame.size.width/2-headerImage.size.width/2, navigationBack.frame.size.height/2-headerImage.size.height/2, headerImage.size.width, headerImage.size.height);
    [headerImageView setImage:headerImage];
}

//标题
-(void)setTitle:(NSString *)title
{
    CGSize titleSize = [title sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(navigationBack.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];

    if (titleSize.width>200) {
        titleSize.width = 200;
    }
    if (headerImageView.image!=nil) {
        headerImageView.frame = CGRectMake(navigationBack.frame.size.width/2-headerImageView.image.size.width/2-titleSize.width/2, navigationBack.frame.size.height/2-headerImageView.image.size.height/2, headerImageView.frame.size.width, headerImageView.frame.size.height);
        titleLabel.frame = CGRectMake(headerImageView.frame.size.width+headerImageView.frame.origin.x, navigationBack.frame.size.height/2-titleSize.height/2, titleSize.width, titleSize.height);
        
    }else{
        titleLabel.frame = CGRectMake(navigationBack.frame.size.width/2-titleSize.width/2, navigationBack.frame.size.height/2-titleSize.height/2, titleSize.width, titleSize.height);
    }
    titleLabel.text = title;
}

- (void)setNavigationBackColor:(UIColor *)navigationBackColor
{
    statusBack.backgroundColor = navigationBackColor;
    statusBack.alpha = 0.5;
    navigationBack.backgroundColor = navigationBackColor;
}
-(void)setType:(NSInteger)type
{
    if (type==0) {
        statusBack.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    }else if (type ==1){
        statusBack.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    }
    navigationBack.frame = CGRectMake(0, statusBack.frame.size.height, self.frame.size.width, self.frame.size.height-statusBack.frame.size.height);
}

-(void)leftButtonEvent
{
    [_delegate previousToViewController];
}

-(void)rightButtonEvent
{
    [_delegate rightButtonClickEvent];
}


@end
