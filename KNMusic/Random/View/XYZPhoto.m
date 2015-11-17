//
//  XYZPhoto.m
//  demo6_PhotoRiver
//
//  Created by BOBO on 15/3/23.
//  Copyright (c) 2015年 BobooO. All rights reserved.
//

#import "XYZPhoto.h"
#import "KNSongTool.h"
#import "KNMusicViewController.h"
#import "KNSongListModel.h"

@interface XYZPhoto ()
@property (nonatomic ,strong) KNRiver *river;
@end
@implementation XYZPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[KNRiverImageView alloc]initWithFrame:self.bounds];
        self.drawView = [[XYZDrawView alloc]initWithFrame:self.bounds];
        self.drawView.backgroundColor = [UIColor lightGrayColor];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.drawView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.drawView];
        [self addSubview:self.imageView];
     
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0/50.0 target:self selector:@selector(movePhotos) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:@"NSDefaultRunLoopMode"];
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        
//        [NSTimer scheduledTimerWithTimeInterval:1/30 target:self selector:@selector(movePhotos) userInfo:nil repeats:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [self addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipImage)];
        [swip setDirection:UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swip];
        
        
    }
    return self;
}

- (void)tapImage {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.state == XYZPhotoStateNormal) {
            self.oldFrame = self.frame;
            self.oldAlpha = self.alpha;
            self.oldSpeed = self.speed;
            self.frame = CGRectMake(20, 20, self.superview.bounds.size.width - 40, self.superview.bounds.size.height - 40);
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            [self.superview bringSubviewToFront:self];
            self.speed = 0;
            self.alpha = 1;
            self.state = XYZPhotoStateBig;
            
            KNSongListModel *songlist = self.river.songListModel;
            
            KNMusicViewController *musicVc = [KNMusicViewController shareMusicViewController];
            musicVc.array = [@[songlist] mutableCopy];
            [musicVc playMusicWithSongLink:songlist];
            
            
        } else if (self.state == XYZPhotoStateBig) {
            self.frame = self.oldFrame;
            self.alpha = self.oldAlpha;
            self.speed = self.oldSpeed;
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            self.state = XYZPhotoStateNormal;
        }
        
    }];
   
}

- (void)swipImage {
    
    if (self.state == XYZPhotoStateBig) {
        [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.state = XYZPhotoStateDraw;
    } else if (self.state == XYZPhotoStateDraw){
        [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.state = XYZPhotoStateBig;
    }
}


- (void)updateImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)updateWithRiver:(KNRiver *)river{
    self.river = river;
    self.imageView.image = river.image;
    
    self.imageView.titleLabel.text = river.songListModel.title;
    self.imageView.titleLabel.textColor = [self randomColor];


}
- (UIColor *)randomColor{
    
    CGFloat r = [self getRandomFloat];
    CGFloat g = [self getRandomFloat];
    CGFloat b = [self getRandomFloat];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
- (CGFloat)getRandomFloat{
    CGFloat r = arc4random()%10000;
    return r/10000.0;
}


- (void)setImageAlphaAndSpeedAndSize:(float)alpha {
    self.alpha = alpha;
    self.speed = alpha;
    self.transform = CGAffineTransformScale(self.transform, alpha, alpha);
}

- (void)movePhotos {
    
    self.center = CGPointMake(self.center.x + self.speed, self.center.y);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.center.x > self.superview.bounds.size.width + self.frame.size.width/2) {
            self.center = CGPointMake(-self.frame.size.width/2, arc4random()%(int)(self.superview.bounds.size.height - self.bounds.size.height) + self.bounds.size.height/2);
            
            [self updateWithRiver:[KNSongTool getOneRiver]];
        }
    });
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
