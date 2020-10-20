//
//  MyCenterUserInfoView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterUserInfoView.h"
#import "V5_Constant.h"
#import "V5_UserModel.h"

@implementation MyCenterUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 234 + MACRO_UI_LIUHAI_HEIGHT)];
    _backImageView.image = [Image(@"pre_bg") converToOtherColor:EdlineV5_Color.themeColor];
    [self addSubview:_backImageView];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    [_leftBtn setImage:Image(@"pre_nav_home") forState:0];
    _leftBtn.hidden = YES;
    [self addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(MainScreenWidth-52, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 53, 44);
    [_rightBtn setImage:Image(@"pre_nav_mes") forState:0];
    [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _redLabel.layer.masksToBounds = YES;
    _redLabel.layer.cornerRadius = _redLabel.height / 2.0;
    _redLabel.backgroundColor = EdlineV5_Color.faildColor;
    _redLabel.hidden = YES;
    _redLabel.center = CGPointMake(_rightBtn.width / 2.0 + 10, _rightBtn.height / 2.0 - 10);
    [_rightBtn addSubview:_redLabel];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(_rightBtn.left - 44, _rightBtn.top, 44, 44);
    [_setBtn setImage:Image(@"pre_nav_set") forState:0];
    [_setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_setBtn];
    
    _userFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _leftBtn.bottom + 15, 64, 64)];
    _userFaceImageView.layer.masksToBounds = YES;
    _userFaceImageView.layer.cornerRadius = _userFaceImageView.height / 2.0;
    _userFaceImageView.clipsToBounds = YES;
    _userFaceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userFaceImageView.userInteractionEnabled = YES;
    _userFaceImageView.image = DefaultUserImage;
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceTapClick)];
    [_userFaceImageView addGestureRecognizer:faceTap];
    [self addSubview:_userFaceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFaceImageView.right + 15, _userFaceImageView.top, 150, _userFaceImageView.height / 2.0)];
    _nameLabel.textColor = [UIColor whiteColor];;
    _nameLabel.font = SYSTEMFONT(17);
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceTapClick)];
    [_nameLabel addGestureRecognizer:nameTap];
    [self addSubview:_nameLabel];
    CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
    [_nameLabel setWidth:nameWidth];
    
    _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.right, 0, 15, 13)];
    _levelImageView.image = Image(@"vip_icon");
    _levelImageView.centerY = _nameLabel.centerY;
    _levelImageView.hidden = YES;
    [self addSubview:_levelImageView];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, MainScreenWidth - _nameLabel.left - 86, _nameLabel.height)];
    _introLabel.textColor = [UIColor whiteColor];
    _introLabel.font = SYSTEMFONT(13);
    [self addSubview:_introLabel];
    
    _menberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 86, 0, 86, 32)];
    _menberImageView.image = Image(@"pre_vip_button");
    _menberImageView.centerY = _userFaceImageView.centerY;
    _menberImageView.hidden = YES;
    [self addSubview:_menberImageView];
    
    _menberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _menberBtn.frame = CGRectMake(_menberImageView.left, _menberImageView.top, _menberImageView.width, _menberImageView.height);
    _menberBtn.backgroundColor = [UIColor clearColor];
    _menberBtn.titleLabel.font = SYSTEMFONT(14);
    [_menberBtn setTitle:@" 开通会员》" forState:0];
    [_menberBtn setTitleColor:HEXCOLOR(0xA87941) forState:0];
    [_menberBtn addTarget:self action:@selector(menberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _menberBtn.hidden = YES;
    [self addSubview:_menberBtn];
    
}

- (void)faceTapClick {
    if (_delegate && [_delegate respondsToSelector:@selector(goToUserInfoVC)]) {
        [_delegate goToUserInfoVC];
    }
}

- (void)setBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToSetingVC)]) {
        [_delegate goToSetingVC];
    }
}

- (void)rightClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToMessageVC)]) {
        [_delegate goToMessageVC];
    }
}

- (void)menberButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToMenberCenter)]) {
        [_delegate goToMenberCenter];
    }
}

- (void)setUserInfo:(NSDictionary *)info {
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [_userFaceImageView sd_setImageWithURL:EdulineUrlString([V5_UserModel avatar]) placeholderImage:DefaultUserImage];
        [_nameLabel setTop:_userFaceImageView.top];
        _introLabel.hidden = NO;
        _introLabel.text = [NSString stringWithFormat:@"%@",[V5_UserModel intro]];
        _nameLabel.text = [NSString stringWithFormat:@"%@",[V5_UserModel uname]];
        _levelImageView.hidden = NO;
        CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
        [_nameLabel setWidth:nameWidth];
        [_levelImageView setLeft:_nameLabel.right];
        if ([[V5_UserModel vipStatus] isEqualToString:@"1"]) {
            _levelImageView.hidden = NO;
            [_menberBtn setTitle:@" 续费会员》" forState:0];
            _levelImageView.image = Image(@"vip_icon");
            _menberBtn.hidden = NO;
            _menberImageView.hidden = NO;
        } else if ([[V5_UserModel vipStatus] isEqualToString:@"2"]) {
            _levelImageView.hidden = NO;
            _levelImageView.image = Image(@"vip_grey_icon");
            [_menberBtn setTitle:@" 续费会员》" forState:0];
            _menberBtn.hidden = NO;
            _menberImageView.hidden = NO;
        } else if ([[V5_UserModel vipStatus] isEqualToString:@"0"]) {
            _levelImageView.hidden = YES;
            [_menberBtn setTitle:@" 开通会员》" forState:0];
            _menberBtn.hidden = NO;
            _menberImageView.hidden = NO;
        } else {
            _levelImageView.hidden = YES;
            _menberBtn.hidden = YES;
            _menberImageView.hidden = YES;
            [_menberBtn setTitle:@" 开通会员》" forState:0];
        }
        if ([ShowAudit isEqualToString:@"1"]) {
            _levelImageView.hidden = YES;
            _menberImageView.hidden = YES;
            _menberBtn.hidden = YES;
        }
    } else {
        _userFaceImageView.image = DefaultUserImage;
        _nameLabel.centerY = _userFaceImageView.centerY;
        _nameLabel.text = @"登录/注册";
        _introLabel.hidden = YES;
        _levelImageView.hidden = YES;
        CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
        [_nameLabel setWidth:nameWidth];
        _menberImageView.hidden = YES;
        _menberBtn.hidden = YES;
    }
}

@end
