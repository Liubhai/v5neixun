//
//  InstitutionApplyVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionApplyVC.h"
#import "WkWebViewController.h"

@interface InstitutionApplyVC () {
    NSString *whichPic;
    // 附件 id
    NSString *idCardIDFont;
    NSString *idCardIDBack;
    NSString *teacherId;
    NSString *logoId;
    //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
    NSString *verified_status;
    // 机构id
    NSString *schoolID;
    NSInteger currentPickerRow;
    
    BOOL isInstitutionTextField;
}

@property(strong, nonatomic) NSDictionary *teacherApplyInfo;

@property(strong, nonatomic) NSMutableArray *schoolArray;
@property(strong, nonatomic) NSMutableArray *dataSource;

// 机构选择
@property(strong, nonatomic) UIView *pickerLineView;
@property(strong, nonatomic) UIButton *sureButton;
@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIView *whiteBackView;
@property(strong, nonatomic) UIView *pickBackView;
@property(strong, nonatomic) UIPickerView *choosePickerView;

@property(strong, nonatomic) NSMutableArray *imageArray;
@property(strong, nonatomic) NSMutableArray *imageArrayIdCardBack;
@property(strong, nonatomic) NSMutableArray *imageArrayTeacher;
@property (strong, nonatomic) NSMutableArray *logoImageArray;

@property (strong, nonatomic) NSMutableArray *teacherCategoryArray;
@property (strong, nonatomic) NSMutableArray *teacherCategoryIDArray;
@property (strong, nonatomic) NSMutableArray *teacherCategoryTitleArray;

@end

@implementation InstitutionApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"成为机构";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    // Do any additional setup after loading the view.
    
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"上一步" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    
    whichPic = @"";
    idCardIDFont = @"";
    idCardIDBack = @"";
    teacherId = @"";
    logoId = @"";
    verified_status = @"";
    schoolID = @"";
    currentPickerRow = 0;
    _imageArray = [NSMutableArray new];
    _imageArrayIdCardBack = [NSMutableArray new];
    _imageArrayTeacher = [NSMutableArray new];
    _logoImageArray = [NSMutableArray new];
    _schoolArray = [NSMutableArray new];
    
    _teacherCategoryArray = [NSMutableArray new];
    _teacherCategoryIDArray = [NSMutableArray new];
    _teacherCategoryTitleArray = [NSMutableArray new];
    
    [self makeScrollView];
    [self makeSubView];
    [self makeAgreeView];
    [self makeDownView];
//    [self makePickerView];
    [self getUserTeacherApplyInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    _nextScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA)];
    _nextScrollView.backgroundColor = [UIColor whiteColor];
    _nextScrollView.bounces = NO;
    _nextScrollView.delegate = self;
    _nextScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_nextScrollView];
    _nextScrollView.hidden = YES;
}

