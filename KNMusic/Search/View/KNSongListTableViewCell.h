//
//  KNSongListTableViewCell.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "StyledTableViewCell.h"
@class KNSongListModel;
@interface KNSongListTableViewCell : StyledTableViewCell
{
    UILabel * nameLabel;
    UILabel * titleLabel;
    UILabel * timeLabel;
}
@property (nonatomic,strong) KNSongListModel * model;
@end
