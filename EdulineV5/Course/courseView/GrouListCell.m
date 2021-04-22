//
//  GrouListCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/23.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "GrouListCell.h"

#define GroupListCellWidth MainScreenWidth - 60
#define GroupListCellHeight 70

@implementation GrouListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

// MARK: - 创建子视图
- (void)makeUI {
    _groupFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    _groupFace.clipsToBounds = YES;
    _groupFace.contentMode = UIViewContentModeScaleAspectFill;
    _groupFace.layer.masksToBounds = YES;
    _groupFace.layer.cornerRadius = 20;
    _groupFace.image = DefaultImage;;
    [self.contentView addSubview:_groupFace];
    
    _groupTitle = [[UILabel alloc] initWithFrame:CGRectMake(_groupFace.right + 5, _groupFace.top, 100, 15)];
    _groupTitle.font = SYSTEMFONT(13);
    _groupTitle.textColor = EdlineV5_Color.textFirstColor;
    _groupTitle.text = @"还差3人成团";
    [self.contentView addSubview:_groupTitle];
    
//    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupTitle.right + 10, 0, 100, GroupListCellHeight)];
//    _priceLabel.textColor = RGBHex(0xFF0000);
//    _priceLabel.text = @"100.0育币";
//    _priceLabel.font = SYSTEMFONT(13);
//    [self addSubview:_priceLabel];
    
    _timeCountDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupTitle.left, _groupFace.bottom - 11, 150, 11)];
    _timeCountDownLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeCountDownLabel.text = @"剩余时间00:22:33结束";
    _timeCountDownLabel.font = SYSTEMFONT(10);
    [self.contentView addSubview:_timeCountDownLabel];
    
    _groupJoinButton = [[UIButton alloc] initWithFrame:CGRectMake(GroupListCellWidth - 15 - 60, 0, 60, 25)];
    [_groupJoinButton setBackgroundColor:EdlineV5_Color.courseActivityGroupColor];
    [_groupJoinButton setTitleColor:[UIColor whiteColor] forState:0];
    [_groupJoinButton setTitle:@"去拼团" forState:0];
    _groupJoinButton.layer.masksToBounds = YES;
    _groupJoinButton.layer.cornerRadius = 2;
    _groupJoinButton.titleLabel.font = SYSTEMFONT(13);
    _groupJoinButton.centerY = _groupFace.centerY;
    [_groupJoinButton addTarget:self action:@selector(joinGroupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_groupJoinButton];
}

- (void)setGroupListInfo:(NSDictionary *)groupInfo timeCount:(NSInteger)timeCount {
    _groupInfo = groupInfo;
    [_groupFace sd_setImageWithURL:EdulineUrlString([groupInfo objectForKey:@"current_user_avatar_url"]) placeholderImage:Image(@"站位图")];
//    _priceLabel.text = [NSString stringWithFormat:@"%@",[groupInfo objectForKey:@"oprice"]];
    NSString *totalCount = [NSString stringWithFormat:@"%@",[groupInfo objectForKey:@"total_num"]];
    NSString *joinCount = [NSString stringWithFormat:@"%@",[groupInfo objectForKey:@"join_num"]];
    _groupTitle.text = [NSString stringWithFormat:@"还差%@人成团",@([totalCount integerValue] - [joinCount integerValue])];
    NSInteger timeSpan = [[NSString stringWithFormat:@"%@",[groupInfo objectForKey:@"expiry_countdown"]] integerValue];
    if (timeSpan - timeCount<=0) {
        _timeCountDownLabel.text = @"已结束";
    } else {
        _timeCountDownLabel.text = [NSString stringWithFormat:@"剩余%@",[EdulineV5_Tool timeChangeTimerWithSeconds:timeSpan - timeCount]];
    }
}

- (void)joinGroupButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(joinGroupByGroupId:groupInfo:)]) {
        [_delegate joinGroupByGroupId:[NSString stringWithFormat:@"%@",[_groupInfo objectForKey:@"id"]] groupInfo:_groupInfo];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//- (void)eventCellTimerDown {
//    if (timeSpan<=0) {
//        [cellTimer invalidate];
//        cellTimer = nil;
//    } else {
//        timeSpan--;
//        _timeCountDownLabel.text = [NSString stringWithFormat:@"剩余时间%@结束",[YunKeTang_Api_Tool timeChangeWithSeconds:timeSpan]];
//    }
//}

@end