- (void)makeSubView {
    // 昵称
    _nameLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _nameLeftLabel.text = @"当前用户";
    _nameLeftLabel.font = SYSTEMFONT(15);
    _nameLeftLabel.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_nameLeftLabel];
    
    _nameRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, 0, 200, 50)];
    _nameRightLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameRightLabel.font = SYSTEMFONT(15);
    _nameRightLabel.textAlignment = NSTextAlignmentRight;
    _nameRightLabel.text = [UserModel userPhone];
    [_mainScrollView addSubview:_nameRightLabel];
    
    _willBeManagerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _nameLeftLabel.bottom + 30 - 12 - 18.5, MainScreenWidth - 15, 18.5)];
    _willBeManagerLabel.font = SYSTEMFONT(13);
    _willBeManagerLabel.textAlignment = NSTextAlignmentRight;
    _willBeManagerLabel.text = @"*该帐号将成为机构管理员";
    _willBeManagerLabel.textColor = HEXCOLOR(0xB7BAC1);
    [_mainScrollView addSubview:_willBeManagerLabel];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(15, _nameLeftLabel.bottom + 30, MainScreenWidth - 15, 1)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line1];
    
    // 认证状态
    _statusLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _line1.bottom, 100, 50)];
    _statusLeftLabel.text = @"认证状态";
    _statusLeftLabel.font = SYSTEMFONT(15);
    _statusLeftLabel.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_statusLeftLabel];
    
    _statusRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _line1.bottom, 200, 50)];
    _statusRightLabel.text = @"未认证";
    _statusRightLabel.font = SYSTEMFONT(15);
    _statusRightLabel.textColor = EdlineV5_Color.textThirdColor;
    _statusRightLabel.textAlignment = NSTextAlignmentRight;
    [_mainScrollView addSubview:_statusRightLabel];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(0, _statusLeftLabel.bottom, MainScreenWidth, 5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line2];
    
    // 所属机构
    _institutionLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _line2.bottom, 100, 50)];
    _institutionLeftLabel.text = @"所属机构";
    _institutionLeftLabel.font = SYSTEMFONT(15);
    _institutionLeftLabel.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_institutionLeftLabel];
    
    _institutionTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _line2.bottom, 200, 50)];
    _institutionTextField.returnKeyType = UIReturnKeyDone;
    _institutionTextField.delegate = self;
    _institutionTextField.textColor = EdlineV5_Color.textSecendColor;
    _institutionTextField.font = SYSTEMFONT(15);
    _institutionTextField.textAlignment = NSTextAlignmentRight;
    _institutionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写机构名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    [_mainScrollView addSubview:_institutionTextField];
    
    _line3 = [[UIView alloc] initWithFrame:CGRectMake(15, _institutionLeftLabel.bottom, MainScreenWidth - 15, 1)];
    _line3.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line3];
    
    // 所属行业
    _industryLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _line3.bottom, 100, 50)];
    _industryLeftLabel.text = @"所属行业";
    _industryLeftLabel.font = SYSTEMFONT(15);
    _industryLeftLabel.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_industryLeftLabel];
    
    _industryRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30 - 200, _line3.bottom, 200, 50)];
    _industryRightLabel.text = @"请选择所属行业";
    _industryRightLabel.font = SYSTEMFONT(15);
    _industryRightLabel.textColor = EdlineV5_Color.textThirdColor;
    _industryRightLabel.textAlignment = NSTextAlignmentRight;
    [_mainScrollView addSubview:_industryRightLabel];
    
    _industryIcon = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, _line3.bottom, 30, 50)];
    [_industryIcon setImage:Image(@"list_more") forState:0];
    [_industryIcon addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_industryIcon];
    
    _industryBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _industryRightLabel.bottom, MainScreenWidth - 30, 0)];
    _industryBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_industryBackView];
    
    _nextBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _industryBackView.bottom, MainScreenWidth, 1)];
    _nextBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_nextBackView];
    
    _nextLine4 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 15, 1)];
    _nextLine4.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_nextBackView addSubview:_nextLine4];
    
    _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _nextLine4.bottom, 100, 82)];
    _logoLabel.font = SYSTEMFONT(15);
    _logoLabel.text = @"LOGO";
    _logoLabel.textColor = EdlineV5_Color.textFirstColor;
    [_nextBackView addSubview:_logoLabel];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 50, 0, 50, 50)];
    _logoImageView.clipsToBounds = YES;
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = _logoImageView.height / 2.0;
    _logoImageView.image = DefaultImage;
    _logoImageView.centerY = _logoLabel.centerY;
    _logoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserFaceTap:)];
    [_logoImageView addGestureRecognizer:logoTap];
    [_nextBackView addSubview:_logoImageView];
    
    _nextLine5 = [[UIView alloc] initWithFrame:CGRectMake(15, _logoLabel.bottom, MainScreenWidth - 15, 1)];
    _nextLine5.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_nextBackView addSubview:_nextLine5];
    
    _institutionInroLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _nextLine5.bottom, 100, 28 + 21)];
    _institutionInroLabel.text = @"机构简介";
    _institutionInroLabel.font = SYSTEMFONT(15);
    _institutionInroLabel.textColor = EdlineV5_Color.textFirstColor;
    [_nextBackView addSubview:_institutionInroLabel];
    
    _institutionInroTextView = [[UITextView alloc] initWithFrame:CGRectMake(95, _institutionInroLabel.top + 7, MainScreenWidth - 15 - 95, 78)];
    _institutionInroTextView.textColor = EdlineV5_Color.textSecendColor;
    _institutionInroTextView.font = SYSTEMFONT(15);
    _institutionInroTextView.delegate = self;
    _institutionInroTextView.returnKeyType = UIReturnKeyDone;
    [_nextBackView addSubview:_institutionInroTextView];
    
    _institutionInroPlace = [[UILabel alloc] initWithFrame:CGRectMake(_institutionInroTextView.left, _institutionInroTextView.top + 1, _institutionInroTextView.width, 30)];
    _institutionInroPlace.text = @" 请填写机构简介";
    _institutionInroPlace.textColor = EdlineV5_Color.textThirdColor;
    _institutionInroPlace.font = SYSTEMFONT(15);
    _institutionInroPlace.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_institutionInroPlace addGestureRecognizer:placeTap];
    [_nextBackView addSubview:_institutionInroPlace];
    
    _nextLine6 = [[UIView alloc] initWithFrame:CGRectMake(15, _institutionInroTextView.bottom + 20, MainScreenWidth - 15, 1)];
    _nextLine6.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_nextBackView addSubview:_nextLine6];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _nextLine6.bottom, 100, 50)];
    _phoneLabel.text = @"联系电话";
    _phoneLabel.font = SYSTEMFONT(15);
    _phoneLabel.textColor = EdlineV5_Color.textFirstColor;
    [_nextBackView addSubview:_phoneLabel];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _nextLine6.bottom, 200, 50)];
    _phoneTextField.returnKeyType = UIReturnKeyDone;
    _phoneTextField.delegate = self;
    _phoneTextField.textColor = EdlineV5_Color.textSecendColor;
    _phoneTextField.font = SYSTEMFONT(15);
    _phoneTextField.textAlignment = NSTextAlignmentRight;
    _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写联系电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    [_nextBackView addSubview:_phoneTextField];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneLabel.bottom, MainScreenWidth, 76)];
    _bottomView.backgroundColor = EdlineV5_Color.backColor;
    [_nextBackView addSubview:_bottomView];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 28, MainScreenWidth - 30, 40)];
    [_nextButton setTitle:@"下一步" forState:0];
    _nextButton.titleLabel.font = SYSTEMFONT(16);
    _nextButton.backgroundColor = EdlineV5_Color.themeColor;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 5;
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_nextButton];
    
    [_nextBackView setHeight:_bottomView.bottom];
    if (_nextBackView.bottom < _mainScrollView.height) {
        [_bottomView setHeight:76 + (_mainScrollView.height - _nextBackView.bottom)];
        [_nextBackView setHeight:_bottomView.bottom];
    }
    _mainScrollView.contentSize = CGSizeMake(0, _nextBackView.bottom);
    
    // 下一页 下一页 下一页 下一页
    _otherBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    _otherBackView.backgroundColor = [UIColor whiteColor];
    [_nextScrollView addSubview:_otherBackView];
    
    // 联系地址
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 28 + 21)];
    _addressLabel.text = @"联系地址";
    _addressLabel.font = SYSTEMFONT(15);
    _addressLabel.textColor = EdlineV5_Color.textFirstColor;
    [_otherBackView addSubview:_addressLabel];
    
    _addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(95, _addressLabel.top + 7, MainScreenWidth - 15 - 95, 78)];
    _addressTextView.textColor = EdlineV5_Color.textSecendColor;
    _addressTextView.font = SYSTEMFONT(15);
    _addressTextView.delegate = self;
    _addressTextView.returnKeyType = UIReturnKeyDone;
    [_otherBackView addSubview:_addressTextView];
    
    _addressPlace = [[UILabel alloc] initWithFrame:CGRectMake(_addressTextView.left, _addressTextView.top + 1, _addressTextView.width, 30)];
    _addressPlace.text = @" 请填写联系地址";
    _addressPlace.textColor = EdlineV5_Color.textThirdColor;
    _addressPlace.font = SYSTEMFONT(15);
    _addressPlace.userInteractionEnabled = YES;
    UITapGestureRecognizer *addressPlaceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressPlaceLabelTap:)];
    [_addressPlace addGestureRecognizer:addressPlaceTap];
    [_otherBackView addSubview:_addressPlace];
    
    // 身份证号
    _line4 = [[UIView alloc] initWithFrame:CGRectMake(15, _addressTextView.bottom + 20, MainScreenWidth - 15, 1)];
    _line4.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_otherBackView addSubview:_line4];
    
    _idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _line4.bottom, 100, 50)];
    _idCardLabel.text = @"身份证号";
    _idCardLabel.font = SYSTEMFONT(15);
    _idCardLabel.textColor = EdlineV5_Color.textFirstColor;
    [_otherBackView addSubview:_idCardLabel];
    
    _idCardText = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _line4.bottom, 200, 50)];
    _idCardText.returnKeyType = UIReturnKeyDone;
    _idCardText.delegate = self;
    _idCardText.textColor = EdlineV5_Color.textSecendColor;
    _idCardText.font = SYSTEMFONT(15);
    _idCardText.textAlignment = NSTextAlignmentRight;
    _idCardText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    [_otherBackView addSubview:_idCardText];
    
    _line5 = [[UIView alloc] initWithFrame:CGRectMake(15, _idCardLabel.bottom, MainScreenWidth - 15, 1)];
    _line5.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_otherBackView addSubview:_line5];
    
    // 身份证证件正反面
    _idCardPictureTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, _line5.bottom, 100, 50)];
    _idCardPictureTitle.text = @"身份证正反面";
    _idCardPictureTitle.font = SYSTEMFONT(15);
    _idCardPictureTitle.textColor = EdlineV5_Color.textFirstColor;
    [_otherBackView addSubview:_idCardPictureTitle];
    
    _idCardPictureTip = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _line5.bottom, 200, 50)];
    _idCardPictureTip.text = @"图片最大不超过xxM";
    _idCardPictureTip.font = SYSTEMFONT(15);
    _idCardPictureTip.textColor = EdlineV5_Color.textThirdColor;
    _idCardPictureTip.textAlignment = NSTextAlignmentRight;
    _idCardPictureTip.hidden = YES;
    [_otherBackView addSubview:_idCardPictureTip];
    
    _idCardPictureLeft = [[UIImageView alloc] initWithFrame:CGRectMake(15, _idCardPictureTitle.bottom, 169, 107)];
    _idCardPictureLeft.image = Image(@"id_front");
    _idCardPictureLeft.clipsToBounds = YES;
    _idCardPictureLeft.contentMode = UIViewContentModeScaleAspectFill;
    _idCardPictureLeft.userInteractionEnabled = YES;
    UITapGestureRecognizer *idLefttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserFaceTap:)];
    [_idCardPictureLeft addGestureRecognizer:idLefttap];
    [_otherBackView addSubview:_idCardPictureLeft];
    
    _idCardPictureRight = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 169, _idCardPictureTitle.bottom, 169, 107)];
    _idCardPictureRight.image = Image(@"id_back_def");
    _idCardPictureRight.clipsToBounds = YES;
    _idCardPictureRight.contentMode = UIViewContentModeScaleAspectFill;
    _idCardPictureRight.userInteractionEnabled = YES;
    UITapGestureRecognizer *idRighttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserFaceTap:)];
    [_idCardPictureRight addGestureRecognizer:idRighttap];
    [_otherBackView addSubview:_idCardPictureRight];
    
    // 身份证证件正反面
    _teacherPictureTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, _idCardPictureLeft.bottom, 100, 50)];
    _teacherPictureTitle.text = @"教师资格证";
    _teacherPictureTitle.font = SYSTEMFONT(15);
    _teacherPictureTitle.textColor = EdlineV5_Color.textFirstColor;
    [_otherBackView addSubview:_teacherPictureTitle];
    
    _teacherPictureTip = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _idCardPictureLeft.bottom, 200, 50)];
    _teacherPictureTip.text = @"图片最大不超过xxM";
    _teacherPictureTip.font = SYSTEMFONT(15);
    _teacherPictureTip.textColor = EdlineV5_Color.textThirdColor;
    _teacherPictureTip.textAlignment = NSTextAlignmentRight;
    _teacherPictureTip.hidden = YES;
    [_otherBackView addSubview:_teacherPictureTip];
    
    _teacherPicture = [[UIImageView alloc] initWithFrame:CGRectMake(15, _teacherPictureTitle.bottom, 169, 169)];
    _teacherPicture.image = Image(@"teacher_id");
    _teacherPicture.clipsToBounds = YES;
    _teacherPicture.contentMode = UIViewContentModeScaleAspectFill;
    _teacherPicture.userInteractionEnabled = YES;
    UITapGestureRecognizer *teacherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserFaceTap:)];
    [_teacherPicture addGestureRecognizer:teacherTap];
    [_otherBackView addSubview:_teacherPicture];
    // 讲师资格证照片
}

