//
//  MenberRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/22.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MenberRootVC.h"
#import "V5_Constant.h"
#import "MenberCell.h"
#import "UINavigationController+EdulineStatusBar.h"
#import "Net_Path.h"
#import "UserModel.h"
#import "OrderSureViewController.h"
#import "MenberRecordVC.h"

@interface MenberRootVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate> {
    NSIndexPath *currentIndexpath;
}

@property (strong, nonatomic) UITextField *cardNumT;

@property (strong, nonatomic) UIImageView *topBackView;

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *levelImageView;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UIView *otherTypeBackView;

@property (strong, nonatomic) UIView *menberTypeBackView;
@property (strong, nonatomic) NSMutableArray *memberTypeArray;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *sureImageView;
@property (strong, nonatomic) UIButton *sureButton;

@property (strong, nonatomic) NSMutableArray *otherTypeArray;


@end

@implementation MenberRootVC

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = HEXCOLOR(0x20233C);
    currentIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    _otherTypeArray = [NSMutableArray new];
    _memberTypeArray = [NSMutableArray new];
    [_otherTypeArray addObjectsFromArray:@[@{@"title":@"免费课程",@"image":@"vip_icon1",@"type":@"course"},@{@"title":@"付费课程",@"image":@"vip_icon_course",@"type":@"menberCourse"},@{@"title":@"权益说明",@"image":@"vip_icon3",@"type":@"menberIntro"}]];
    
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"兑换" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    _rightButton.hidden = NO;
    
    _lineTL.hidden = YES;
    _titleLabel.text = @"会员中心";
    _titleImage.backgroundColor = HEXCOLOR(0x20233C);
    _titleLabel.textColor = [UIColor whiteColor];
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    [self makeSearchText];
    [self makeSubView];
    [self getMemBerInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSearchText {
    _cardNumT = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _titleLabel.width, 36)];
    _cardNumT.backgroundColor = HEXCOLOR(0x4d4e64);
    _cardNumT.layer.masksToBounds = YES;
    _cardNumT.layer.cornerRadius = 18;
    _cardNumT.font = SYSTEMFONT(14);
    _cardNumT.textColor = [UIColor whiteColor];
    _cardNumT.returnKeyType = UIReturnKeyDone;
    _cardNumT.textAlignment = NSTextAlignmentLeft;
    _cardNumT.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"会员卡兑换码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:HEXCOLOR(0xC2C2C2)}];
    _cardNumT.delegate = self;
    _cardNumT.center = _titleLabel.center;
    [_titleImage addSubview:_cardNumT];
    
    UIView *leftMode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 36)];
    leftMode.backgroundColor = HEXCOLOR(0x4d4e64);
    _cardNumT.leftView = leftMode;
    _cardNumT.leftViewMode = UITextFieldViewModeAlways;
}

