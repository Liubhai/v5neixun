//
//  QuestionAnswerCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "QuestionAnswerCell.h"

@implementation QuestionAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

// MARK: - 绘制视图
- (void)makeSubViews {
    _userFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 32, 32)];
    _userFace.layer.masksToBounds = YES;
    _userFace.layer.cornerRadius = _userFace.height / 2.0;
    _userFace.clipsToBounds = YES;
    _userFace.contentMode = UIViewContentModeScaleAspectFill;
    _userFace.image = DefaultUserImage;
    [self.contentView addSubview:_userFace];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 6, 20, 150, 16)];
    _userName.font = SYSTEMFONT(14);
    _userName.textColor = EdlineV5_Color.textFirstColor;
    _userName.text = @"小伙子你不行呀";
    [self.contentView addSubview:_userName];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 6, _userFace.bottom - 16, 100, 16)];
    _timeLabel.font = SYSTEMFONT(11);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.text = @"2020-12-23";
    [self.contentView addSubview:_timeLabel];
    
    _bestBack = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 94, 0, 94, 25)];
    _bestBack.backgroundColor = EdlineV5_Color.themeColor;
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerBottomLeft; // 圆角位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_bestBack.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(_bestBack.height / 2.0, _bestBack.height / 2.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bestBack.bounds;
    maskLayer.path = path.CGPath;
    _bestBack.layer.mask = maskLayer;
    [self.contentView addSubview:_bestBack];
    _bestBack.centerY = _userFace.centerY;
    
    _bestIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 12, 15)];
    _bestIcon.image = Image(@"bestanswer_icon");
    [_bestBack addSubview:_bestIcon];
    
    _bestLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bestIcon.right + 5, 0, 60, 25)];
    _bestLabel.font = SYSTEMFONT(12);
    _bestLabel.text = @"最佳答案";
    _bestLabel.textColor = [UIColor whiteColor];
    [_bestBack addSubview:_bestLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _userFace.bottom + 12, MainScreenWidth - 30, 20)];
    _contentLabel.font = SYSTEMFONT(15);
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(15, _contentLabel.top, MainScreenWidth - 30, 20)];
    [self.contentView addSubview:_maskView];
    
    _seeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _maskView.bottom, 200, 32)];
    _seeButton.layer.masksToBounds = YES;
    _seeButton.layer.cornerRadius = _seeButton.height / 2.0;
    _seeButton.layer.borderColor = EdlineV5_Color.questionSeeButtonLayerColor.CGColor;
    _seeButton.layer.borderWidth = 1.0;
    [_seeButton setTitleColor:EdlineV5_Color.questionSeeButtonLayerColor forState:0];
    _seeButton.titleLabel.font = SYSTEMFONT(13);
    [self.contentView addSubview:_seeButton];
    
    _pictureViews = [[UIView alloc] initWithFrame:CGRectMake(0, _contentLabel.bottom + 12, MainScreenWidth, 0)];
    [self.contentView addSubview:_pictureViews];
    
    
    _replyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, _pictureViews.bottom + 16, 20, 20)];
    _replyIcon.image = Image(@"comment_icon");
    [self.contentView addSubview:_replyIcon];
    
    _replyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_replyIcon.right + 4, _pictureViews.bottom + 16, 50, 20)];
    _replyCountLabel.font = SYSTEMFONT(12);
    _replyCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_replyCountLabel];
    
    _zanCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 50, _pictureViews.bottom + 16, 50, 20)];
    _zanCountLabel.font = SYSTEMFONT(12);
    _zanCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_zanCountLabel];
    
    _zanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_zanCountLabel.left - 4 - 20, _pictureViews.bottom + 16, 20, 20)];
    _zanIcon.image = Image(@"dianzan_icon_norm");
    [self.contentView addSubview:_zanIcon];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _replyIcon.bottom + 15, MainScreenWidth, 5)];
    _lineView.backgroundColor = EdlineV5_Color.backColor;
    [self.contentView addSubview:_lineView];
}

// MARK: - 数据赋值
- (void)setQuestionAnswerListCellInfo:(NSDictionary *)dict {
    
    _questionAnswerCellInfo = dict;
    
    _contentLabel.frame = CGRectMake(15, _userFace.bottom + 12, MainScreenWidth - 30, 20);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！当地时间23日，中国驻比利时大使曹忠明和驻德国大使吴恳也分别向比方和德方提出严";
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:(_contentLabel.height > 80) ? 80 : _contentLabel.height];
    
    [_maskView setHeight:_contentLabel.height];
    
    [_maskView.layer removeAllSublayers];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _maskView.bounds;
    gradientLayer.startPoint = CGPointMake(0.5, 0); //渐变色起始位置
    gradientLayer.endPoint = CGPointMake(0.5, 1); //渐变色终止位置
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.37].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gradientLayer.locations = @[@(0), @(1.0)]; // 对应colors的alpha值

    [_maskView.layer insertSublayer:gradientLayer atIndex:0];
    
    _seeButton.frame = CGRectMake(0, _maskView.bottom, 200, 32);
    [_seeButton setTitle:@"¥12去查看 （2人看过）" forState:0];
    _seeButton.centerX = MainScreenWidth / 2.0;
    
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailPicTap:)];
        [pic addGestureRecognizer:tap];
        [_pictureViews addSubview:pic];
        if (i == (picCount - 1)) {
            [_pictureViews setHeight:pic.bottom];
        }
    }
    
    _replyIcon.frame = CGRectMake(15, _pictureViews.bottom + 16, 20, 20);
    _replyIcon.image = Image(@"comment_icon");
    [self.contentView addSubview:_replyIcon];
    
    _replyCountLabel.frame = CGRectMake(_replyIcon.right + 4, _pictureViews.bottom + 16, 50, 20);
    _replyCountLabel.text = @"22";
    
    _zanCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 50, _pictureViews.bottom + 16, 50, 20);
    _zanCountLabel.text = @"55";
    
    _zanIcon.frame = CGRectMake(_zanCountLabel.left - 4 - 20, _pictureViews.bottom + 16, 20, 20);
    
    [_lineView setTop:_replyIcon.bottom + 15];
    [self setHeight:_lineView.bottom];
}

- (void)setQuestionAnswerDetailListCellInfo:(NSDictionary *)dict {
    
    _questionAnswerCellInfo = dict;
    
    _contentLabel.frame = CGRectMake(15, _userFace.bottom + 12, MainScreenWidth - 30, 20);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！问答标题列表最多显示4排！当地时间23日，中国驻比利时大使曹忠明和驻德国大使吴恳也分别向比方和德方提出严";
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:_contentLabel.height];
    
    _maskView.hidden = YES;
    _seeButton.hidden = YES;
    
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailPicTap:)];
        [pic addGestureRecognizer:tap];
        [_pictureViews addSubview:pic];
        if (i == (picCount - 1)) {
            [_pictureViews setHeight:pic.bottom];
        }
    }
    
    _replyCountLabel.hidden = YES;
    _replyIcon.hidden = YES;
    
    _zanCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 50, _pictureViews.bottom + 16, 50, 20);
    _zanCountLabel.text = @"55";
    
    _zanIcon.frame = CGRectMake(_zanCountLabel.left - 4 - 20, _pictureViews.bottom + 16, 20, 20);
    
    [_lineView setTop:_zanCountLabel.bottom + 15];
    [self setHeight:_lineView.bottom];
    
}

- (void)detailPicTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(questionDetailCellPicTap:imagetag:toView:)]) {
        [_delegate questionDetailCellPicTap:_questionAnswerCellInfo imagetag:tap.view.tag - 66 toView:tap.view];
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