- (void)makeAgreeView {
    
    _bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _teacherPicture.bottom + 17, MainScreenWidth, 0)];
    _bottomBackView.backgroundColor = EdlineV5_Color.backColor;
    [_otherBackView addSubview:_bottomBackView];
    
    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    _agreeBackView.backgroundColor = EdlineV5_Color.backColor;
    [_bottomBackView addSubview:_agreeBackView];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"《%@机构用户服务协议》",appName];
    NSString *fullString = [NSString stringWithFormat:@"   我已阅读并同意%@",atr];
    NSRange atrRange = [fullString rangeOfString:atr];
    
    _agreementTyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 20)];
    _agreementTyLabel.backgroundColor = EdlineV5_Color.backColor;
    _agreementTyLabel.centerY = 60 / 2.0;
    _agreementTyLabel.font = SYSTEMFONT(13);
    _agreementTyLabel.textAlignment = kCTTextAlignmentLeft;
    _agreementTyLabel.textColor = EdlineV5_Color.textSecendColor;
    _agreementTyLabel.delegate = self;
    _agreementTyLabel.numberOfLines = 0;
    
    TYLinkTextStorage *textStorage = [[TYLinkTextStorage alloc]init];
    textStorage.textColor = EdlineV5_Color.themeColor;
    textStorage.font = SYSTEMFONT(13);
    textStorage.linkData = @{@"type":@"service"};
    textStorage.underLineStyle = kCTUnderlineStyleNone;
    textStorage.range = atrRange;
    textStorage.text = atr;
    
    // 属性文本生成器
    TYTextContainer *attStringCreater = [[TYTextContainer alloc]init];
    attStringCreater.text = fullString;
    _agreementTyLabel.textContainer = attStringCreater;
    _agreementTyLabel.textContainer.linesSpacing = 4;
    attStringCreater.font = SYSTEMFONT(13);
    attStringCreater.textAlignment = kCTTextAlignmentLeft;
    attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30, 1))];
    [_agreementTyLabel setHeight:_agreementTyLabel.textContainer.textHeight];
    _agreementTyLabel.centerY = 60 / 2.0;
    [attStringCreater addTextStorageArray:@[textStorage]];
    [_agreeBackView addSubview:_agreementTyLabel];
    
    _seleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [_seleteBtn setImage:Image(@"checkbox_nor") forState:0];
    [_seleteBtn setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
    [_seleteBtn setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateDisabled];
    [_seleteBtn addTarget:self action:@selector(seleteAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
}

- (void)makeDownView {
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, _agreeBackView.bottom + 20, MainScreenWidth - 30, 40)];
    [_submitButton setTitle:@"提交申请" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    [_submitButton addTarget:self action:@selector(submitApplyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBackView addSubview:_submitButton];
    
    [_bottomBackView setHeight:_submitButton.bottom + 10];
    
    [_otherBackView setHeight:_bottomBackView.bottom];
    if (_otherBackView.bottom < _nextScrollView.height) {
        [_bottomBackView setHeight:_submitButton.bottom + 10 + (_nextScrollView.height - _otherBackView.bottom)];
        [_otherBackView setHeight:_bottomBackView.bottom];
    }
    _nextScrollView.contentSize = CGSizeMake(0, _otherBackView.bottom);
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _institutionTextField) {
        isInstitutionTextField = YES;
    } else {
        isInstitutionTextField = NO;
    }
    if (SWNOTEmptyStr(verified_status)) {
        if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    // 重置
    isInstitutionTextField = NO;
    if (SWNOTEmptyStr(verified_status)) {
        if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)makePickerView {
    _pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _pickBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    [self.view addSubview:_pickBackView];
    
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 240.5, MainScreenWidth, 241)];
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteBackView];
    
    UILabel *institutionPickerTheme = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    institutionPickerTheme.text = @"所属机构";
    institutionPickerTheme.font = SYSTEMFONT(16);
    institutionPickerTheme.textAlignment = NSTextAlignmentCenter;
    institutionPickerTheme.centerX = MainScreenWidth / 2.0;
    [_whiteBackView addSubview:institutionPickerTheme];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [_cancelButton setTitle:@"取消" forState:0];
    [_cancelButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [_cancelButton addTarget:self action:@selector(pickerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_cancelButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 0, 70, 50)];
    [_sureButton setTitle:@"确定" forState:0];
    [_sureButton setTitleColor:BasidColor forState:0];
    [_sureButton addTarget:self action:@selector(pickerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_sureButton];
    
    _pickerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cancelButton.bottom, MainScreenWidth, 1)];
    _pickerLineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_whiteBackView addSubview:_pickerLineView];
    
    _choosePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _pickerLineView.bottom, MainScreenWidth, 190)];
    _choosePickerView.delegate = self;
    _choosePickerView.dataSource = self;
    _choosePickerView.backgroundColor = [UIColor whiteColor];
    [_whiteBackView addSubview:_choosePickerView];
    
    _pickBackView.hidden = YES;
    _whiteBackView.hidden = YES;
}

