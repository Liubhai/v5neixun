//
//  MycouponsRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MycouponsRootVC.h"
#import "MycouponsListVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface MycouponsRootVC ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *needDealButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) UITextField *cardNumT;

@property (strong, nonatomic) UIScrollView *mainScrollView;
@end

@implementation MycouponsRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"兑换" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    _rightButton.hidden = NO;
    _typeArray = [NSMutableArray new];
    [_typeArray addObjectsFromArray:@[@{@"title":@"可使用",@"type":@"usable"},@{@"title":@"已使用",@"type":@"unusable"},@{@"title":@"已过期",@"type":@"expired"}]];
    
    [self makeSearchText];
    
    [self makeTopView];
    [self makeScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSearchText {
    _cardNumT = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _titleLabel.width, 36)];
    _cardNumT.backgroundColor = EdlineV5_Color.backColor;
    _cardNumT.layer.masksToBounds = YES;
    _cardNumT.layer.cornerRadius = 18;
    _cardNumT.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
    _cardNumT.layer.borderWidth = 1;
    _cardNumT.font = SYSTEMFONT(14);
    _cardNumT.textColor = EdlineV5_Color.textThirdColor;
    _cardNumT.returnKeyType = UIReturnKeyDone;
    _cardNumT.textAlignment = NSTextAlignmentLeft;
    _cardNumT.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"实体卡兑换码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _cardNumT.delegate = self;
    _cardNumT.center = _titleLabel.center;
    [_titleImage addSubview:_cardNumT];
    
    UIView *leftMode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 36)];
    leftMode.backgroundColor = EdlineV5_Color.backColor;
    _cardNumT.leftView = leftMode;
    _cardNumT.leftViewMode = UITextFieldViewModeAlways;
}

- (void)makeTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 - 2, 20, 2)];
    _lineView.backgroundColor = EdlineV5_Color.baseColor;
    [_topView addSubview:_lineView];
    CGFloat WW = MainScreenWidth / _typeArray.count;
    for (int i = 0; i<_typeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*WW, 0, WW, _topView.height)];
        [btn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        [btn setTitleColor:EdlineV5_Color.baseColor forState:UIControlStateSelected];
        btn.titleLabel.font = SYSTEMFONT(14);
        btn.tag = i;
        [btn setTitle:[_typeArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            _lineView.centerX = btn.centerX;
            _needDealButton = btn;
        } else if (i == 1) {
            _cancelButton = btn;
        } else if (i == 2) {
            _finishButton = btn;
        }
        [_topView addSubview:btn];
    }
    [_topView bringSubviewToFront:_lineView];
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_topView.bottom, MainScreenWidth, MainScreenHeight - _topView.bottom)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth*_typeArray.count, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0; i<_typeArray.count; i++) {
        MycouponsListVC *vc = [[MycouponsListVC alloc] init];
        vc.couponType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            self.lineView.centerX = self.needDealButton.centerX;
            self.needDealButton.selected = YES;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.lineView.centerX = self.finishButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = YES;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.lineView.centerX = self.cancelButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = YES;
            self.finishButton.selected = NO;
        }
    }
}

- (void)topButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * sender.tag, 0) animated:YES];
}

- (void)rightButtonClick:(id)sender {
    [_cardNumT resignFirstResponder];
    if (!SWNOTEmptyStr(_cardNumT.text)) {
        [self showAlertWithTitle:nil msg:@"请输入兑换码" handler:nil];
        return;
    }
    [Net_API requestPOSTWithURLStr:[Net_Path couponExchange] WithAuthorization:nil paramDic:@{@"code":_cardNumT.text} finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _cardNumT.text = @"";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCouponList" object:nil];
            } else {
                
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
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
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
