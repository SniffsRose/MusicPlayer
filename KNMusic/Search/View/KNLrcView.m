//
//  KNLrcView.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNLrcView.h"
#import <Foundation/Foundation.h>

@implementation KNLrcView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        keyArr = [NSMutableArray array];
        titleArr = [NSMutableArray array];
        labels = [NSMutableArray array];
        
        //添加背景图，话说真的好丑
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,frame.size}];
        self.backgroundImageView.userInteractionEnabled = YES;
        
        //添加毛玻璃特效
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithFrame:self.backgroundImageView.bounds];
        blurEffectView.effect = blurEffect;
        [self insertSubview:blurEffectView aboveSubview:self.backgroundImageView];
//        [self insertSubview:blurEffectView atIndex:1];

        UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
        [self.backgroundImageView addGestureRecognizer:longGR];
        [self addSubview:self.backgroundImageView];
        
        
        _scrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0,0,frame.size}];
        _scrollView.userInteractionEnabled = NO;
        
        [self addSubview:_scrollView];
        

    }
    return self;
}



-(void)longPress{
    if(self.delegate && [self.delegate respondsToSelector:@selector(lrcViewLongPress)]){
        [self.delegate lrcViewLongPress];
    }
}
-(void)setBackgroundImage:(UIImage*)image{
    self.backgroundImageView.image = image;
}

- (void)setLrcSourcePath:(NSString *)path{
    
    if([keyArr count] != 0){
        [keyArr removeAllObjects];
    }
    if([titleArr count] != 0){
        [titleArr removeAllObjects];
    }
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    for (NSString *str in array) {
        if(!str || str.length <= 0)
            continue;
        //截取字符串
        [self parseLrcLine:str];
    }
    //冒泡排序
    [self bubbleSort:keyArr];
    
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.contentSize = CGSizeMake(_scrollView.size.width, keyArr.count * 25);
    
    //添加标签到scrollview
    [self addLabelForScrollView];
}
- (void)addLabelForScrollView{
    [self scrollViewClearSubView];
    
    for (int index = 0; index < titleArr.count; index++) {
        NSString *title = titleArr[index];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,25*index+(_scrollView.size.height/2), _scrollView.size.width, 25)];
        label.text = title;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:label];
        [labels addObject:label];
        
    }
}
- (void)parseLrcLine:(NSString*)sourceLineText{
    if(!sourceLineText || sourceLineText.length <= 0)
        return ;
    NSArray *array = [sourceLineText componentsSeparatedByString:@"\n"];
    for(int i = 0; i < array.count; i++){
        NSString *tempStr = [array objectAtIndex:i];
        NSArray *lineArray = [tempStr componentsSeparatedByString:@"]"];
        for (int j = 0; j < [lineArray count] - 1; j++) {
            if ([lineArray[j] length] > 8) {
                NSString *str1 = [tempStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [tempStr substringWithRange:NSMakeRange(6, 1)];
                if([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]){
                    NSString *lrcStr = [lineArray lastObject];
                    NSString *timeStr = [[lineArray objectAtIndex:j] substringWithRange:NSMakeRange(1, 8)];
                    
                    [keyArr addObject:[timeStr substringToIndex:5]];
                    [titleArr addObject:lrcStr];
                }
            }
        }
    }
}
- (void)bubbleSort:(NSMutableArray*)array{
    int i , y;
    BOOL bFinish = YES;
    for (i = 1; i < array.count && bFinish; i++) {
        bFinish = NO;
        for (y = (int)array.count - 1 ; y >= i; y--) {
            float num1 = [self getNumberWith:array[y]];
            float num2 = [self getNumberWith:array[y - 1]];
            if(num1 < num2){
                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                [titleArr exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                bFinish = YES;
            }
        }
    }
}
- (float)getNumberWith:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@":"];
    NSString *str = [NSString stringWithFormat:@"%@.%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    return [str floatValue];
}

//滑动视图到某个时间字符串
-(void)scrollViewMoveLabelWith:(NSString *)string
{
    if ([keyArr count]!=0) {
        int index = 0;
        BOOL isFinded = NO;
        for (; index<keyArr.count - 1; index++) {
            float  num1 = [self getNumberWith:keyArr[index]];
            float numCur = [self getNumberWith:string];
            float num2 = [self getNumberWith:keyArr[index+1]];
            //判断是不是当前的歌词
            if (numCur<=num2 && numCur >= num1) {
                isFinded = YES;
                break;
            }
        }
        if (isFinded) {
            //设置唱过的歌词为自定义颜色
            UILabel * label = [labels objectAtIndex:index];
            label.textColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
            
            //滚动scrollview到当前行
            [_scrollView setContentOffset:CGPointMake(0, 25*index) animated:YES];
        }
    }
    
}

//清楚歌词ScrollView
- (void)scrollViewClearSubView{
    for (UIView *sub in  _scrollView.subviews) {
        [sub removeFromSuperview];
    }
    if(labels.count != 0){
        [labels removeAllObjects];
    }
}




-(void)selfClearKeyAndTitle
{
    if ([keyArr count]!=0) {
        [keyArr removeAllObjects];
    }
    if ([titleArr count]!=0) {
        [titleArr removeAllObjects];
    }
    
}




@end
