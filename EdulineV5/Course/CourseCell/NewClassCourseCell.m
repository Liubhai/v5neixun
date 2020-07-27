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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)setCourseInfo:(CourseListModel *)model isMainPage:(BOOL)isMainPage {
    _treeItem = model;
    _titleLabel.text = model.title;
    
    /**
     @property (strong, nonatomic) UIImageView *CourseTypeIcon;
     @property (strong, nonatomic) UIView *blueView;
     @property (strong, nonatomic) UIImageView *typeIcon;
     @property (strong, nonatomic) UIImageView *lockIcon;
     @property (strong, nonatomic) UILabel *titleLabel;
     @property (strong, nonatomic) UIImageView *freeImageView;
     @property (strong, nonatomic) UILabel *priceLabel;
     @property (strong, nonatomic) UIImageView *courseRightBtn;
     @property (strong, nonatomic) UIImageView *learnIcon;
     @property (strong, nonatomic) UILabel *learnTimeLabel;
     @property (strong, nonatomic) playAnimationView *isLearningIcon;
     */
    
    // 处理一系列现隐逻辑
    if ([model.type isEqualToString:@"课程"]) {
        _CourseTypeIcon.hidden = NO;
        _blueView.hidden = YES;
        _typeIcon.hidden = YES;
        _freeImageView.hidden = YES;
        _priceLabel.hidden = YES;
        _courseRightBtn.hidden = NO;
        _learnIcon.hidden = YES;
        _learnTimeLabel.hidden = YES;
        _isLearningIcon.hidden = YES;
        _titleLabel.frame = CGRectMake(_CourseTypeIcon.right + 5, 0, 150, 50);
        if ([model.course_type isEqualToString:@"1"]) {
            _CourseTypeIcon.image = Image(@"zj_dianbo");
        } else if ([model.course_type isEqualToString:@"2"]) {
            _CourseTypeIcon.image = Image(@"zj_live");
        }
    } else if ([model.type isEqualToString:@"章"]) {
        _CourseTypeIcon.hidden = YES;
        _blueView.hidden = NO;
        _typeIcon.hidden = YES;
        _freeImageView.hidden = YES;
        _priceLabel.hidden = YES;
        _courseRightBtn.hidden = NO;
        _learnIcon.hidden = YES;
        _learnTimeLabel.hidden = YES;
        _isLearningIcon.hidden = YES;
        _titleLabel.frame = CGRectMake(_blueView.right + 5, 0, 150, 50);
    } else if ([model.type isEqualToString:@"节"]) {
        _CourseTypeIcon.hidden = YES;
        _blueView.hidden = YES;
        _typeIcon.hidden = YES;
        _freeImageView.hidden = YES;
        _priceLabel.hidden = YES;
        _courseRightBtn.hidden = NO;
        _learnIcon.hidden = YES;
        _learnTimeLabel.hidden = YES;
        _isLearningIcon.hidden = YES;
        _titleLabel.frame = CGRectMake(36, 0, 150, 50);
    } else if ([model.type isEqualToString:@"课时"]) {
        _CourseTypeIcon.hidden = YES;
        _blueView.hidden = YES;
        _typeIcon.hidden = NO;
        _freeImageView.hidden = NO;
        _priceLabel.hidden = YES;
        _courseRightBtn.hidden = YES;
        
        
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
        
        if (model.audition > 0) {
            _freeImageView.hidden = NO;
        } else {
            _freeImageView.hidden = YES;
        }
        
        if ([model.price floatValue]>0) {
            _priceLabel.hidden = NO;
            if (model.is_buy) {
                _priceLabel.text = @"已购买";
                _freeImageView.hidden = YES;
            }
        } else {
            _priceLabel.hidden = YES;
            if (model.is_buy) {
                _freeImageView.hidden = YES;
            }
        }
        
        CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
        CGFloat titleWidth = ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4) > 150 ? 150 : ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4);
        [_titleLabel setLeft:_typeIcon.right + 5];
        [_titleLabel setWidth:titleWidth];
        [_priceLabel setWidth:priceWidth];
        [_freeImageView setLeft:_titleLabel.right + 3];
        
        [_priceLabel setLeft:(_freeImageView.hidden ? _titleLabel.right : _freeImageView.right) + 3];
        
        
        if (isMainPage) {
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
            _isLearningIcon.hidden = YES;
        } else {
            if (model.isPlaying) {
                _learnIcon.hidden = YES;
                _learnTimeLabel.hidden = YES;
                _isLearningIcon.hidden = NO;
                [self setAnimation:_isLearningIcon];
            } else {
                if ([model.section_data.data_type isEqualToString:@"3"] || [model.section_data.data_type isEqualToString:@"4"]) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
                    if (model.section_rate.status == 957) {
                        _learnIcon.hidden = YES;
                        _learnTimeLabel.hidden = YES;
                    } else if (model.section_rate.status == 999) {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_his_icon");
                        _learnTimeLabel.text = [NSString stringWithFormat:@"学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:model.section_rate.current_time]];
                    } else {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_fin_icon");
                        _learnTimeLabel.text = @"已完成";
                    }
                }
            }
        }
        if ([model.section_data.data_type isEqualToString:@"1"]) {
            _typeIcon.image = Image(@"contents_icon_video");
        } else if ([model.section_data.data_type isEqualToString:@"2"]) {
            _typeIcon.image = Image(@"contents_icon_vioce");
        } else if ([model.section_data.data_type isEqualToString:@"3"]) {
            _typeIcon.image = Image(@"img_text_icon");
        } else if ([model.section_data.data_type isEqualToString:@"4"]) {
            _typeIcon.image = Image(@"ebook_icon_word");
        } else {
            _typeIcon.image = Image(@"contents_icon_video");
        }
    }
    
    
    
    
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

- (void)setAnimation:(UIImageView *)sender {
    if (sender.isAnimating) {
        /// 先暂停再结束是因为有可能属性表现的是正在动画,但是实际上是没做动画.直接调用startAnimation是不会做动画的
        [sender stopAnimating];
        [sender startAnimating];
    } else {
        [sender startAnimating];
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
