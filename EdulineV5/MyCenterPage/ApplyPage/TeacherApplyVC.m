//
//  TeacherApplyVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeacherApplyVC.h"

@interface TeacherApplyVC ()

@end

@implementation TeacherApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"讲师认证";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeScrollView];
    [self makeSubView];
    [self makeAgreeView];
    [self makeDownView];
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
}

- (void)makeSubView {
    // 昵称
    _nameLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _nameLeftLabel.text = @"昵称";
    _nameLeftLabel.font = SYSTEMFONT(15);
    _nameLeftLabel.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_nameLeftLabel];
    
    _nameRightText = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, 0, 200, 50)];
    _nameRightText.textColor = EdlineV5_Color.textSecendColor;
    _nameRightText.font = SYSTEMFONT(15);
    _nameRightText.textAlignment = NSTextAlignmentRight;
    _nameRightText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入昵称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    [_mainScrollView addSubview:_nameRightText];
    
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
    [_mainScrollView addSubview:_statusRightLabel];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(15, _statusLeftLabel.bottom, MainScreenWidth - 15, 5)];
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
    [_mainScrollView addSubview:_institutionRightLabel];
    
    _institutionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, _line2.bottom, 30, 50)];
    _institutionIcon.image = Image(@"list_more");
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
    [_mainScrollView addSubview:_industryRightLabel];
    
    _industryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, _line3.bottom, 30, 50)];
    _industryIcon.image = Image(@"list_more");
    [_mainScrollView addSubview:_industryIcon];
    
    _industryBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _industryRightLabel.bottom, MainScreenWidth - 30, 0)];
    _industryBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_industryBackView];
    
    // 身份证号
    _otherBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _industryBackView.bottom, MainScreenWidth, 700)];
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
    [_otherBackView addSubview:_idCardPictureTip];
    
    _idCardPictureLeft = [[UIImageView alloc] initWithFrame:CGRectMake(15, _idCardPictureTitle.bottom, (MainScreenWidth - 30 - 7) / 2.0, ((MainScreenWidth - 30 - 7) / 2.0) * 107 / 169)];
    
    // 讲师资格证照片
}

- (void)makeAgreeView {
    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _teacherPicture.bottom + 17, MainScreenWidth, 60)];
    _agreeBackView.backgroundColor = EdlineV5_Color.backColor;
    [_otherBackView addSubview:_agreeBackView];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"《%@讲师认证协议》",appName];
    NSString *fullString = [NSString stringWithFormat:@"   我已阅读并同意%@",atr];
    NSRange atrRange = [fullString rangeOfString:atr];
    
    _agreementTyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 20)];
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
    [_seleteBtn addTarget:self action:@selector(seleteAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
}

- (void)makeDownView {
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _agreeBackView.bottom + 20, MainScreenWidth - 30, 40)];
    [_submitButton setTitle:@"提交申请" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    _submitButton.centerX = _bottomView.width/2.0;
    [_submitButton addTarget:self action:@selector(subMitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_otherBackView addSubview:_submitButton];
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
