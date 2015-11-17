//
//  KNSearchTableViewCell.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNSearchTableViewCell.h"
#import "KNSingerModel.h"
#import "KNImageView.h"
#import "UIImageView+WebCache.h"
@implementation KNSearchTableViewCell

- (void)setModel:(KNSingerModel *)model{
    _model = model;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_big] placeholderImage:[UIImage imageNamed:@"headerImage"]];
    
    nameLabel.text = model.name;
    if([model.company length]){
        titleLabel.text = model.company;
    }else{
        titleLabel.text = @"<无信息>";
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        headerImageView = [[KNImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];//带白圈圈的图片。设置了默认白色
        [self.contentView addSubview:headerImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.size.width+headerImageView.origin.x+5, headerImageView.origin.y, self.contentView.size.width-headerImageView.size.width-headerImageView.origin.x-30, 30)];
        nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.contentView addSubview:nameLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.origin.x, nameLabel.size.height+nameLabel.origin.y+5, nameLabel.size.width, nameLabel.size.height-10)];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:titleLabel];
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