- (void)pickerViewButtonClick:(UIButton *)sender {
    if (sender == _sureButton) {
        if (SWNOTEmptyArr(_schoolArray)) {
            _institutionRightLabel.text = [NSString stringWithFormat:@"%@",[_schoolArray[currentPickerRow] objectForKey:@"title"]];
            schoolID = [NSString stringWithFormat:@"%@",[_schoolArray[currentPickerRow] objectForKey:@"id"]];
        }
    }
    _pickBackView.hidden = YES;
    _whiteBackView.hidden = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _schoolArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return MainScreenWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 35)];
    pickerLabel.font = SYSTEMFONT(14);
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.text = [NSString stringWithFormat:@"%@",[_schoolArray[row] objectForKey:@"title"]];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentPickerRow = row;
}

- (void)changeUserFaceTap:(UITapGestureRecognizer *)sender {
    [self textFieldResign];
    
    if (sender.view == _idCardPictureLeft) {
        whichPic = @"idCardFont";
        if (SWNOTEmptyArr(_imageArray)) {
            ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
            scanVC.imgArr = _imageArray;
            scanVC.index = 0;
            scanVC.delegate = self;
            //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
            if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
                scanVC.hiddenRightButton = YES;
            }
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:scanVC animated:YES completion:^{
                
            }];
            return;
        }
    } else if (sender.view == _idCardPictureRight) {
        whichPic = @"idCardBack";
        if (SWNOTEmptyArr(_imageArrayIdCardBack)) {
            ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
            scanVC.imgArr = _imageArrayIdCardBack;
            scanVC.index = 0;
            scanVC.delegate = self;
            //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
            if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
                scanVC.hiddenRightButton = YES;
            }
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:scanVC animated:YES completion:^{
                
            }];
            return;
        }
    } else if (sender.view == _teacherPicture) {
        whichPic = @"teacherId";
        if (SWNOTEmptyArr(_imageArrayTeacher)) {
            ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
            scanVC.imgArr = _imageArrayTeacher;
            scanVC.index = 0;
            scanVC.delegate = self;
            //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
            if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
                scanVC.hiddenRightButton = YES;
            }
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:scanVC animated:YES completion:^{
                
            }];
            return;
        }
    } else if (sender.view == _logoImageView) {
        whichPic = @"logoId";
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//进入相册
//        if (_imageArray.count >= MAX_IMAGE_COUNT) {
//            [TKProgressHUD showError:[NSString stringWithFormat:@"最多选%d张图片",MAX_IMAGE_COUNT] toView:self.view];
//            return;
//        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];//[[TZImagePickerController alloc] initWithMaxImagesCount:0 delegate:self singleChoose:NO];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else if (buttonIndex == 1){//相机拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            UIImagePickerController *_imagePickerController1 = [[UIImagePickerController alloc]init];
            _imagePickerController1.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePickerController1.delegate = self;
            _imagePickerController1.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
            _imagePickerController1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _imagePickerController1.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:_imagePickerController1 animated:YES completion:^{
                
            }];
        }
        else
        {
//            [self showError:@"设备不支持" toView:self.view];
            [self showHudInView:self.view showHint:@"设备不支持"];
        }
