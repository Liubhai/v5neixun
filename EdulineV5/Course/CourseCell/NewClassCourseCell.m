//
//  NewClassCourseCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "NewClassCourseCell.h"

@implementation NewClassCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _CourseTypeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 18)];
    _CourseTypeIcon.centerY = 50 / 2.0;
    _CourseTypeIcon.clipsToBounds = YES;
    _CourseTypeIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_CourseTypeIcon];
    
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(26, 17, 3, 16)];
    _blueView.backgroundColor = EdlineV5_Color.themeColor;
    _blueView.layer.masksToBounds = YES;
    _blueView.layer.cornerRadius = 2;
    [self addSubview:_blueView];
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(36, 0, 32, 16)];
    _typeIcon.centerY = 50 / 2.0;
    [self addSubview:_typeIcon];
    
    _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 14, 0, 14, 16)];
    _lockIcon.centerY = 50 / 2.0;
    _lockIcon.image = Image(@"contents_icon_lock");
    _lockIcon.hidden = YES;
    [self addSubview:_lockIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeIcon.right + 5, 0, 150, 50)];
    _titleLabel.textColor = EdlineV5_Color.textSecendColor;
    _titleLabel.font = SYSTEMFONT(14);
    [self addSubview:_titleLabel];
    
    _freeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.right + 10, (50 - 16) / 2.0, 36, 16)];
    _freeImageView.image = Image(@"contents_icon_free");
    _freeImageView.hidden = YES;
    [self addSubview:_freeImageView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_freeImageView.right + 10, (50 - 16) / 2.0, 100, 16)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.layer.masksToBounds = YES;
    _priceLabel.layer.cornerRadius = 1;
    _priceLabel.layer.borderColor = EdlineV5_Color.faildColor.CGColor;
    _priceLabel.layer.borderWidth = 1;
    _priceLabel.font = SYSTEMFONT(14);
    [self addSubview:_priceLabel];
    
    _courseRightBtn = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 14, 0, 14, 8)];
    _courseRightBtn.image = Image(@"contents_down");
    _courseRightBtn.centerY = 50 / 2.0;
    [self addSubview:_courseRightBtn];
    
    _isLearningIcon = [[playAnimationView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 16, 0, 16, 17)];
    _isLearningIcon.centerY = 50 / 2.0;
    _isLearningIcon.image = Image(@"comment_playing");
    _isLearningIcon.animationImages = @[Image(@"playing1"),Image(@"playing2")];
    _isLearningIcon.highlightedAnimationImages = @[Image(@"playing1"),Image(@"playing2")];
    _isLearningIcon.animationDuration = 0.4;
    [self addSubview:_isLearningIcon];
    
    _learnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 85, 0, 85, 50)];
    _learnTimeLabel.font = SYSTEMFONT(11);
    _learnTimeLabel.textAlignment = NSTextAlignmentRight;
    _learnTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_learnTimeLabel];
    
    _learnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14)];
    _learnIcon.centerY = 50 / 2.0;
    _learnIcon.image = Image(@"comment_his_icon");
    [self addSubview:_learnIcon];
    
}

- (void)setCourseInfo:(CourseListModel *)model {
    _treeItem = model;
    _titleLabel.text = model.title;
    [self refreshArrow];
}

- (void)updateItem {
    // 刷新 title 前面的箭头方向
    [UIView animateWithDuration:0.25 animations:^{
        [self refreshArrow];
    }];
}

#pragma mark - Private Method

- (void)refreshArrow {
    
    if (self.treeItem.isExpand) {
        self.courseRightBtn.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.courseRightBtn.transform = CGAffineTransformMakeRotation(0);
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
