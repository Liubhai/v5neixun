//
//  QuestionListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "QuestionListCell.h"

@implementation QuestionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

// MARK: - 绘制视图
- (void)makeSubViews {
    _userFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
    _userFace.layer.masksToBounds = YES;
    _userFace.layer.cornerRadius = _userFace.height / 2.0;
    _userFace.clipsToBounds = YES;
    _userFace.contentMode = UIViewContentModeScaleAspectFill;
    _userFace.image = DefaultUserImage;
    [self.contentView addSubview:_userFace];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 6, 20, 150, 20)];
    _userName.font = SYSTEMFONT(12);
    _userName.textColor = EdlineV5_Color.textFirstColor;
    _userName.text = @"小伙子你不行呀";
    [self.contentView addSubview:_userName];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 20, 100, 20)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.text = @"2020-12-23";
    [self.contentView addSubview:_timeLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _userFace.bottom + 12, MainScreenWidth - 30, 20)];
    _contentLabel.font = SYSTEMFONT(15);
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _pictureViews = [[UIView alloc] initWithFrame:CGRectMake(0, _contentLabel.bottom + 12, MainScreenWidth, 0)];
    [self.contentView addSubview:_pictureViews];
    
    _scanCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _pictureViews.bottom + 20, 50, 17)];
    _scanCountLabel.font = SYSTEMFONT(12);
    _scanCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_scanCountLabel];
    
    _fengeLine = [[UIView alloc] initWithFrame:CGRectMake(_scanCountLabel.right + 8, 0, 1, 8)];
    _fengeLine.backgroundColor = EdlineV5_Color.backColor;
    [self.contentView addSubview:_fengeLine];
    
    _answerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_fengeLine.right + 8, _scanCountLabel.top, 50, 17)];
    _answerCountLabel.font = SYSTEMFONT(12);
    _answerCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_answerCountLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _pictureViews.bottom + 20, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.backColor;
    [self.contentView addSubview:_lineView];
}

// MARK: - 数据赋值
- (void)setQuestionListCellInfo:(NSDictionary *)dict {
    
    _scanCountLabel.hidden = YES;
    _fengeLine.hidden = YES;
    _answerCountLabel.hidden = YES;
    
    _questionCellInfo = dict;
    
    _contentLabel.frame = CGRectMake(15, _userFace.bottom + 12, MainScreenWidth - 30, 20);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！当地时间23日，中国驻比利时大使曹忠明和驻德国大使吴恳也分别向比方和德方提出严";
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:(_contentLabel.height > 80) ? 80 : _contentLabel.height];
    
    [_pictureViews removeAllSubviews];
    NSInteger picCount = 5;
    CGFloat leftSpace = 15;
    CGFloat inSpace = 11;
    CGFloat picWidth = (MainScreenWidth - leftSpace * 2 - inSpace * 2) / 3.0;
    
    if (picCount) {
        [_pictureViews setTop:_contentLabel.bottom + 12];
    } else {
        [_pictureViews setTop:_contentLabel.bottom];
    }
    
    for (int i = 0; i<picCount; i++) {
        // x 余 y 正
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace + (picWidth + inSpace) * (i%3), (inSpace + picWidth) * (i/3), picWidth, picWidth)];
        pic.clipsToBounds = YES;
        pic.contentMode = UIViewContentModeScaleAspectFill;
        pic.image = DefaultImage;
        pic.tag = 66 + i;
        pic.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)];
        [pic addGestureRecognizer:tap];
        [_pictureViews addSubview:pic];
        if (i == (picCount - 1)) {
            [_pictureViews setHeight:pic.bottom];
        }
    }
    
    [_lineView setTop:_pictureViews.bottom + 20];
    [self setHeight:_lineView.bottom];
}

- (void)setQustionDetailCellInfo:(NSDictionary *)dict {
    
    _userFace.hidden = YES;
    _userName.hidden = YES;
    _timeLabel.hidden = YES;
    
    _questionCellInfo = dict;
    
    _contentLabel.frame = CGRectMake(15, 15, MainScreenWidth - 30, 20);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！当地时间23日，中国驻比利时大使曹忠明和驻德国大使吴恳也分别向比方和德方提出严";
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:_contentLabel.height];
    
    [_pictureViews removeAllSubviews];
    NSInteger picCount = 5;
    CGFloat leftSpace = 15;
    CGFloat inSpace = 11;
    CGFloat picWidth = (MainScreenWidth - leftSpace * 2 - inSpace * 2) / 3.0;
    
    if (picCount) {
        [_pictureViews setTop:_contentLabel.bottom + 12];
    } else {
        [_pictureViews setTop:_contentLabel.bottom];
    }
    
    for (int i = 0; i<picCount; i++) {
        // x 余 y 正
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace + (picWidth + inSpace) * (i%3), (inSpace + picWidth) * (i/3), picWidth, picWidth)];
        pic.clipsToBounds = YES;
        pic.contentMode = UIViewContentModeScaleAspectFill;
        pic.image = DefaultImage;
        pic.tag = 66 + i;
        pic.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)];
        [pic addGestureRecognizer:tap];
        [_pictureViews addSubview:pic];
        if (i == (picCount - 1)) {
            [_pictureViews setHeight:pic.bottom];
        }
    }
    
    _scanCountLabel.text = @"浏览 32";
    CGFloat scanWidth = [_scanCountLabel.text sizeWithFont:_scanCountLabel.font].width + 4;
    _scanCountLabel.frame = CGRectMake(15, _pictureViews.bottom + 20, scanWidth, 17);
    
    _fengeLine = [[UIView alloc] initWithFrame:CGRectMake(_scanCountLabel.right + 4, 0, 1, 8)];
    _fengeLine.centerY = _scanCountLabel.centerY;
    
    _answerCountLabel.text = @"回答 13";
    CGFloat answerWidth = [_answerCountLabel.text sizeWithFont:_answerCountLabel.font].width + 4;
    _answerCountLabel.frame = CGRectMake(_fengeLine.right + 8, _scanCountLabel.top, answerWidth, 17);
    
    [_lineView setTop:_scanCountLabel.bottom + 15];
    [_lineView setHeight:8];
    [self setHeight:_lineView.bottom];
    
}

- (void)picTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(showPic:imagetag:toView:)]) {
        [_delegate showPic:_questionCellInfo imagetag:tap.view.tag - 66 toView:tap.view];
    }
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