//        if (_imageArray.count>=MAX_IMAGE_COUNT) {
//            [TKProgressHUD showError:[NSString stringWithFormat:@"最多选%d张图片",MAX_IMAGE_COUNT] toView:self.view];
//            return;
//        }
//        else
//        {
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//            {
//
//                UIImagePickerController *_imagePickerController1 = [[UIImagePickerController alloc]init];
//                _imagePickerController1.sourceType = UIImagePickerControllerSourceTypeCamera;
//                _imagePickerController1.delegate = self;
//                _imagePickerController1.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
//                _imagePickerController1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//                [self presentViewController:_imagePickerController1 animated:YES completion:^{
//
//                }];
//            }
//            else
//            {
//                [TKProgressHUD showError:@"设备不支持" toView:self.view];
//            }
//        }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    if ([whichPic isEqualToString:@"idCardFont"]) {
        [_imageArray removeAllObjects];
        [_imageArray addObjectsFromArray:photos];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        [_imageArrayIdCardBack removeAllObjects];
        [_imageArrayIdCardBack addObjectsFromArray:photos];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        [_imageArrayTeacher removeAllObjects];
        [_imageArrayTeacher addObjectsFromArray:photos];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"logoId"]) {
        [_logoImageArray removeAllObjects];
        [_logoImageArray addObjectsFromArray:photos];
        [self verifyImage];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    if ([whichPic isEqualToString:@"idCardFont"]) {
        [_imageArray removeAllObjects];
        [_imageArray addObject:coverImage];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        [_imageArrayIdCardBack removeAllObjects];
        [_imageArrayIdCardBack addObject:coverImage];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        [_imageArrayTeacher removeAllObjects];
        [_imageArrayTeacher addObject:coverImage];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"logoId"]) {
        [_logoImageArray removeAllObjects];
        [_logoImageArray addObject:coverImage];
        [self verifyImage];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if ([whichPic isEqualToString:@"idCardFont"]) {
            [_imageArray removeAllObjects];
            [_imageArray addObject:image];
            [self verifyImage];
        } else if ([whichPic isEqualToString:@"idCardBack"]) {
            [_imageArrayIdCardBack removeAllObjects];
            [_imageArrayIdCardBack addObject:image];
            [self verifyImage];
        } else if ([whichPic isEqualToString:@"teacherId"]) {
            [_imageArrayTeacher removeAllObjects];
            [_imageArrayTeacher addObject:image];
            [self verifyImage];
        } else if ([whichPic isEqualToString:@"logoId"]) {
            [_logoImageArray removeAllObjects];
            [_logoImageArray addObject:image];
            [self verifyImage];
        }
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    if ([whichPic isEqualToString:@"idCardFont"]) {
        [_imageArray removeAllObjects];
        [_imageArray addObjectsFromArray:photos];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        [_imageArrayIdCardBack removeAllObjects];
        [_imageArrayIdCardBack addObjectsFromArray:photos];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        [_imageArrayTeacher removeAllObjects];
        [_imageArrayTeacher addObjectsFromArray:photos];
        [self verifyImage];
    } else if ([whichPic isEqualToString:@"logoId"]) {
        [_logoImageArray removeAllObjects];
        [_logoImageArray addObjectsFromArray:photos];
        [self verifyImage];
    }
}

- (void)verifyImage {
    if ([whichPic isEqualToString:@"idCardFont"]) {
        if (!SWNOTEmptyArr(_imageArray)) {
            return;
        }
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        if (!SWNOTEmptyArr(_imageArrayIdCardBack)) {
            return;
        }
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        if (!SWNOTEmptyArr(_imageArrayTeacher)) {
            return;
        }
    } else if ([whichPic isEqualToString:@"logoId"]) {
        if (!SWNOTEmptyArr(_logoImageArray)) {
            return;
        }
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSString *fieldName = @"image0.jpg";
    NSData *dataImg;
    if ([whichPic isEqualToString:@"idCardFont"]) {
        dataImg = UIImageJPEGRepresentation(_imageArray[0], 0.5);
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        dataImg = UIImageJPEGRepresentation(_imageArrayIdCardBack[0], 0.5);
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        dataImg = UIImageJPEGRepresentation(_imageArrayTeacher[0], 0.5);
    } else if ([whichPic isEqualToString:@"logoId"]) {
        dataImg = UIImageJPEGRepresentation(_logoImageArray[0], 0.5);
    }
    UIImage *image = [UIImage imageWithData:dataImg];
    [param setObject:fieldName forKey:@"name"];
    [param setObject:[EdulineV5_Tool getImageFieldMD5:dataImg] forKey:@"md5"];
    [self showHudInView:self.view hint:@"上传中..."];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path verifyImageExit] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                [self uploadImage];
            } else {
                [self hideHud];
            }
        } else {
            [self hideHud];
        }
    } enError:^(NSError * _Nonnull error) {
        [self hideHud];
    }];
}

- (void)uploadImage {
    if ([whichPic isEqualToString:@"idCardFont"]) {
        if (!SWNOTEmptyArr(_imageArray)) {
            [self hideHud];
            return;
        }
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        if (!SWNOTEmptyArr(_imageArrayIdCardBack)) {
            [self hideHud];
            return;
        }
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        if (!SWNOTEmptyArr(_imageArrayTeacher)) {
            [self hideHud];
            return;
        }
    } else if ([whichPic isEqualToString:@"logoId"]) {
        if (!SWNOTEmptyArr(_logoImageArray)) {
            [self hideHud];
            return;
        }
    }
    [Net_API POST:[Net_Path uploadImageField] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传图片
        if ([whichPic isEqualToString:@"idCardFont"]) {
            for (int i = 0; i<_imageArray.count; i++) {
                NSData *dataImg=UIImageJPEGRepresentation(_imageArray[i], 0.5);
                [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpg"];
            }
        } else if ([whichPic isEqualToString:@"idCardBack"]) {
            for (int i = 0; i<_imageArrayIdCardBack.count; i++) {
                NSData *dataImg=UIImageJPEGRepresentation(_imageArrayIdCardBack[i], 0.5);
                [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpg"];
            }
        } else if ([whichPic isEqualToString:@"teacherId"]) {
            for (int i = 0; i<_imageArrayTeacher.count; i++) {
                NSData *dataImg=UIImageJPEGRepresentation(_imageArrayTeacher[i], 0.5);
                [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpg"];
            }
        } else if ([whichPic isEqualToString:@"logoId"]) {
            for (int i = 0; i<_logoImageArray.count; i++) {
                NSData *dataImg=UIImageJPEGRepresentation(_logoImageArray[i], 0.5);
                [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self hideHud];
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            if ([whichPic isEqualToString:@"idCardFont"]) {
                idCardIDFont = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]];
                _idCardPictureLeft.image = _imageArray[0];
            } else if ([whichPic isEqualToString:@"idCardBack"]) {
                idCardIDBack = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]];
                _idCardPictureRight.image = _imageArrayIdCardBack[0];
            } else if ([whichPic isEqualToString:@"teacherId"]) {
                teacherId = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]];
                _teacherPicture.image = _imageArrayTeacher[0];
            } else if ([whichPic isEqualToString:@"logoId"]) {
                logoId = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]];
                _logoImageView.image = _logoImageArray[0];
            }
        } else {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self hideHud];
        [self showHudInView:self.view showHint:@"上传头像超时,请重试"];
    }];
}

