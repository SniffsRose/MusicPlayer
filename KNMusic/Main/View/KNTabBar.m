//
//  KNTabBar.m
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import "KNTabBar.h"
#import "KNButtonImage.h"
#import "Globle.h"

#define kScreenWidth    [[UIScreen mainScreen] applicationFrame].size.width
#define kScreenHeight   [[UIScreen mainScreen] applicationFrame].size.height
@interface KNTabBar ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation KNTabBar

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.backgroundView];
        
        self.buttons = [NSMutableArray array];
        UIButton *btn;
        CGFloat width = kScreenWidth / [imageArray count];
        for (int i = 0; i < [imageArray count]; i++)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.showsTouchWhenHighlighted = YES;
            btn.tag = i;
            btn.frame = CGRectMake(width * i, 0, width, frame.size.height);
            KNButtonImage *btnImage = imageArray[i];
            
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setImage:btnImage.defaultImage forState:UIControlStateNormal];
            [btn setImage:btnImage.highlightedImage forState:UIControlStateHighlighted];
            [btn setImage:btnImage.selectedImage forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if(btn.tag == 2){
        if(![Globle isPlaying]){
            return;
        }
    }
    [self selectTabAtIndex:btn.tag];
//    NSLog(@"Select index: %d",btn.tag);
    if (!self.delegate) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [self.delegate tabBar:self didSelectIndex:btn.tag];
    }
}

- (void)selectTabAtIndex:(NSInteger)index
{
    for (int i = 0; i < [self.buttons count]; i++)
    {
        UIButton *b = [self.buttons objectAtIndex:i];
        b.selected = NO;
        b.userInteractionEnabled = YES;
    }
    UIButton *btn = [self.buttons objectAtIndex:index];
    btn.selected = YES;
    // 是否可重复选
    //btn.userInteractionEnabled = NO;
}

#pragma mark - Public
- (void)setBackgroundImage:(UIImage *)img
{
    [self.backgroundView setImage:img];
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
    
    // Re-index the buttons
    CGFloat width = kScreenWidth / [self.buttons count];
    for (UIButton *btn in self.buttons)
    {
        if (btn.tag > index)
        {
            btn.tag--;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(KNButtonImage *)btnImage atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = kScreenWidth / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons)
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:btnImage.defaultImage forState:UIControlStateNormal];
    [btn setImage:btnImage.highlightedImage forState:UIControlStateHighlighted];
    [btn setImage:btnImage.selectedImage forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}
@end
