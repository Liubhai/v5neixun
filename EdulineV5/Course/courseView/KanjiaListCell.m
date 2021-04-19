//
//  KanjiaListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/30.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "KanjiaListCell.h"
#import "V5_Constant.h"

#define KanjiaListCellWidth MainScreenWidth - 60
#define KanjiaListCellHeight 64

@implementation KanjiaListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = EdlineV5_Color.courseActivityBackColor;
        [self makeUI];
    }
    return self;
}

// MARK: - 创建子视图
- (void)makeUI {
    _groupFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 44, 44)];
    _groupFace.clipsToBounds = YES;
    _groupFace.contentMode = UIViewContentModeScaleAspectFill;
    _groupFace.layer.masksToBounds = YES;
    _groupFace.layer.cornerRadius = 22;
    _groupFace.image = DefaultImage;;
    [self.contentView addSubview:_groupFace];
    
    _groupTitle = [[UILabel alloc] initWithFrame:CGRectMake(_groupFace.right + 5, _groupFace.top + 4, 100, 18)];
    _groupTitle.font = SYSTEMFONT(13);
    _groupTitle.textColor = EdlineV5_Color.textFirstColor;
    _groupTitle.text = @"小可爱是谁";
    [self.contentView addSubview:_groupTitle];
    
    _timeCountDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupTitle.left, _groupFace.bottom - 15 - 3, 150, 15)];
    _timeCountDownLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeCountDownLabel.text = @"2021-01-22  14:32";
    _timeCountDownLabel.font = SYSTEMFONT(10);
    [self.contentView addSubview:_timeCountDownLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(KanjiaListCellWidth - 15 - 105, 0, 105, 25)];
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.centerY = _groupFace.centerY;
    _priceLabel.textColor = EdlineV5_Color.courseActivityGroupColor;
    _priceLabel.text = @"砍掉3.92元";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
}

// MARK: - 设置数据
- (void)setKanjieDetailInfo:(NSDictionary *)dict {
    /**
     "current_user_id": 20,
     "current_bargain_price": 2.64,
     "create_time": 1618294803,
     "current_user_name": "用户15208432365",
     "current_user_avatar_url": null
     */
    if (SWNOTEmptyDictionary(dict)) {
        [_groupFace sd_setImageWithURL:EdulineUrlString(dict[@"current_user_avatar_url"]) placeholderImage:DefaultUserImage];
        _groupTitle.text = [NSString stringWithFormat:@"%@",dict[@"current_user_name"]];
        _timeCountDownLabel.text = [EdulineV5_Tool timeForBalanceYYMMDDHHMM:[NSString stringWithFormat:@"%@",dict[@"create_time"]]];
        _priceLabel.text = [NSString stringWithFormat:@"砍掉%@元",dict[@"current_bargain_price"]];
    }
}

@end