-(void)sendPhotoArr:(NSArray *)array{
    if ([whichPic isEqualToString:@"idCardFont"]) {
        [_imageArray removeAllObjects];
        [_imageArray addObjectsFromArray:array];
        if (SWNOTEmptyArr(_imageArray)) {
            if ([_imageArray[0] isKindOfClass:[UIImage class]]) {
                _idCardPictureLeft.image = _imageArray[0];
            } else {
                [_idCardPictureLeft sd_setImageWithURL:[NSURL URLWithString:_imageArray[0]] placeholderImage:Image(@"id_front")];
            }
        } else {
            _idCardPictureLeft.image = Image(@"id_front");
        }
    } else if ([whichPic isEqualToString:@"idCardBack"]) {
        [_imageArrayIdCardBack removeAllObjects];
        [_imageArrayIdCardBack addObjectsFromArray:array];
        if (SWNOTEmptyArr(_imageArrayIdCardBack)) {
            if ([_imageArrayIdCardBack[0] isKindOfClass:[UIImage class]]) {
                _idCardPictureRight.image = _imageArrayIdCardBack[0];
            } else {
                [_idCardPictureRight sd_setImageWithURL:[NSURL URLWithString:_imageArrayIdCardBack[0]] placeholderImage:Image(@"id_back_def")];
            }
        } else {
            _idCardPictureRight.image = Image(@"id_back_def");
        }
    } else if ([whichPic isEqualToString:@"teacherId"]) {
        [_imageArrayTeacher removeAllObjects];
        [_imageArrayTeacher addObjectsFromArray:array];
        if (SWNOTEmptyArr(_imageArrayTeacher)) {
            if ([_imageArrayTeacher[0] isKindOfClass:[UIImage class]]) {
                _teacherPicture.image = _imageArrayTeacher[0];
            } else {
                [_teacherPicture sd_setImageWithURL:[NSURL URLWithString:_imageArrayTeacher[0]] placeholderImage:Image(@"teacher_id")];
            }
        } else {
            _teacherPicture.image = Image(@"teacher_id");
        }
    }
}

- (void)coverButtonClick:(UIButton *)sender {
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"1"]) {
        return;
    }
    [self textFieldResign];
    if (sender == _institutionIcon) {
        _pickBackView.hidden = NO;
        _whiteBackView.hidden = NO;
        currentPickerRow = 0;
        [_choosePickerView reloadAllComponents];
        if (_schoolArray.count) {
            [_choosePickerView selectRow:0 inComponent:0 animated:NO];
        }
    } else if (sender == _industryIcon) {
        // 跳转到选择分类页面
        TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
        vc.typeString = @"2";
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)seleteAgreementButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)viewTapClick:(UITapGestureRecognizer *)tap {
    [self textFieldResign];
}

- (void)placeLabelTap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
    _institutionInroPlace.hidden = YES;
    [_institutionInroTextView becomeFirstResponder];
}

- (void)addressPlaceLabelTap:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
    _addressPlace.hidden = YES;
    [_addressTextView becomeFirstResponder];
}

- (void)textFieldResign {
    [_idCardText resignFirstResponder];
    [_institutionInroTextView resignFirstResponder];
    [_institutionTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_addressTextView resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    // 重置
    isInstitutionTextField = NO;
}
- (void)keyboardWillShow:(NSNotification *)notification{
    if (isInstitutionTextField) {
        // 暂不作处理
    } else {
        NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat otherViewOriginY = _nextBackView.top + _phoneLabel.bottom + 10;
        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
        if ([endValue CGRectValue].size.height > offSet) {
            [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
        }
    }
}

- (void)getUserTeacherApplyInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path institutionApplyNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _teacherApplyInfo = [NSDictionary dictionaryWithDictionary:responseObject];
//                [_schoolArray removeAllObjects];
//                [_schoolArray addObjectsFromArray:_teacherApplyInfo[@"data"][@"school"]];
                [self setApplyInfoData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setApplyInfoData {
    //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
    verified_status = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_status"]];
    if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
        _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
        _submitButton.enabled = NO;
        _submitButton.hidden = YES;
        _seleteBtn.enabled = NO;
    }
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"] || [verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"3"]) {
        
        _statusRightLabel.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_status_text"]];
        
        schoolID = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"mhm_id"]];
        _institutionTextField.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"title"]];
        
        _idCardText.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"legal_IDcard"]];
        if ([verified_status isEqualToString:@"3"]) {
            _idCardText.text = @"";
        }
        
        idCardIDFont = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"legal_IDcard_positive"]];
        [_imageArray removeAllObjects];
        [_idCardPictureLeft sd_setImageWithURL:EdulineUrlString(_teacherApplyInfo[@"data"][@"auth_info"][@"legal_IDcard_positive_url"]) placeholderImage:Image(@"id_front") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                [_imageArray addObject:_idCardPictureLeft.image];
            }
        }];
        
        idCardIDBack = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"legal_IDcard_side"]];
        [_imageArrayIdCardBack removeAllObjects];
//        [_imageArrayIdCardBack addObject:[NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"IDcard_side_url"]]];
        [_idCardPictureRight sd_setImageWithURL:EdulineUrlString(_teacherApplyInfo[@"data"][@"auth_info"][@"legal_IDcard_side_url"]) placeholderImage:Image(@"id_back_def") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                [_imageArrayIdCardBack addObject:_idCardPictureRight.image];
            }
        }];
        
        teacherId = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"business_license"]];
        [_imageArrayTeacher removeAllObjects];
