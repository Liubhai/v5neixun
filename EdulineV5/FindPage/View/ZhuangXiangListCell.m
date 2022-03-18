//
//  ZhuangXiangListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ZhuangXiangListCell.h"
#import "V5_Constant.h"

@implementation ZhuangXiangListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _grayLineTop = [[UIView alloc] initWithFrame:CGRectMake(15 + 15 / 2.0, 0, 1, 1)];
    _grayLineTop.backgroundColor = HEXCOLOR(0xE4E7ED);
    [self.contentView addSubview:_grayLineTop];
    
    _grayLineCenter = [[UIView alloc] initWithFrame:CGRectMake(15 + 15 / 2.0, 0, 1, 1)];
    _grayLineCenter.backgroundColor = HEXCOLOR(0xE4E7ED);
    [self.contentView addSubview:_grayLineCenter];

    _grayLine = [[UIView alloc] initWithFrame:CGRectMake(15 + 15 / 2.0, 0, 1, 60)];
    _grayLine.backgroundColor = HEXCOLOR(0xE4E7ED);
    [self.contentView addSubview:_grayLine];
    
    _jiantouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
    _jiantouImageView.image = [Image(@"exam_down_icon") converToMainColor];
    [self.contentView addSubview:_jiantouImageView];
    
    _getOrFreeIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(_jiantouImageView.right + 2, 0, 36, 16)];
    _getOrFreeIamgeView.image = Image(@"exam_yigouamai_icon");
    [self.contentView addSubview:_getOrFreeIamgeView];
    
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 5, 5)];
    _blueView.backgroundColor = EdlineV5_Color.themeColor;
    _blueView.layer.masksToBounds = YES;
    _blueView.layer.cornerRadius = _blueView.height / 2.0;
    [self.contentView addSubview:_blueView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_getOrFreeIamgeView.right + 4, 8, MainScreenWidth - 15 - (_getOrFreeIamgeView.right + 4), 20)];
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.font = SYSTEMFONT(15);
    _titleLabel.text = @"专项名称高中一年专项名称高中一年";
    [self.contentView addSubview:_titleLabel];
    
    _jiantouImageView.centerY = _titleLabel.centerY;
    _getOrFreeIamgeView.centerY = _titleLabel.centerY;
    _blueView.centerY = _titleLabel.centerY;
    
    _learnProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_titleLabel.left, 60 - 8 - 2, 180, 6)];
    _learnProgress.layer.masksToBounds = YES;
    _learnProgress.layer.cornerRadius = 3;
    _learnProgress.progress = 0.5;
    //设置它的风格，为默认的
    _learnProgress.trackTintColor= HEXCOLOR(0xF1F1F1);
    //设置轨道的颜色
    _learnProgress.progressTintColor= EdlineV5_Color.themeColor;
    [self.contentView addSubview:_learnProgress];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_learnProgress.left, _learnProgress.top - 4 - 14, 100, 14)];
    _progressLabel.font = SYSTEMFONT(11);
    _progressLabel.textColor = EdlineV5_Color.textThirdColor;
    _progressLabel.text = @"12/33";
    [self.contentView addSubview:_progressLabel];
