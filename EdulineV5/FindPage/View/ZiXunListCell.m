//
//  ZiXunListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ZiXunListCell.h"
#import "V5_Constant.h"

// 101.5

@implementation ZiXunListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 30, 22)];
    _themeLabel.font = SYSTEMFONT(15);
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    _themeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_themeLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_themeLabel.left, _themeLabel.bottom + 4, _themeLabel.width, 20)];
    _introLabel.font = SYSTEMFONT(15);
    _introLabel.textColor = EdlineV5_Color.textSecendColor;
    _introLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_introLabel];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 128, (101 - 72) / 2.0, 128, 72)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 2;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_faceImageView];
    
    _lookCountImage = [[UIImageView alloc] initWithFrame: CGRectMake(15, 0, 13, 8)];
    _lookCountImage.image = Image(@"news_view_icon");
    [self addSubview:_lookCountImage];
    
    _lookCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lookCountImage.right + 5, _introLabel.bottom + 10, 100, 18.5)];
    _lookCountLabel.font = SYSTEMFONT(13);
    _lookCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_lookCountLabel];
    
    _lookCountImage.centerY = _lookCountLabel.centerY;
    
    _fengeLine1 = [[UIView alloc] initWithFrame:CGRectMake(_lookCountLabel.right + 9.5, 0, 0.5, 8)];
    _fengeLine1.backgroundColor = EdlineV5_Color.fengeLineColor;
    _fengeLine1.centerY = _lookCountLabel.centerY;
    [self addSubview:_fengeLine1];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_fengeLine1.right + 9.5, _lookCountLabel.top, 100, _lookCountLabel.height)];
    _timeLabel.font = SYSTEMFONT(13);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_timeLabel];
    
    _fengeLine2 = [[UIView alloc] initWithFrame: CGRectMake(15, 101, MainScreenWidth - 15, 0.5)];
    _fengeLine2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_fengeLine2];
}

- (void)setZiXunInfo:(NSDictionary *)info {
    
    _faceImageView.hidden = YES;
    if ([info objectForKey:@"cover_url"]) {
        [_faceImageView sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
        _faceImageView.hidden = NO;
        _themeLabel.frame = CGRectMake(15, 15, MainScreenWidth - 30 - _faceImageView.width - 3.5, 22);
        _introLabel.frame = CGRectMake(_themeLabel.left, _themeLabel.bottom + 4, _themeLabel.width, 20);
    } else {
        _themeLabel.frame = CGRectMake(15, 15, MainScreenWidth - 30, 22);
        _introLabel.frame = CGRectMake(_themeLabel.left, _themeLabel.bottom + 4, _themeLabel.width, 20);
    }
    
    _themeLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    
    _introLabel.text = [NSString stringWithFormat:@"%@",SWNOTEmptyStr([info objectForKey:@"abstract"]) ? [info objectForKey:@"abstract"] : @""];
    
    _lookCountLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"read_count"]];
    
    CGFloat lookWidth = [_lookCountLabel.text sizeWithFont:_lookCountLabel.font].width + 4;
    [_lookCountLabel setWidth:lookWidth];
    [_fengeLine1 setLeft:_lookCountLabel.right + 9.5];
    [_timeLabel setLeft:_fengeLine1.right + 9.5];
    
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool formateTime:[info objectForKey:@"publish_time"]]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