//        [_imageArrayTeacher addObject:[NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"certification_url"]]];
        [_teacherPicture sd_setImageWithURL:EdulineUrlString(_teacherApplyInfo[@"data"][@"auth_info"][@"business_license_url"]) placeholderImage:Image(@"teacher_id") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                [_imageArrayTeacher addObject:_teacherPicture.image];
            }
        }];
        
        [_logoImageView sd_setImageWithURL:EdulineUrlString(_teacherApplyInfo[@"data"][@"auth_info"][@"logo_url"]) placeholderImage:DefaultImage];
        logoId = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"logo"]];
        
        _phoneTextField.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"telephone"]];
        
        _institutionInroTextView.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"intro"]];
        _institutionInroPlace.hidden = YES;
        
        _addressTextView.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"address"]];
        _addressPlace.hidden = YES;
        
        // 处理所属机构内容
        [_teacherCategoryIDArray removeAllObjects];
        [_teacherCategoryTitleArray removeAllObjects];
        [_teacherCategoryArray removeAllObjects];
        
        NSArray *pass = [NSArray arrayWithArray:_teacherApplyInfo[@"data"][@"auth_info"][@"selected_category"]];
        for (NSDictionary *dict in pass) {
            [_teacherCategoryTitleArray addObject:[NSString stringWithFormat:@"%@",dict[@"text"]]];
            NSString *path = [NSString stringWithFormat:@"%@",dict[@"path"]];
            path = [path stringByReplacingOccurrencesOfString:@"[" withString:@""];
            path = [path stringByReplacingOccurrencesOfString:@"]" withString:@""];
            NSArray *pathArray = [path componentsSeparatedByString:@","];
            [_teacherCategoryIDArray addObject:pathArray];
            
            // 组装 _teacherCategoryArray
            if (pathArray.count) {
                if (pathArray.count == 1) {
                    TeacherCategoryModel *model = [[TeacherCategoryModel alloc] init];
                    model.cateGoryId = pathArray[0];
                    model.title = _teacherCategoryTitleArray[0];
                    [_teacherCategoryArray addObject:@[model]];
                } else if (pathArray.count == 2) {
                    TeacherCategoryModel *model = [[TeacherCategoryModel alloc] init];
                    model.cateGoryId = pathArray[0];
                    model.title = _teacherCategoryTitleArray[0];
                    
                    CateGoryModelSecond *modelSecond = [[CateGoryModelSecond alloc] init];
                    modelSecond.cateGoryId = pathArray[1];
                    modelSecond.title = _teacherCategoryTitleArray[0];
                    
                    [_teacherCategoryArray addObject:@[model,modelSecond]];
                } else if (pathArray.count == 3) {
                    TeacherCategoryModel *model = [[TeacherCategoryModel alloc] init];
                    model.cateGoryId = pathArray[0];
                    model.title = _teacherCategoryTitleArray[0];
                    
                    CateGoryModelSecond *modelSecond = [[CateGoryModelSecond alloc] init];
                    modelSecond.cateGoryId = pathArray[1];
                    modelSecond.title = _teacherCategoryTitleArray[0];
                    
                    CateGoryModelThird *modelThird = [[CateGoryModelThird alloc] init];
                    modelThird.cateGoryId = pathArray[2];
                    modelThird.title = _teacherCategoryTitleArray[0];
                    
                    [_teacherCategoryArray addObject:@[model,modelSecond,modelThird]];
                }
            }
        }
        
        if (_teacherCategoryArray.count) {
            _industryRightLabel.text = [NSString stringWithFormat:@"全部%@个",@(_teacherCategoryArray.count)];
        } else {
            _industryRightLabel.text = @"请选择所属行业";
        }
        
        [self setTeacherCategoryUI];
        
        return;
    }
}

// MARK: - TeacherCategoryVCDelegate(选择了分类后传值)
- (void)chooseCategoryArray:(NSMutableArray *)array {
    [_teacherCategoryArray removeAllObjects];
    [_teacherCategoryIDArray removeAllObjects];
    [_teacherCategoryTitleArray removeAllObjects];
    
    [_teacherCategoryArray addObjectsFromArray:array];
    
    // 先获取id数组 再处理ui
    for (int i = 0; i<_teacherCategoryArray.count; i++) {
        NSArray *pass = [NSArray arrayWithArray:_teacherCategoryArray[i]];
        
        if (pass.count == 1) {
            TeacherCategoryModel *model = (TeacherCategoryModel *)pass[0];
            [_teacherCategoryTitleArray addObject:model.title];
        } else if (pass.count == 2) {
            CateGoryModelSecond *model = (CateGoryModelSecond *)pass[1];
            [_teacherCategoryTitleArray addObject:model.title];
        } else if (pass.count == 3) {
            CateGoryModelThird *model = (CateGoryModelThird *)pass[2];
            [_teacherCategoryTitleArray addObject:model.title];
        }
        
        // 内层一围数组
        NSMutableArray *temp = [NSMutableArray new];
        for (int j = 0; j<pass.count; j++) {
            if (j == 0) {
                TeacherCategoryModel *model = (TeacherCategoryModel *)pass[j];
                [temp addObject:model.cateGoryId];
            } else if (j == 1) {
                CateGoryModelSecond *model = (CateGoryModelSecond *)pass[j];
                [temp addObject:model.cateGoryId];
            } else if (j == 2) {
                CateGoryModelThird *model = (CateGoryModelThird *)pass[j];
                [temp addObject:model.cateGoryId];
            }
        }
        [_teacherCategoryIDArray addObject:temp];
    }
    NSLog(@"行业名称数组 = %@\n 行业ID数组 = %@",_teacherCategoryTitleArray,_teacherCategoryIDArray);
    if (_teacherCategoryArray.count) {
        _industryRightLabel.text = [NSString stringWithFormat:@"全部%@个",@(_teacherCategoryArray.count)];
    } else {
        _industryRightLabel.text = @"请选择所属行业";
    }
    // 布局所属行业分类UI
    [self setTeacherCategoryUI];
}

