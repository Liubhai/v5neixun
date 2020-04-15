//
//  MyCenterUserInfoView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterUserInfoView.h"
#import "V5_Constant.h"
#import "UserModel.h"

@implementation MyCenterUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 234)];
    _backImageView.image = Image(@"pre_bg");
    [self addSubview:_backImageView];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    [_leftBtn setImage:Image(@"pre_nav_home") forState:0];
    [self addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(MainScreenWidth-52, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 53, 44);
    [_rightBtn setImage:Image(@"pre_nav_mes") forState:0];
    [self addSubview:_rightBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(_rightBtn.left - 44, _rightBtn.top, 44, 44);
    [_setBtn setImage:Image(@"pre_nav_set") forState:0];
    [self addSubview:_setBtn];
    
    _userFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _leftBtn.bottom + 15, 64, 64)];
    _userFaceImageView.layer.masksToBounds = YES;
    _userFaceImageView.layer.cornerRadius = _userFaceImageView.height / 2.0;
    _userFaceImageView.image = DefaultImage;
    _userFaceImageView.userInteractionEnabled = YES;
    _userFaceImageView.image = Image(@"pre_touxaing");
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceTapClick)];
    [_userFaceImageView addGestureRecognizer:faceTap];
    [self addSubview:_userFaceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFaceImageView.right + 15, _userFaceImageView.top, 150, _userFaceImageView.height / 2.0)];
    _nameLabel.textColor = [UIColor whiteColor];;
    _nameLabel.font = SYSTEMFONT(17);
    _nameLabel.text = @"9527";
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceTapClick)];
    [_userFaceImageView addGestureRecognizer:nameTap];
    [self addSubview:_nameLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
    _introLabel.textColor = [UIColor whiteColor];
    _introLabel.font = SYSTEMFONT(13);
    _introLabel.text = @"曾经有无数份真挚的爱情摆在我的面前";
    [self addSubview:_introLabel];
    
    _menberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 86, 0, 86, 32)];
    _menberImageView.image = Image(@"pre_vip_button");
    _menberImageView.centerY = _userFaceImageView.centerY;
    [self addSubview:_menberImageView];
    
    _menberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _menberBtn.frame = CGRectMake(_menberImageView.left, _menberImageView.top, _menberImageView.width, _menberImageView.height);
    _menberBtn.backgroundColor = [UIColor clearColor];
    _menberBtn.titleLabel.font = SYSTEMFONT(14);
    [_menberBtn setTitle:@" 开通会员》" forState:0];
    [_menberBtn setTitleColor:HEXCOLOR(0xA87941) forState:0];
    [self addSubview:_menberBtn];
    
}

- (void)faceTapClick {
    if (_delegate && [_delegate respondsToSelector:@selector(goToUserInfoVC)]) {
        [_delegate goToUserInfoVC];
    }
}

- (void)setUserInfo:(NSDictionary *)info {
    if (SWNOTEmptyStr([UserModel oauthToken])) {
        [_nameLabel setTop:_userFaceImageView.top];
        _introLabel.hidden = NO;
        _nameLabel.text = [NSString stringWithFormat:@"%@",[UserModel uname]];
    } else {
        _userFaceImageView.image = Image(@"pre_touxaing");
        _nameLabel.centerY = _userFaceImageView.centerY;
        _nameLabel.text = @"登录/注册";
    }
}

@end
