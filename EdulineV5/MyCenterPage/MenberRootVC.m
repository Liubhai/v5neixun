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

@interface MenberRootVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSIndexPath *currentIndexpath;
}

@property (strong, nonatomic) UIImageView *topBackView;

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0x20233C);
    currentIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    _otherTypeArray = [NSMutableArray new];
    _memberTypeArray = [NSMutableArray new];
    [_otherTypeArray addObjectsFromArray:@[@{@"title":@"免费课程",@"image":@"vip_icon1",@"type":@"course"},@{@"title":@"会员专区",@"image":@"vip_icon2",@"type":@"menber"},@{@"title":@"会员专区",@"image":@"vip_icon2",@"type":@"menber"},@{@"title":@"尊贵标识",@"image":@"vip_icon3",@"type":@"menber"}]];
    _lineTL.hidden = YES;
    _titleLabel.text = @"会员中心";
    _titleImage.backgroundColor = HEXCOLOR(0x20233C);
    _titleLabel.textColor = [UIColor whiteColor];
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    [self makeSubView];
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
    [_topBackView addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 15, _userFace.top, 150, _userFace.height / 2.0)];
    _nameLabel.textColor = HEXCOLOR(0x946A38);
    _nameLabel.font = SYSTEMFONT(17);
    _nameLabel.text = @"9527";
    _nameLabel.userInteractionEnabled = YES;
    [_topBackView addSubview:_nameLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
    _introLabel.textColor = HEXCOLOR(0x946A38);
    _introLabel.font = SYSTEMFONT(13);
    _introLabel.text = @"VIP5";
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
    [_bottomView addSubview:_sureButton];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"MenberCell";
    MenberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MenberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setMemberInfo:nil indexpath:indexPath currentIndexpath:currentIndexpath];
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

@end