//    _progressLabel.centerY = _learnProgress.centerY;
    
    _rightRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_learnProgress.right - 100, _learnProgress.top - 4 - 14, 100, 14)];
    _rightRateLabel.font = SYSTEMFONT(11);
    _rightRateLabel.textColor = EdlineV5_Color.textThirdColor;
    _rightRateLabel.text = @"正确率：13%";
    _rightRateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightRateLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - (100 + 14 + 82 + 15), 0, 100, 21)];
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = [NSString stringWithFormat:@"%@12,099.00",IOSMoneyTitle];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [self.contentView addSubview:_priceLabel];
    
    _getOrExamBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - ([NSString stringWithFormat:@"%@",IOSMoneyTitle].length>1 ? 110 : 94), 60 - 8 - 28, [NSString stringWithFormat:@"%@",IOSMoneyTitle].length>1 ? 110 : 94, 28)];
    _getOrExamBtn.backgroundColor = EdlineV5_Color.themeColor;
    _getOrExamBtn.layer.masksToBounds = YES;
    _getOrExamBtn.layer.cornerRadius = _getOrExamBtn.height / 2.0;
    [_getOrExamBtn setTitleColor:[UIColor whiteColor] forState:0];
    _getOrExamBtn.titleLabel.font = SYSTEMFONT(12);
    [_getOrExamBtn setTitle:@"购买" forState:0];
    [_getOrExamBtn addTarget:self action:@selector(buttonClickBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_getOrExamBtn];
    
    _priceLabel.centerY = _learnProgress.centerY;
    
    _doExamButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 22 - 15, (60 - 22) / 2.0, 22, 22)];
    [_doExamButton setImage:Image(@"zhuanxiang_more") forState:0];
    [_doExamButton addTarget:self action:@selector(buttonClickBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_doExamButton];
    
//    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 86, MainScreenWidth, 1)];
//    _lineView.backgroundColor = EdlineV5_Color.layarLineColor;
//    [self.contentView addSubview:_lineView];
}

