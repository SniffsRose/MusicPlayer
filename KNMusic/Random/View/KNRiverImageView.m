//
//  KNRiverImageView.m
//  KNMusic
//
//  Created by KN on 15/9/10.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNRiverImageView.h"

@implementation KNRiverImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.size.height / 3.0, self.size.width, self.size.height / 3.0)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}



@end
