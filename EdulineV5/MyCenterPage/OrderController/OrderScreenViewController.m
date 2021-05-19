//
//  OrderScreenViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "OrderScreenViewController.h"
#import "V5_Constant.h"

@interface OrderScreenViewController ()

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIView *screenBackView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UIButton *sureBtn;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation OrderScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    // 【1week、1month、3month、6month、this_year、earlier】
    [_dataSource addObjectsFromArray:@[@{@"title":@"一周内",@"type":@"1week"},@{@"title":@"1个月内",@"type":@"1month"},@{@"title":@"3个月内",@"type":@"3month"},@{@"title":@"6个月内",@"type":@"6month"},@{@"title":@"今年",@"type":@"this_year"},@{@"title":@"更早",@"type":@"earlier"}]];
    [self makeSubViews];
    [self makeBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenOrderScreenTypeVC:) name:@"hiddenOrderScreenAll" object:nil];
}

- (void)makeSubViews {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 77 + 32 + 60)];//340
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mainScrollView];
    }
    
    [self makePriceBackView];
    
}

- (void)makePriceBackView {
    
    [_mainScrollView removeAllSubviews];
    
    UILabel *screenTheme = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    screenTheme.text = @"按时间筛选";
    screenTheme.font = SYSTEMFONT(14);
    screenTheme.textColor = EdlineV5_Color.textThirdColor;
    [_mainScrollView addSubview:screenTheme];
    
    _screenBackView = [[UIView alloc] initWithFrame:CGRectMake(0, screenTheme.bottom, MainScreenWidth, 0)];
    _screenBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_screenBackView];
    [_screenBackView removeAllSubviews];
    
    CGFloat XX = 15.0;
    CGFloat YY = 0.0;
    CGFloat topSpacee = 12.0;
    CGFloat rightSpace = 15.0;
    CGFloat WW = 103.0;
    CGFloat btnInSpace = (MainScreenWidth - WW * 3 - rightSpace * 2) / 2.0;
    CGFloat btnHeight = 32.0;
    for (int i = 0; i<_dataSource.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX + (WW + btnInSpace) * (i%3), YY + (topSpacee + btnHeight) * (i/3), WW, btnHeight)];
        btn.tag = 400 + i;
        [btn addTarget:self action:@selector(screenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:_dataSource[i][@"title"] forState:0];
        btn.titleLabel.font = SYSTEMFONT(14);
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        btn.layer.backgroundColor = EdlineV5_Color.backColor.CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btnHeight / 2.0;
        if ([_screenType isEqualToString:_dataSource[i][@"type"]]) {
            btn.selected = YES;
            const CGFloat *components = [EdulineV5_Tool getColorRGB:EdlineV5_Color.buttonWeakeColor];
            btn.layer.backgroundColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.5].CGColor;
        } else {
            btn.selected = NO;
            btn.layer.backgroundColor = EdlineV5_Color.backColor.CGColor;
        }
        if (i == _dataSource.count - 1) {
            [_screenBackView setHeight:btn.bottom];
        }
        [_screenBackView addSubview:btn];
    }
    [_mainScrollView setHeight:_screenBackView.bottom + 30];
}

- (void)makeBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainScrollView.bottom, MainScreenWidth, 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth/2.0, _bottomView.height)];
    [_clearBtn setTitle:@"清空筛选" forState:0];
    [_clearBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _clearBtn.titleLabel.font = SYSTEMFONT(16);
    [_clearBtn addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_clearBtn];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth/2.0, _bottomView.height)];
    [_sureBtn setTitle:@"确定" forState:0];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    _sureBtn.backgroundColor = EdlineV5_Color.themeColor;
    _sureBtn.titleLabel.font = SYSTEMFONT(16);
    [_sureBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureBtn];
}

- (void)cleanButtonClick:(UIButton *)sender {
    _screenType = @"";
    _screenTitle = @"";
    [self makeSubViews];
}

- (void)sureButtonClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(sureChooseOrderScreen:)]) {
        [_delegate sureChooseOrderScreen:@{@"screenTitle":(SWNOTEmptyStr(_screenTitle) ? _screenTitle : @""),@"screenType":(SWNOTEmptyStr(_screenType) ? _screenType : @"")}];
    }
}

- (void)screenBtnClick:(UIButton *)sender {
    for (UIButton *btn in _screenBackView.subviews) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            const CGFloat *components = [EdulineV5_Tool getColorRGB:EdlineV5_Color.buttonWeakeColor];
            btn.layer.backgroundColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.5].CGColor;
            _screenType = _dataSource[sender.tag - 400][@"type"];
            _screenTitle = _dataSource[sender.tag - 400][@"title"];
        } else {
            btn.selected = NO;
            btn.layer.backgroundColor = EdlineV5_Color.backColor.CGColor;
        }
    }
}

- (void)hiddenOrderScreenTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