- (void)makeSubView {
    _topBackView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MACRO_UI_UPHEIGHT + 15, MainScreenWidth - 30, 110)];
    _topBackView.image = Image(@"vip_card_top");
    [self.view addSubview:_topBackView];
    
    _userFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 64, 64)];
    _userFace.centerY = _topBackView.height / 2.0;
    _userFace.layer.masksToBounds = YES;
    _userFace.layer.cornerRadius = 32;
    _userFace.layer.borderColor = HEXCOLOR(0xE5B072).CGColor;
    _userFace.layer.borderWidth = 1.0;
    _userFace.clipsToBounds = YES;
    _userFace.contentMode = UIViewContentModeScaleAspectFill;
    _userFace.image = DefaultUserImage;
    if ([UserModel avatar]) {
        [_userFace sd_setImageWithURL:EdulineUrlString([UserModel avatar]) placeholderImage:DefaultUserImage];
    }
    [_topBackView addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 15, _userFace.top, 150, _userFace.height / 2.0)];
    _nameLabel.textColor = HEXCOLOR(0x946A38);
    _nameLabel.font = SYSTEMFONT(17);
    _nameLabel.text = [NSString stringWithFormat:@"%@",[UserModel uname]];
    _nameLabel.userInteractionEnabled = YES;
    [_topBackView addSubview:_nameLabel];
    CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
    [_nameLabel setWidth:nameWidth];
    
    _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.right, 0, 15, 13)];
    _levelImageView.image = Image(@"vip_icon");
    _levelImageView.centerY = _nameLabel.centerY;
    if ([[UserModel vipStatus] isEqualToString:@"1"]) {
        _levelImageView.hidden = NO;
    } else {
        _levelImageView.hidden = YES;
    }
    [_topBackView addSubview:_levelImageView];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, MainScreenWidth - _nameLabel.width - 30, _nameLabel.height)];
    _introLabel.textColor = HEXCOLOR(0x946A38);
    _introLabel.font = SYSTEMFONT(13);
    _introLabel.text = @"开通会员获得更多权益";
    [_topBackView addSubview:_introLabel];
    
    _otherTypeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _topBackView.bottom, MainScreenWidth, 80)];
    _otherTypeBackView.backgroundColor = HEXCOLOR(0x20233C);
    [self.view addSubview:_otherTypeBackView];
    
    CGFloat ww = MainScreenWidth / _otherTypeArray.count;
    
    for (int i = 0; i < _otherTypeArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(ww * i, 0, ww, 80);
        NSString *imageName = [_otherTypeArray[i] objectForKey:@"image"];
        [btn setImage:Image(imageName) forState:0];
        [btn setTitle:[_otherTypeArray[i] objectForKey:@"title"] forState:0];
        btn.titleLabel.font = SYSTEMFONT(14);
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = btn.titleLabel.frame.size.width;
            labelHeight = btn.titleLabel.frame.size.height;
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-10/2.0, 0, 0, -labelWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-10/2.0, 0);
        [btn addTarget:self action:@selector(otherTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherTypeBackView addSubview:btn];
    }
    
    _menberTypeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _otherTypeBackView.bottom, MainScreenWidth, MainScreenHeight - _otherTypeBackView.bottom - 52 - MACRO_UI_SAFEAREA)];
    _menberTypeBackView.backgroundColor = [UIColor whiteColor];
    UIBezierPath * path1 = [UIBezierPath bezierPathWithRoundedRect:_menberTypeBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(25, 25)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _menberTypeBackView.bounds;
    maskLayer1.path = path1.CGPath;
    _menberTypeBackView.layer.mask = maskLayer1;
    [self.view addSubview:_menberTypeBackView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 22)];
    tipLabel.text = @"选择开通类型";
    tipLabel.font = SYSTEMFONT(16);
    tipLabel.textColor = EdlineV5_Color.textFirstColor;
    [_menberTypeBackView addSubview:tipLabel];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 60, 20, 60, 22)];
    recordLabel.text = @"充值记录";
    recordLabel.font = SYSTEMFONT(14);
    recordLabel.textColor = EdlineV5_Color.textSecendColor;
    [_menberTypeBackView addSubview:recordLabel];
    
    UIImageView *recordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(recordLabel.left - 3 - 16, 0, 16, 14)];
    recordIcon.centerY = recordLabel.centerY;
    recordIcon.image = Image(@"vipcenter_record_icon");
    recordIcon.clipsToBounds = YES;
    recordIcon.contentMode = UIViewContentModeScaleAspectFill;
    [_menberTypeBackView addSubview:recordIcon];
    
    UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(recordIcon.left - 3 - 16, recordLabel.top, recordLabel.right - recordIcon.left, 22)];
    recordBtn.backgroundColor = [UIColor clearColor];
    [recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_menberTypeBackView addSubview:recordBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tipLabel.bottom + 6, _menberTypeBackView.width, _menberTypeBackView.height - (tipLabel.bottom + 6))];//[[UIScrollView alloc] initWithFrame:CGRectMake(0, tipLabel.bottom + 6, _menberTypeBackView.width, _menberTypeBackView.height - (tipLabel.bottom + 6))];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_menberTypeBackView addSubview:_tableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 52 - MACRO_UI_SAFEAREA, MainScreenWidth, 52 + MACRO_UI_SAFEAREA)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _sureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 352, 52)];
    _sureImageView.image = Image(@"vip_tab_button");
    _sureImageView.centerX = MainScreenWidth / 2.0;
    [_bottomView addSubview:_sureImageView];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(0, 0, 340, 40);
    [_sureButton setTitle:@"去支付" forState:0];
    [_sureButton setTitleColor:HEXCOLOR(0x946A38) forState:0];
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 20;
    _sureButton.center = _sureImageView.center;
    [_sureButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureButton];
    
}