- (void)setZhuangXiangCellInfo:(ZhuanXiangModel *)model cellIndex:(NSIndexPath *)index {
    _treeItem = model;
    
    _jiantouImageView.hidden = NO;
    _grayLine.hidden = NO;
    _grayLineTop.hidden = NO;
    _grayLineCenter.hidden = NO;
    _getOrFreeIamgeView.hidden = NO;
    _blueView.hidden = NO;
    _priceLabel.hidden = YES;
    _getOrExamBtn.hidden = NO;
    _doExamButton.hidden = NO;
    
    _titleLabel.text = model.title;
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,model.user_price];
    
    [_jiantouImageView setWidth:15];
    
    _grayLine.frame = CGRectMake(15 + 15 / 2.0, _jiantouImageView.bottom, 1, 60 - _jiantouImageView.bottom);
    _grayLineTop.frame = CGRectMake(15 + 15 / 2.0, 0, 1, _jiantouImageView.top);
    _grayLineCenter.frame = CGRectMake(15 + 15 / 2.0, _jiantouImageView.top, 1, _jiantouImageView.height);
    if (index.row == 0) {
        _grayLineTop.hidden = YES;
    }
    
    if (model.level == 0) {
        [_jiantouImageView setLeft:15];
        _jiantouImageView.hidden = NO;
        _grayLine.hidden = NO;
        _grayLineCenter.hidden = YES;
        _getOrFreeIamgeView.hidden = NO;
        _blueView.hidden = YES;
//        _priceLabel.hidden = NO;
        _getOrExamBtn.hidden = NO;
        _doExamButton.hidden = YES;
        
        if ([model.user_price floatValue]>0) {
//            _priceLabel.hidden = NO;
            if (model.has_bought) {
                _getOrFreeIamgeView.hidden = NO;
                _getOrFreeIamgeView.image = Image(@"exam_yigouamai_icon");
//                [_getOrExamBtn setTitle:@"开始答题" forState:0];
                _getOrExamBtn.hidden = YES;
                _priceLabel.hidden = YES;
                _doExamButton.hidden = NO;
            } else {
                _getOrFreeIamgeView.hidden = YES;
                [_getOrExamBtn setTitle:[NSString stringWithFormat:@"%@%@ | 购买",IOSMoneyTitle,model.user_price] forState:0];
            }
        } else {
            _priceLabel.hidden = YES;
            if (model.has_bought) {
                _getOrFreeIamgeView.hidden = YES;
                _getOrFreeIamgeView.image = Image(@"exam_yigouamai_icon");
            } else {
                _getOrFreeIamgeView.hidden = NO;
                _getOrFreeIamgeView.image = Image(@"exam_free_icon");
            }
            [_getOrExamBtn setTitle:@"开始答题" forState:0];
            _getOrExamBtn.hidden = YES;
            _doExamButton.hidden = NO;
        }
        if (!SWNOTEmptyArr(model.child)) {
//            [_jiantouImageView setWidth:0];
//            _jiantouImageView.hidden = YES;
        }
//        _getOrFreeIamgeView.frame = CGRectMake(SWNOTEmptyArr(model.child) ? _jiantouImageView.right + 2 : _jiantouImageView.right, 0, 36, 16);
        _getOrFreeIamgeView.frame = CGRectMake(_jiantouImageView.right + 2, 0, 36, 16);
        _getOrFreeIamgeView.centerY = _titleLabel.centerY;
        _titleLabel.frame = CGRectMake(_getOrFreeIamgeView.hidden ? _jiantouImageView.right + 4 : _getOrFreeIamgeView.right + 4, 8, MainScreenWidth - 15 - (_getOrFreeIamgeView.hidden ? _jiantouImageView.right + 4 : _getOrFreeIamgeView.right + 4), 20);
//        _titleLabel.frame = CGRectMake(_getOrFreeIamgeView.hidden ? _jiantouImageView.right + (SWNOTEmptyArr(model.child)?4:0) : _getOrFreeIamgeView.right + 4, 15, MainScreenWidth - 15 - (_getOrFreeIamgeView.hidden ? _jiantouImageView.right + (SWNOTEmptyArr(model.child)?4:0) : _getOrFreeIamgeView.right + 4), 20);
        
    } else if (model.level == 1) {
        [_jiantouImageView setLeft:33];
        [_jiantouImageView setWidth:0];
//        _jiantouImageView.hidden = NO;
        _jiantouImageView.hidden = YES;
        _grayLine.hidden = NO;
        _getOrFreeIamgeView.hidden = YES;
        _blueView.hidden = YES;
        _priceLabel.hidden = YES;
        _getOrExamBtn.hidden = YES;
        _doExamButton.hidden = NO;
        
        if (!SWNOTEmptyArr(model.child)) {
            [_jiantouImageView setWidth:0];
            _jiantouImageView.hidden = YES;
        }
        
        _titleLabel.frame = CGRectMake(_jiantouImageView.right, 8, MainScreenWidth - 15 - _jiantouImageView.right, 20);
        
    } else if (model.level == 2) {
        [_blueView setLeft:50];
        _jiantouImageView.hidden = YES;
        _getOrFreeIamgeView.hidden = YES;
        _blueView.hidden = NO;
        _priceLabel.hidden = YES;
        _getOrExamBtn.hidden = YES;
        _doExamButton.hidden = NO;
        
        _titleLabel.frame = CGRectMake(_blueView.right + 4, 8, MainScreenWidth - 15 - (_blueView.right + 4), 20);
        
    }
    
    if (_getOrFreeIamgeView.hidden) {
        _learnProgress.frame = CGRectMake(_titleLabel.left, 60 - 8 - 2, 180, 6);
    } else {
        _learnProgress.frame = CGRectMake(_getOrFreeIamgeView.left, 60 - 8 - 2, 180, 6);
    }
    _rightRateLabel.frame = CGRectMake(_learnProgress.right - 100, _learnProgress.top - 4 - 14, 100, 14);
    _progressLabel.frame = CGRectMake(_learnProgress.left, _learnProgress.top - 4 - 14, 100, 14);
    _progressLabel.text = [NSString stringWithFormat:@"%@/%@",model.answered_num,model.topic_count];
//    _progressLabel.centerY = _learnProgress.centerY;
    _learnProgress.progress = [model.answered_num floatValue] / [model.topic_count floatValue];
    
    [self refreshArrow];
}

- (void)buttonClickBy:(UIButton *)sender {
    if (sender == _getOrExamBtn) {
        if (_delegate && [_delegate respondsToSelector:@selector(userBuyOrExam:)]) {
            [_delegate userBuyOrExam:self];
        }
    } else if (sender == _doExamButton) {
        // 由于傻逼接口在子集中没返回是否购买了 就需要通过 parentItem 去判断咯
        if (_delegate && [_delegate respondsToSelector:@selector(userExamBy:)]) {
            [_delegate userExamBy:self];
        }
    }
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
        self.jiantouImageView.image = [Image(@"zhuanxiang_minus") converToMainColor];
//        self.jiantouImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.jiantouImageView.image = [Image(@"zhuanxaing_plussign") converToMainColor];
//        self.jiantouImageView.transform = CGAffineTransformMakeRotation(0);
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
