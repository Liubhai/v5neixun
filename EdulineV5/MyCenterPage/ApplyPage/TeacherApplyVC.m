//
//  TeacherApplyVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeacherApplyVC.h"
#import "TeacherCategoryModel.h"

@interface TeacherApplyVC () {
    NSString *whichPic;
    // 附件 id
    NSString *idCardIDFont;
    NSString *idCardIDBack;
    NSString *teacherId;
//    【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
    NSString *verified_status;
    // 机构id
    NSString *schoolID;
    NSInteger currentPickerRow;
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

@property (strong, nonatomic) NSMutableArray *teacherCategoryArray;
@property (strong, nonatomic) NSMutableArray *teacherCategoryIDArray;
@property (strong, nonatomic) NSMutableArray *teacherCategoryTitleArray;

@end

@implementation TeacherApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    whichPic = @"";
    idCardIDFont = @"";
    idCardIDBack = @"";
    teacherId = @"";
    verified_status = @"";
    schoolID = @"";
    currentPickerRow = 0;
    _imageArray = [NSMutableArray new];
    _imageArrayIdCardBack = [NSMutableArray new];
    _imageArrayTeacher = [NSMutableArray new];
    _schoolArray = [NSMutableArray new];
    
    _teacherCategoryArray = [NSMutableArray new];
    _teacherCategoryIDArray = [NSMutableArray new];
    _teacherCategoryTitleArray = [NSMutableArray new];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:viewTap];
    
    _titleLabel.text = @"讲师认证";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeScrollView];
    [self makeSubView];
    [self makeAgreeView];
    [self makeDownView];
    [self makePickerView];
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
}