- (void)textfieldDidChanged:(NSNotification *)notice {
    UITextField *textfield = (UITextField *)notice.object;
    if (textfield.text.length>0) {
        _rightButton.enabled = YES;
    } else {
        _rightButton.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_cardNumT resignFirstResponder];
        return NO;
    } else {
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-zA-Z0-9]*"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        BOOL isOk = [predicate evaluateWithObject:string];
        if (!isOk) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _memberTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"MenberCell";
    MenberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MenberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setMemberInfo:_memberTypeArray[indexPath.row] indexpath:indexPath currentIndexpath:currentIndexpath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndexpath = indexPath;
    [_tableView reloadData];
}

- (void)otherTypeButtonClick:(UIButton *)sender {
    
}

- (void)recordBtnClick {
    MenberRecordVC *vc = [[MenberRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 提交按钮点击事件
- (void)submitButtonClick:(UIButton *)sender {
    if (SWNOTEmptyArr(_memberTypeArray)) {
        NSString *vip_id = [NSString stringWithFormat:@"%@",[_memberTypeArray[currentIndexpath.row] objectForKey:@"id"]];
        [Net_API requestPOSTWithURLStr:[Net_Path userMemberInfo] WithAuthorization:nil paramDic:@{@"vip_id":vip_id,@"from":@"ios"} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    OrderSureViewController *vc = [[OrderSureViewController alloc] init];
                    vc.orderSureInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)rightButtonClick:(id)sender {
    [_cardNumT resignFirstResponder];
    if (!SWNOTEmptyStr(_cardNumT.text)) {
        [self showAlertWithTitle:nil msg:@"请输入会员卡兑换码" handler:nil];
        return;
    }
//    [Net_API requestPOSTWithURLStr:[Net_Path couponExchange] WithAuthorization:nil paramDic:@{@"code":_cardNumT.text} finish:^(id  _Nonnull responseObject) {
//        if (SWNOTEmptyDictionary(responseObject)) {
//            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
//            if ([[responseObject objectForKey:@"code"] integerValue]) {
//                _cardNumT.text = @"";
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCouponList" object:nil];
//            } else {
//
//            }
//        }
//    } enError:^(NSError * _Nonnull error) {
//
//    }];
}

- (void)getMemBerInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userMemberInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                
                NSString *vipStatus = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"vip_status"]];
                if ([vipStatus isEqualToString:@"1"]) {
                    NSString *expierTime = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"expire_time"]];
                    _levelImageView.hidden = NO;
                    _levelImageView.image = Image(@"vip_icon");
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:expierTime.integerValue];
                    NSString *theDay = [dateFormatter stringFromDate:nowDate];//日期的年月日
                    _introLabel.text = [NSString stringWithFormat:@"会员有效期至 %@",theDay];
                } else if ([vipStatus isEqualToString:@"2"]) {
                    _levelImageView.hidden = NO;
                    _levelImageView.image = Image(@"vip_grey_icon");
                } else {
                    _levelImageView.hidden = YES;
                }
                
                [_memberTypeArray removeAllObjects];
                [_memberTypeArray addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"vip"]];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
