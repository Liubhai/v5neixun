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
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 77 + 32 + 60)];//340
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    [self makePriceBackView];
    
}

- (void)makePriceBackView {
    _priceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainScrollView.height - (77 + 32 + 60), MainScreenWidth, 77 + 32 + 60)];
    _priceBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_priceBackView];
    
    UILabel *themeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    themeTitle.text = @"价格";
    themeTitle.font = SYSTEMFONT(14);
    themeTitle.textColor = EdlineV5_Color.textThirdColor;
    [_priceBackView addSubview:themeTitle];
    
    UIButton *lowBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, themeTitle.bottom, 90, 32)];
    [lowBtn setTitle:@"价格降序" forState:0];
    [lowBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [lowBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    lowBtn.titleLabel.font = SYSTEMFONT(14);
    lowBtn.backgroundColor = EdlineV5_Color.backColor;
    lowBtn.layer.masksToBounds = YES;
    lowBtn.layer.cornerRadius = lowBtn.height / 2.0;
    [_priceBackView addSubview:lowBtn];
    
    UIButton *highBtn = [[UIButton alloc] initWithFrame:CGRectMake(lowBtn.right + 15, themeTitle.bottom, 90, 32)];
    [highBtn setTitle:@"价格升序" forState:0];
    [highBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [highBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    highBtn.titleLabel.font = SYSTEMFONT(14);
    highBtn.backgroundColor = EdlineV5_Color.backColor;
    highBtn.layer.masksToBounds = YES;
    highBtn.layer.cornerRadius = highBtn.height / 2.0;
    [_priceBackView addSubview:highBtn];
    
    _lowPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, lowBtn.bottom + 12, 115, 32)];
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
    
    _highPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(line.right + 4, lowBtn.bottom + 12, 115, 32)];
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
    [_bottomView addSubview:_clearBtn];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth/2.0, _bottomView.height)];
    [_sureBtn setTitle:@"确定" forState:0];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    _sureBtn.backgroundColor = EdlineV5_Color.themeColor;
    _sureBtn.titleLabel.font = SYSTEMFONT(16);
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

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