- (void)makeSubView {
    // 昵称
    _nameLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _nameLeftLabel.text = @"昵称";
    _nameLeftLabel.font = SYSTEMFONT(15);
    _nameLeftLabel.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_nameLeftLabel];
    
    _nameRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, 0, 200, 50)];
    _nameRightLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameRightLabel.font = SYSTEMFONT(15);
    _nameRightLabel.textAlignment = NSTextAlignmentRight;
    _nameRightLabel.text = [UserModel uname];
    [_mainScrollView addSubview:_nameRightLabel];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(15, _nameLeftLabel.bottom, MainScreenWidth - 15, 1)];
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
    
    _institutionRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30 - 200, _line2.bottom, 200, 50)];
    _institutionRightLabel.text = @"请选择所属机构";
    _institutionRightLabel.font = SYSTEMFONT(15);
    _institutionRightLabel.textColor = EdlineV5_Color.textThirdColor;
    _institutionRightLabel.textAlignment = NSTextAlignmentRight;
    [_mainScrollView addSubview:_institutionRightLabel];
    
    _institutionIcon = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, _line2.bottom, 30, 50)];
    [_institutionIcon setImage:Image(@"list_more") forState:0];
    [_institutionIcon addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_institutionIcon];
    
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
    
    // 身份证号
    _otherBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _industryBackView.bottom, MainScreenWidth, 1)];
    _otherBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_otherBackView];
    
    _line4 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 15, 1)];
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
    NSString *atr = [NSString stringWithFormat:@"《%@讲师认证协议》",appName];
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
    [_seleteBtn setImage:Image(@"checkbox_sel") forState:UIControlStateSelected];
    [_seleteBtn setImage:Image(@"checkbox_sel") forState:UIControlStateDisabled];
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
    _mainScrollView.contentSize = CGSizeMake(0, _otherBackView.bottom);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self  textFieldResign];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (SWNOTEmptyStr(verified_status)) {
        if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"]) {
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
    
    //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
    if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"]) {
        return;
    }
    
    if (sender.view == _idCardPictureLeft) {
        whichPic = @"idCardFont";
        if (SWNOTEmptyArr(_imageArray)) {
            ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
            scanVC.imgArr = _imageArray;
            scanVC.index = 0;
            scanVC.delegate = self;
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
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:scanVC animated:YES completion:^{
                
            }];
            return;
        }
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
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"2"]) {
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

- (void)textFieldResign {
    [_idCardText resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
}
- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat otherViewOriginY = _otherBackView.top + 100;
    CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
    [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
}

- (void)getUserTeacherApplyInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path teacherApplyInfoNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _teacherApplyInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                [_schoolArray removeAllObjects];
                [_schoolArray addObjectsFromArray:_teacherApplyInfo[@"data"][@"school"]];
                [self setApplyInfoData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setApplyInfoData {
    //【0：禁用；1：正常；2：待审；:3：驳回；4：未认证；】
    verified_status = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_status"]];
    if ([verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"0"]) {
        _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
        _submitButton.enabled = NO;
        _seleteBtn.enabled = NO;
    }
    if ([verified_status isEqualToString:@"1"] || [verified_status isEqualToString:@"2"] || [verified_status isEqualToString:@"3"]) {
        _statusRightLabel.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_status_text"]];
        
        schoolID = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"mhm_id"]];
        _institutionRightLabel.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"school_name"]];
        
        _idCardText.text = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"IDcard"]];
        
        idCardIDFont = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"IDcard_positive"]];
        [_imageArray removeAllObjects];
        [_imageArray addObject:[NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"IDcard_positive_url"]]];
        [_idCardPictureLeft sd_setImageWithURL:EdulineUrlString(_imageArray[0]) placeholderImage:Image(@"id_front")];
        
        idCardIDBack = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"IDcard_side"]];
        [_imageArrayIdCardBack removeAllObjects];
        [_imageArrayIdCardBack addObject:[NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"IDcard_side_url"]]];
        [_idCardPictureRight sd_setImageWithURL:EdulineUrlString(_imageArrayIdCardBack[0]) placeholderImage:Image(@"id_back_def")];
        
        teacherId = [NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"certification"]];
        [_imageArrayTeacher removeAllObjects];
        [_imageArrayTeacher addObject:[NSString stringWithFormat:@"%@",_teacherApplyInfo[@"data"][@"auth_info"][@"certification_url"]]];
        [_teacherPicture sd_setImageWithURL:EdulineUrlString(_imageArrayTeacher[0]) placeholderImage:Image(@"teacher_id")];
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
    [_otherBackView setTop:_industryBackView.bottom];
    _mainScrollView.contentSize = CGSizeMake(0, _otherBackView.bottom);
}

- (void)teacherCategoryButtonClick:(UIButton *)sender {
    NSMutableArray *pass = [NSMutableArray arrayWithArray:_teacherCategoryArray];
    [pass removeObjectAtIndex:sender.tag - 100];
    [self chooseCategoryArray:pass];
}

- (void)submitApplyClick:(UIButton *)sender {
    
    if (!SWNOTEmptyStr(schoolID)) {
        [self showHudInView:self.view showHint:@"请选择所属机构"];
        return;
    }
    
    if (!SWNOTEmptyArr(_teacherCategoryIDArray)) {
        [self showHudInView:self.view showHint:@"请选择所属行业"];
        return;
    }
    
    if (!SWNOTEmptyStr(_idCardText.text)) {
        [self showHudInView:self.view showHint:@"请输入身份证号码"];
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
        [self showHudInView:self.view showHint:@"请上传您的教师资格证证件照"];
        return;
    }
    
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请确认阅读并同意认证协议"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:schoolID forKey:@"mhm_id"];
    
    [param setObject:_teacherCategoryIDArray forKey:@"category"];
    
    [param setObject:_idCardText.text forKey:@"IDcard"];
    
    [param setObject:idCardIDFont forKey:@"IDcard_positive"];
    
    [param setObject:idCardIDBack forKey:@"IDcard_side"];
    
    [param setObject:teacherId forKey:@"certification"];
    
    [Net_API requestPOSTWithURLStr:[Net_Path teacherApplySubmiteNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"讲师认证失败");
    }];
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
