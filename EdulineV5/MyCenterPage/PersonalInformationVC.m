//
//  PersonalInformationVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "PersonalInformationVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface PersonalInformationVC ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UILabel *faceTitle;
@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UILabel *nameTitle;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIView *line2;
@property (strong, nonatomic) UILabel *sexTitle;
@property (strong, nonatomic) UIButton *maleBtn;
@property (strong, nonatomic) UIButton *feMaleBtn;
@property (strong, nonatomic) UIView *line3;
@property (strong, nonatomic) UILabel *introTitle;
@property (strong, nonatomic) UITextView *introTextView;
@property (strong, nonatomic) UILabel *introTextViewPlaceholder;

@end

@implementation PersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    _titleLabel.text = @"个人信息";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"保存" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    _rightButton.hidden = NO;
    [self makeSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 0)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    _faceTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 92)];
    _faceTitle.text = @"更换头像";
    _faceTitle.font = SYSTEMFONT(15);
    _faceTitle.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_faceTitle];
    
    _userFace = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 50, 0, 50, 50)];
    _userFace.centerY = _faceTitle.centerY;
    _userFace.layer.masksToBounds = YES;
    _userFace.layer.cornerRadius = 25;
    _userFace.image = Image(@"pre_touxaing");
    [_mainScrollView addSubview:_userFace];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _faceTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line1];
    
    _nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line1.bottom, _faceTitle.width, 50)];
    _nameTitle.text = @"昵称修改";
    _nameTitle.textColor = EdlineV5_Color.textFirstColor;
    _nameTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_nameTitle];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _nameTitle.top, 200, 50)];
    _nameTextField.textColor = EdlineV5_Color.textSecendColor;
    _nameTextField.font = SYSTEMFONT(15);
    _nameTextField.textAlignment = NSTextAlignmentRight;
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _nameTextField.delegate = self;
    [_mainScrollView addSubview:_nameTextField];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _nameTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line2];
    
    _sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line2.bottom, _faceTitle.width, 50)];
    _sexTitle.text = @"性别";
    _sexTitle.textColor = EdlineV5_Color.textFirstColor;
    _sexTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_sexTitle];
    
    _feMaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _feMaleBtn.frame = CGRectMake(MainScreenWidth - 15 - 47, _sexTitle.top, 47, 50);
    _feMaleBtn.titleLabel.font = SYSTEMFONT(15);
    [_feMaleBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [_feMaleBtn setImage:Image(@"sexcheckbox_nor") forState:0];
    [_feMaleBtn setImage:Image(@"sexcheckbox_pre") forState:UIControlStateSelected];
    [_feMaleBtn setTitle:@"女" forState:0];
    _feMaleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -12/2.0, 0, 12/2.0);
    _feMaleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12/2.0, 0, -12/2.0);
    [_feMaleBtn addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_feMaleBtn];

    _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _maleBtn.frame = CGRectMake(_feMaleBtn.left - 47 - 40, _sexTitle.top, 47, 50);
    _maleBtn.titleLabel.font = SYSTEMFONT(15);
    [_maleBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [_maleBtn setImage:Image(@"sexcheckbox_nor") forState:0];
    [_maleBtn setImage:Image(@"sexcheckbox_pre") forState:UIControlStateSelected];
    [_maleBtn setTitle:@"男" forState:0];
    _maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -12/2.0, 0, 12/2.0);
    _maleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12/2.0, 0, -12/2.0);
    [_maleBtn addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_maleBtn];
    
    _line3 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _sexTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line3.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line3];
    
    _introTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line3.bottom, 100, 28 + 21)];
    _introTitle.text = @"个性签名";
    _introTitle.font = SYSTEMFONT(15);
    _introTitle.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_introTitle];
    
    _introTextView = [[UITextView alloc] initWithFrame:CGRectMake(95, _introTitle.top + 7, MainScreenWidth - 15 - 95, 78)];
    _introTextView.textColor = EdlineV5_Color.textSecendColor;
    _introTextView.font = SYSTEMFONT(15);
    _introTextView.delegate = self;
    [_mainScrollView addSubview:_introTextView];
    
    _introTextViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(_introTextView.left, _introTextView.top + 1, _introTextView.width, 30)];
    _introTextViewPlaceholder.text = @" 个性";
    _introTextViewPlaceholder.textColor = EdlineV5_Color.textThirdColor;
    _introTextViewPlaceholder.font = SYSTEMFONT(15);
    _introTextViewPlaceholder.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_introTextViewPlaceholder addGestureRecognizer:placeTap];
    [_mainScrollView addSubview:_introTextViewPlaceholder];
    
    [_mainScrollView setHeight:_introTextView.bottom + 10];
}

- (void)sexButtonClick:(UIButton *)sender {
    sender.selected = YES;
    if (sender == _feMaleBtn) {
        _maleBtn.selected = NO;
    } else {
        _feMaleBtn.selected = NO;
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _introTextViewPlaceholder.hidden = YES;
    [_introTextView becomeFirstResponder];
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _introTextViewPlaceholder.hidden = NO;
    } else {
        _introTextViewPlaceholder.hidden = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _introTextViewPlaceholder.hidden = YES;
    return YES;
}

// MARK: - 修改用户信息
/**nick_name avatar signature gender*/
- (void)rightButtonClick:(id)sender {
    return;
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_nameTextField.text)) {
        [param setObject:_nameTextField.text forKey:@"nick_name"];
    } else {
        [param setObject:@"" forKey:@"nick_name"];
    }
    
    if (SWNOTEmptyStr(_introTextView.text)) {
        [param setObject:_introTextView.text forKey:@"signature"];
    } else {
        [param setObject:@"" forKey:@"signature"];
    }
    
    
    [Net_API requestPUTWithURLStr:[Net_Path userInfoEdition] paramDic:nil Api_key:nil finish:^(id  _Nonnull responseObject) {
        
    } enError:^(NSError * _Nonnull error) {
        
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
