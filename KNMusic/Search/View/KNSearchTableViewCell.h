//
//  KNSearchTableViewCell.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "StyledTableViewCell.h"
@class KNImageView,KNSingerModel;
@interface KNSearchTableViewCell : StyledTableViewCell


{
    KNImageView *headerImageView;
    UILabel *nameLabel;
    UILabel *titleLabel;
}

@property (nonatomic ,strong) KNSingerModel *model;

@end
