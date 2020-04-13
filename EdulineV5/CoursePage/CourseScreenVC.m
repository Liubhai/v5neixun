//
//  CourseScreenVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseScreenVC.h"
#import "V5_Constant.h"

@interface CourseScreenVC ()<UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIView *screenBackView;

@property (strong, nonatomic) UIView *priceBackView;
@property (strong, nonatomic) UIButton *lowBtn;
@property (strong, nonatomic) UIButton *highBtn;
@property (strong, nonatomic) UITextField *lowPriceTextField;
@property (strong, nonatomic) UITextField *highPriceTextField;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UIButton *sureBtn;

@end

@implementation CourseScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _titleImage.hidden = YES;
    [self makeSubViews];
    [self makeBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChangedValue:) name:UITextFieldTextDidChangeNotification object:nil];
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
    
    _priceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainScrollView.height - (77 + 32 + 60), MainScreenWidth, 77 + 32 + 60)];
    _priceBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_priceBackView];
    
    UILabel *themeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    themeTitle.text = @"价格";
    themeTitle.font = SYSTEMFONT(14);
    themeTitle.textColor = EdlineV5_Color.textThirdColor;
    [_priceBackView addSubview:themeTitle];
    
    _lowBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, themeTitle.bottom, 90, 32)];
    [_lowBtn setTitle:@"价格降序" forState:0];
    [_lowBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [_lowBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    _lowBtn.titleLabel.font = SYSTEMFONT(14);
    _lowBtn.backgroundColor = EdlineV5_Color.backColor;
    _lowBtn.layer.masksToBounds = YES;
    _lowBtn.layer.cornerRadius = _lowBtn.height / 2.0;
    [_lowBtn addTarget:self action:@selector(upAndDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_priceBackView addSubview:_lowBtn];
    
    _highBtn = [[UIButton alloc] initWithFrame:CGRectMake(_lowBtn.right + 15, themeTitle.bottom, 90, 32)];
    [_highBtn setTitle:@"价格升序" forState:0];
    [_highBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [_highBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    _highBtn.titleLabel.font = SYSTEMFONT(14);
    _highBtn.backgroundColor = EdlineV5_Color.backColor;
    _highBtn.layer.masksToBounds = YES;
    _highBtn.layer.cornerRadius = _highBtn.height / 2.0;
    [_highBtn addTarget:self action:@selector(upAndDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_priceBackView addSubview:_highBtn];
    
    _lowPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, _lowBtn.bottom + 12, 115, 32)];
    _lowPriceTextField.font = SYSTEMFONT(14);
    _lowPriceTextField.textAlignment = NSTextAlignmentCenter;
    _lowPriceTextField.textColor = EdlineV5_Color.textSecendColor;
    _lowPriceTextField.layer.masksToBounds = YES;
    _lowPriceTextField.layer.cornerRadius = _lowPriceTextField.height / 2.0;
    _lowPriceTextField.layer.borderColor = EdlineV5_Color.starNoColor.CGColor;
    _lowPriceTextField.layer.borderWidth = 0.5;
    _lowPriceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最低价格" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _lowPriceTextField.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeNumberPad;
    _lowPriceTextField.returnKeyType = UIReturnKeyDone;
    _lowPriceTextField.delegate = self;
    [_priceBackView addSubview:_lowPriceTextField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_lowPriceTextField.right + 4, 0, 15, 1)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    line.centerY = _lowPriceTextField.centerY;
    [_priceBackView addSubview:line];
    
    _highPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(line.right + 4, _lowBtn.bottom + 12, 115, 32)];
    _highPriceTextField.font = SYSTEMFONT(14);
    _highPriceTextField.textAlignment = NSTextAlignmentCenter;
    _highPriceTextField.textColor = EdlineV5_Color.textSecendColor;
    _highPriceTextField.layer.masksToBounds = YES;
    _highPriceTextField.layer.cornerRadius = _highPriceTextField.height / 2.0;
    _highPriceTextField.layer.borderColor = EdlineV5_Color.starNoColor.CGColor;
    _highPriceTextField.layer.borderWidth = 0.5;
    _highPriceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最高价格" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _highPriceTextField.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeNumberPad;
    _highPriceTextField.returnKeyType = UIReturnKeyDone;
    _highPriceTextField.delegate = self;
    [_priceBackView addSubview:_highPriceTextField];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textfieldDidChangedValue:(NSNotification *)notice {
    UITextField *textF = (UITextField *)notice.object;
    if (textF.text.length>0) {
        if ([textF.text containsString:@"¥"]) {
            textF.text = [textF.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            textF.text = [NSString stringWithFormat:@"¥%@",textF.text];
        } else {
            textF.text = [NSString stringWithFormat:@"¥%@",textF.text];
        }
    }
}

- (void)upAndDownButtonClick:(UIButton *)sender {
    if (sender == _lowBtn) {
        _lowBtn.selected = YES;
        _highBtn.selected = NO;
        _upAndDown = @"down";
    } else {
        _lowBtn.selected = NO;
        _highBtn.selected = YES;
        _upAndDown = @"up";
    }
    if (_lowBtn.selected) {
        _lowBtn.layer.backgroundColor = [UIColor colorWithRed:44/255.0 green:146/255.0 blue:248/255.0 alpha:0.05].CGColor;
    } else {
        _lowBtn.layer.backgroundColor = EdlineV5_Color.backColor.CGColor;
    }
    
    if (_highBtn.selected) {
        _highBtn.layer.backgroundColor = [UIColor colorWithRed:44/255.0 green:146/255.0 blue:248/255.0 alpha:0.05].CGColor;
    } else {
        _highBtn.layer.backgroundColor = EdlineV5_Color.backColor.CGColor;
    }
}

- (void)cleanButtonClick:(UIButton *)sender {
    _screenId = @"";
    _upAndDown = @"";
    _priceMax = @"";
    _priceMin = @"";
    [self makeSubViews];
}

- (void)sureButtonClicked:(UIButton *)sender {
    _priceMin = [NSString stringWithFormat:@"%@",_lowPriceTextField.text];
    _priceMax = [NSString stringWithFormat:@"%@",_highPriceTextField.text];
    if (_delegate && [_delegate respondsToSelector:@selector(cleanChooseScreen:)]) {
        [_delegate sureChooseScreen:@{@"screenId":(SWNOTEmptyStr(_screenId) ? _screenId : @""),@"screenUpAndDown":(SWNOTEmptyStr(_upAndDown) ? _upAndDown : @""),@"priceMin":(SWNOTEmptyStr(_priceMin) ? _priceMin : @""),@"priceMax":(SWNOTEmptyStr(_priceMax) ? _priceMax : @"")}];
    }
}

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