// MARK: - 布局所属行业分类UI
- (void)setTeacherCategoryUI {
    [_industryBackView removeAllSubviews];
    if (_teacherCategoryTitleArray.count) {
        CGFloat topSpacee = 16.0;
        CGFloat rightSpace = 15.0;
        CGFloat btnInSpace = 12.0;
        CGFloat XX = _industryBackView.width;
        CGFloat YY = 0.0;
        CGFloat btnHeight = 32.0;
        for (int i = 0; i<_teacherCategoryTitleArray.count; i++) {
            NSString *secondTitle = [NSString stringWithFormat:@"%@",_teacherCategoryTitleArray[i]];
            CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(13)].width + 4 + 9 + 5 + 20;
            CGFloat btnWidth = [secondTitle sizeWithFont:SYSTEMFONT(13)].width + 4;
            UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX - secondBtnWidth, YY, secondBtnWidth, btnHeight)];
            secondBtn.tag = 100 + i;
            [secondBtn setImage:Image(@"closeCategory") forState:0];
            [secondBtn setTitle:secondTitle forState:0];
            [secondBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            secondBtn.titleLabel.font = SYSTEMFONT(13);
            [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, btnWidth+5/2.0, 0, -btnWidth-5/2.0)];
            [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -secondBtn.currentImage.size.width - 5/2.0, 0, secondBtn.currentImage.size.width + 5/2.0)];
            [secondBtn addTarget:self action:@selector(teacherCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.layer.masksToBounds = YES;
            secondBtn.layer.cornerRadius = btnHeight / 2.0;
            secondBtn.backgroundColor = EdlineV5_Color.backColor;
            if ((XX - secondBtnWidth) < 0) {
                XX = _industryBackView.width - secondBtnWidth;
                YY = YY + topSpacee + btnHeight;
                secondBtn.frame = CGRectMake(XX, YY, secondBtnWidth, btnHeight);
            }
            XX = secondBtn.left - rightSpace;
            if (i == _teacherCategoryTitleArray.count - 1) {
                [_industryBackView setHeight:secondBtn.bottom + topSpacee];
            }
            [_industryBackView addSubview:secondBtn];
        }
    } else {
        [_industryBackView setHeight:0];
    }
    [_nextBackView setTop:_industryBackView.bottom];
    if (_nextBackView.bottom < _mainScrollView.height) {
        [_bottomView setHeight:76 + (_mainScrollView.height - _nextBackView.bottom)];
        [_nextBackView setHeight:_bottomView.bottom];
    }
    _mainScrollView.contentSize = CGSizeMake(0, _nextBackView.bottom);
}

- (void)teacherCategoryButtonClick:(UIButton *)sender {
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"1"]) {
        return;
    }
    NSMutableArray *pass = [NSMutableArray arrayWithArray:_teacherCategoryArray];
    [pass removeObjectAtIndex:sender.tag - 100];
    [self chooseCategoryArray:pass];
}

- (void)submitApplyClick:(UIButton *)sender {
    
    if (!SWNOTEmptyStr(_institutionTextField.text)) {
        [self showHudInView:self.view showHint:@"请填写机构名称"];
        return;
    }
    
    if (!SWNOTEmptyArr(_teacherCategoryIDArray)) {
        [self showHudInView:self.view showHint:@"请选择所属行业"];
        return;
    }
    
    if (!SWNOTEmptyStr(logoId)) {
        [self showHudInView:self.view showHint:@"请上传机构logo"];
        return;
    }
    
    if (!SWNOTEmptyStr(_institutionInroTextView.text)) {
        [self showHudInView:self.view showHint:@"请填写机构简介"];
        return;
    }
    
    if (!SWNOTEmptyStr(_phoneTextField.text)) {
        [self showHudInView:self.view showHint:@"请填写联系电话"];
        return;
    }
    
    if (!SWNOTEmptyStr(_addressTextView.text)) {
        [self showHudInView:self.view showHint:@"请填写联系地址"];
        return;
    }
    
    if (!SWNOTEmptyStr(_idCardText.text)) {
        [self showHudInView:self.view showHint:@"请输入法人身份证号码"];
        return;
    }
    
    if (!SWNOTEmptyStr(idCardIDFont)) {
        [self showHudInView:self.view showHint:@"请上传您的身份证正面照"];
        return;
    }
    
    if (!SWNOTEmptyStr(idCardIDBack)) {
        [self showHudInView:self.view showHint:@"请上传您的身份证反面照"];
        return;
    }
    
    if (!SWNOTEmptyStr(teacherId)) {
        [self showHudInView:self.view showHint:@"请上传您的营业执照"];
        return;
    }
    
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请确认阅读并同意机构用户服务协议"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:_institutionTextField.text forKey:@"title"];
    
    [param setObject:_teacherCategoryIDArray forKey:@"category"];
    
    [param setObject:logoId forKey:@"logo"];
    
    [param setObject:_institutionInroTextView.text forKey:@"intro"];
    
    [param setObject:_phoneTextField.text forKey:@"telephone"];
    
    [param setObject:_addressTextView.text forKey:@"address"];
    
    [param setObject:_idCardText.text forKey:@"legal_IDcard"];
    
    [param setObject:idCardIDFont forKey:@"legal_IDcard_positive"];
    
    [param setObject:idCardIDBack forKey:@"legal_IDcard_side"];
    
    [param setObject:teacherId forKey:@"business_license"];
    
    [Net_API requestPOSTWithURLStr:[Net_Path institutionApplyNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"机构认证失败");
    }];
}

// MARK: - 下一步
- (void)nextButtonClick:(UIButton *)sender {
    _mainScrollView.hidden = YES;
    _nextScrollView.hidden = NO;
    _rightButton.hidden = NO;
}

- (void)leftButtonClick:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - 协议点击代理
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    //非文本/比如表情什么的
    if (![textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        return;
    }
    id linkContain = ((TYLinkTextStorage *)textStorage).linkData;
    if ([linkContain isKindOfClass:[NSDictionary class]]) {
        NSString *typeS = [linkContain objectForKey:@"type"];
        if ([typeS isEqualToString:@"service"]) {
            NSLog(@"TYLinkTouch = service");
        } else if ([typeS isEqualToString:@"netservice"]) {
            NSLog(@"TYLinkTouch = netservice");
        }
    }
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"%@机构用户服务协议",appName];
    WkWebViewController *vc = [[WkWebViewController alloc] init];
    vc.titleString = atr;
    vc.agreementKey = @"school_service";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightButtonClick:(id)sender {
    _rightButton.hidden = YES;
    _mainScrollView.hidden = NO;
    _nextScrollView.hidden = YES;
}

@end
