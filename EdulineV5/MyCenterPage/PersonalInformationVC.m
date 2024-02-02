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
#import "V5_UserModel.h"
#import "RegisterAndForgetPwVC.h"
#import "FaceVerifyViewController.h"
#import "ZLCameraViewController.h"

@interface PersonalInformationVC ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSString *gender;
    NSString *attachId;
    BOOL isTextView;
    CGFloat keyHeight;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property(strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) UILabel *faceTitle;
@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UILabel *accountTitle;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UIView *line4;

@property (strong, nonatomic) UILabel *nameTitle;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UILabel *phoneTitle;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UIView *line5;
@property (strong, nonatomic) UIButton *phoneRightBtn;

@property (strong, nonatomic) UILabel *faceVerifyTitle;
@property (strong, nonatomic) UILabel *faceVerifyStatusLabel;
@property (strong, nonatomic) UIView *line6;
@property (strong, nonatomic) UIButton *faceVerifyRightBtn;

@property (strong, nonatomic) UILabel *sexTitle;
@property (strong, nonatomic) UIButton *maleBtn;
@property (strong, nonatomic) UIButton *feMaleBtn;
@property (strong, nonatomic) UIButton *secrecyBtn;
@property (strong, nonatomic) UIView *line3;
@property (strong, nonatomic) UILabel *introTitle;
@property (strong, nonatomic) UITextView *introTextView;
@property (strong, nonatomic) UILabel *introTextViewPlaceholder;

@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation PersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    _imageArray = [NSMutableArray new];
    gender = @"0";// 0 保密 1 男 2 女
    _titleLabel.text = @"个人信息";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"保存" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    _rightButton.hidden = YES;
    [self makeSubView];
    
    if (SWNOTEmptyDictionary(_userCenterInfo)) {
        _userInfo = [NSDictionary dictionaryWithDictionary:_userCenterInfo[@"data"][@"user"]];
    }
    
    [self getUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoPhone:) name:@"changeUserInfoPagePhone" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 刷新认证状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:@"changeuserinfo" object:nil];
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
    _userFace.image = DefaultUserImage;
    [_userFace sd_setImageWithURL:EdulineUrlString([V5_UserModel avatar]) placeholderImage:DefaultUserImage];
    _userFace.userInteractionEnabled = YES;
    _userFace.clipsToBounds = YES;
    _userFace.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *userfacetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserFaceTap:)];
    [_userFace addGestureRecognizer:userfacetap];
    [_mainScrollView addSubview:_userFace];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _faceTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line1];
    
    _accountTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line1.bottom, _faceTitle.width, 50)];
    _accountTitle.text = @"账号";
    _accountTitle.textColor = EdlineV5_Color.textFirstColor;
    _accountTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_accountTitle];
    
    _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _accountTitle.top, 200, 50)];
    _accountTextField.textColor = EdlineV5_Color.textSecendColor;
    _accountTextField.font = SYSTEMFONT(15);
    _accountTextField.textAlignment = NSTextAlignmentRight;
    _accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"账号" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _accountTextField.delegate = self;
    _accountTextField.text = [NSString stringWithFormat:@"%@",[V5_UserModel userNickName]];
    _accountTextField.returnKeyType = UIReturnKeyDone;
    [_mainScrollView addSubview:_accountTextField];
    
    _line4 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _accountTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line4.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line4];
    
    _nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line4.bottom, _faceTitle.width, 50)];
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
    _nameTextField.text = [NSString stringWithFormat:@"%@",[V5_UserModel uname]];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    [_mainScrollView addSubview:_nameTextField];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _nameTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line2];
    
    _phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line2.bottom, _faceTitle.width, 50)];
    _phoneTitle.text = @"手机号";
    _phoneTitle.textColor = EdlineV5_Color.textFirstColor;
    _phoneTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_phoneTitle];
    
    _phoneRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 0, 30, 30)];
    [_phoneRightBtn setImage:Image(@"list_more") forState:0];
    [_phoneRightBtn addTarget:self action:@selector(jumpToChangePhonePage) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_phoneRightBtn];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(_phoneRightBtn.left - 5 - 200, _phoneTitle.top, 200, 50)];
    _phoneTextField.textColor = EdlineV5_Color.textSecendColor;
    _phoneTextField.font = SYSTEMFONT(15);
    _phoneTextField.textAlignment = NSTextAlignmentRight;
    _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _phoneTextField.delegate = self;
    if (SWNOTEmptyStr([V5_UserModel userPhone])) {
        _phoneTextField.text = [NSString stringWithFormat:@"%@",[V5_UserModel userPhone]];
    }
    [_mainScrollView addSubview:_phoneTextField];
    _phoneRightBtn.centerY = _phoneTextField.centerY;
    
    _line5 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _phoneTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line5.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line5];
    
    NSArray *userFace = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userFaceArray"]];
    
//    if (SWNOTEmptyArr(userFace)) {
        _faceVerifyTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line5.bottom, _faceTitle.width, 50)];
        _faceVerifyTitle.text = @"人脸认证";
        _faceVerifyTitle.textColor = EdlineV5_Color.textFirstColor;
        _faceVerifyTitle.font = SYSTEMFONT(15);
        [_mainScrollView addSubview:_faceVerifyTitle];
        
        _faceVerifyRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 0, 30, 30)];
        [_faceVerifyRightBtn setImage:Image(@"list_more") forState:0];
        [_faceVerifyRightBtn addTarget:self action:@selector(faceVerifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:_faceVerifyRightBtn];
        
        _faceVerifyStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceVerifyRightBtn.left - 5 - 200, _faceVerifyTitle.top, 200, 50)];
        _faceVerifyStatusLabel.textColor = EdlineV5_Color.textThirdColor;
        _faceVerifyStatusLabel.font = SYSTEMFONT(15);
        _faceVerifyStatusLabel.textAlignment = NSTextAlignmentRight;
        _faceVerifyStatusLabel.text = [[V5_UserModel userFaceVerify] isEqualToString:@"1"] ? @"已绑定" : @"未绑定";
        [_mainScrollView addSubview:_faceVerifyStatusLabel];
        _faceVerifyRightBtn.centerY = _faceVerifyStatusLabel.centerY;
        
        _line6 = [[UIView alloc] initWithFrame:CGRectMake(_faceTitle.left, _faceVerifyTitle.bottom, MainScreenWidth - 15, 0.5)];
        _line6.backgroundColor = EdlineV5_Color.fengeLineColor;
        [_mainScrollView addSubview:_line6];
//    }
    
    _sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceTitle.left, _line6.bottom, _faceTitle.width, 50)];//SWNOTEmptyArr(userFace) ?  _line6.bottom : _line5.bottom
    _sexTitle.text = @"性别";
    _sexTitle.textColor = EdlineV5_Color.textFirstColor;
    _sexTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_sexTitle];
    
    
    gender = [NSString stringWithFormat:@"%@",[V5_UserModel gender]];// 0 保密 1 男 2 女
    
    _secrecyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secrecyBtn.frame = CGRectMake(0, _sexTitle.top, 0, 50);//MainScreenWidth - 15 - 60///60
    _secrecyBtn.titleLabel.font = SYSTEMFONT(15);
    [_secrecyBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [_secrecyBtn setImage:Image(@"sexcheckbox_nor") forState:0];
    [_secrecyBtn setImage:[Image(@"sexcheckbox_pre") converToMainColor] forState:UIControlStateSelected];
    [_secrecyBtn setTitle:@"保密" forState:0];
    _secrecyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -12/2.0, 0, 12/2.0);
    _secrecyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12/2.0, 0, -12/2.0);
    [_secrecyBtn addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_secrecyBtn];
    _secrecyBtn.hidden = YES;
    
    _feMaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _feMaleBtn.frame = CGRectMake(MainScreenWidth - 15 - 47, _sexTitle.top, 47, 50);
    _feMaleBtn.titleLabel.font = SYSTEMFONT(15);
    [_feMaleBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    [_feMaleBtn setImage:Image(@"sexcheckbox_nor") forState:0];
    [_feMaleBtn setImage:[Image(@"sexcheckbox_pre") converToMainColor] forState:UIControlStateSelected];
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
    [_maleBtn setImage:[Image(@"sexcheckbox_pre") converToMainColor] forState:UIControlStateSelected];
    [_maleBtn setTitle:@"男" forState:0];
    _maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -12/2.0, 0, 12/2.0);
    _maleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12/2.0, 0, -12/2.0);
    [_maleBtn addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_maleBtn];
    
    if ([gender isEqualToString:@"0"]) {
        [self sexButtonClick:_secrecyBtn];
    } else if ([gender isEqualToString:@"1"]) {
        [self sexButtonClick:_maleBtn];
    } else {
        [self sexButtonClick:_feMaleBtn];
    }
    
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
    _introTextView.returnKeyType = UIReturnKeyDone;
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
    
    if (SWNOTEmptyStr([V5_UserModel intro])) {
        _introTextViewPlaceholder.hidden = YES;
        _introTextView.text = [NSString stringWithFormat:@"%@",[V5_UserModel intro]];
    }
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(17.5, MainScreenHeight - MACRO_UI_SAFEAREA - 51, MainScreenWidth - 17.5 * 2, 40)];
    _saveButton.layer.masksToBounds = YES;
    _saveButton.layer.cornerRadius = 4;
    _saveButton.backgroundColor = EdlineV5_Color.themeColor;
    [_saveButton setTitle:@"保存" forState:0];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:0];
    _saveButton.titleLabel.font = SYSTEMFONT(15);
    [_saveButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
}

- (void)changeUserFaceTap:(UITapGestureRecognizer *)sender {
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
        imagePickerVc.allowCameraLocation = NO;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else if (buttonIndex == 1){//相机拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            UIImagePickerController *_imagePickerController1 = [[UIImagePickerController alloc]init];
            _imagePickerController1.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePickerController1.delegate = self;
            _imagePickerController1.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
            _imagePickerController1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
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

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:photos];
    _userFace.image = _imageArray[0];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:photos];
    _userFace.image = _imageArray[0];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    [_imageArray removeAllObjects];
    [_imageArray addObject:coverImage];
    _userFace.image = coverImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [_imageArray removeAllObjects];
        [_imageArray addObject:image];
        _userFace.image = image;
        
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:photos];
    _userFace.image = _imageArray[0];
}

- (void)sexButtonClick:(UIButton *)sender {
    sender.selected = YES;
    // 0 保密 1 男 2 女
    if (sender == _feMaleBtn) {
        _maleBtn.selected = NO;
        _secrecyBtn.selected = NO;
        gender = @"2";
    } else if (sender == _maleBtn) {
        _feMaleBtn.selected = NO;
        _secrecyBtn.selected = NO;
        gender = @"1";
    } else {
        _feMaleBtn.selected = NO;
        _maleBtn.selected = NO;
        gender = @"0";
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
    isTextView = YES;
    if (keyHeight > 0) {
        CGFloat otherViewOriginY = _introTextView.bottom + 10;
        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
        [_mainScrollView setContentOffset:CGPointMake(0, keyHeight - offSet)];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self inputTextResign];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _accountTextField) {
        if (SWNOTEmptyDictionary(_userInfo)) {
            if ([[_userInfo objectForKey:@"rest_times"] integerValue]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else if (textField == _phoneTextField) {
        [self jumpToChangePhonePage];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self inputTextResign];
        return NO;
    }
    return YES;
}

// MARK: - 修改用户信息
/**nick_name avatar signature gender*/
- (void)rightButtonClick:(id)sender {
    [self verifyImage];
}

- (void)changeUserInfo {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_nameTextField.text)) {
        [param setObject:_nameTextField.text forKey:@"nick_name"];
    } else {
        [param setObject:@"" forKey:@"nick_name"];
    }
    if (SWNOTEmptyStr(_accountTextField.text)) {
        [param setObject:_accountTextField.text forKey:@"user_name"];
    } else {
        [param setObject:@"" forKey:@"user_name"];
    }
    if (SWNOTEmptyStr(_introTextView.text)) {
        [param setObject:_introTextView.text forKey:@"signature"];
    } else {
        [param setObject:@"" forKey:@"signature"];
    }
    
    if (SWNOTEmptyStr(attachId)) {
        [param setObject:attachId forKey:@"avatar"];
    }
    
    if (SWNOTEmptyStr(_phoneTextField.text)) {
        [param setObject:_phoneTextField.text forKey:@"phone"];
    }
    
    [param setObject:gender forKey:@"gender"];
    
    [Net_API requestPUTWithURLStr:[Net_Path userInfoEdition] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                // 个人主页(动态主页)点击编辑跳转过来的时候需要发个通知去更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCircleHomePageInfo" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)verifyImage {
    if (!SWNOTEmptyArr(_imageArray)) {
        [self changeUserInfo];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSString *fieldName = @"image0.jpg";
    NSData *dataImg=UIImageJPEGRepresentation(_imageArray[0], 0.5);
    UIImage *image = [UIImage imageWithData:dataImg];
    [param setObject:fieldName forKey:@"name"];
    [param setObject:[EdulineV5_Tool getImageFieldMD5:dataImg] forKey:@"md5"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path verifyImageExit] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                [self uploadImage];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)uploadImage {
    if (!SWNOTEmptyArr(_imageArray)) {
        return;
    }
    [Net_API POST:[Net_Path uploadImageField] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传图片
        for (int i = 0; i<_imageArray.count; i++) {
            NSData *dataImg=UIImageJPEGRepresentation(_imageArray[i], 0.5);
            [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            attachId = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]];
            [self changeUserInfo];
        } else {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"上传头像超时,请重试"];
    }];
}

- (void)getUserInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path currentLoginUserInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _userInfo = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                [self setInfoData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setInfoData {
    if (SWNOTEmptyDictionary(_userInfo)) {
        if (![[_userInfo objectForKey:@"rest_times"] integerValue]) {
            _accountTextField.textColor = HEXCOLOR(0xB7BAC1);
        }
        [_userFace sd_setImageWithURL:EdulineUrlString(_userInfo[@"avatar_url"]) placeholderImage:DefaultUserImage];
        _accountTextField.text = [NSString stringWithFormat:@"%@",_userInfo[@"user_name"]];
        _nameTextField.text = [NSString stringWithFormat:@"%@",_userInfo[@"nick_name"]];
        _phoneTextField.text = [NSString stringWithFormat:@"%@",_userInfo[@"phone"]];
        
        [V5_UserModel saveUserFaceVerify:[NSString stringWithFormat:@"%@",[_userInfo objectForKey:@"face_verified"]]];
        
        _faceVerifyStatusLabel.text = [[NSString stringWithFormat:@"%@",[_userInfo objectForKey:@"face_verified"]] isEqualToString:@"1"] ? @"已绑定" : @"未绑定";
        gender = [NSString stringWithFormat:@"%@",_userInfo[@"gender"]];// 0 保密 1 男 2 女
        if ([gender isEqualToString:@"0"]) {
            [self sexButtonClick:_secrecyBtn];
        } else if ([gender isEqualToString:@"1"]) {
            [self sexButtonClick:_maleBtn];
        } else {
            [self sexButtonClick:_feMaleBtn];
        }
        NSString *intro = [NSString stringWithFormat:@"%@",_userInfo[@"signature"]];
        if (SWNOTEmptyStr(intro)) {
            _introTextViewPlaceholder.hidden = YES;
            _introTextView.text = [NSString stringWithFormat:@"%@",intro];
        } else {
            _introTextViewPlaceholder.hidden = NO;
            _introTextView.text = @"";
        }
    }
}

- (void)jumpToChangePhonePage {
    [self inputTextResign];
    RegisterAndForgetPwVC *vc = [[RegisterAndForgetPwVC alloc] init];
    vc.changePhone = YES;
    if (SWNOTEmptyStr([V5_UserModel userPhone])) {
        if ([V5_UserModel userPhone].length > 5) {
            vc.hasPhone = YES;
            vc.oldPhone = YES;
            vc.topTitle = @"*输入下方手机号收到的验证码进行验证";
        } else {
            vc.hasPhone = NO;
            vc.oldPhone = NO;
            vc.topTitle = @"*应《中华人民共和国网络安全法》要求，为了更好保障您的账号安全，请绑定您的手机号！";
        }
    } else {
        vc.hasPhone = NO;
        vc.oldPhone = NO;
        vc.topTitle = @"*应《中华人民共和国网络安全法》要求，为了更好保障您的账号安全，请绑定您的手机号！";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inputTextResign {
    [_accountTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_introTextView  resignFirstResponder];
}

- (void)changeUserInfoPhone:(NSNotification *)notice {
    NSDictionary *pass = [NSDictionary dictionaryWithDictionary:notice.userInfo];
    if (SWNOTEmptyDictionary(pass)) {
        _phoneTextField.text = [NSString stringWithFormat:@"%@",[pass objectForKey:@"phone"]];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    isTextView = NO;
    keyHeight = 0;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    if (isTextView) {
        CGFloat otherViewOriginY = _introTextView.bottom + 10;
        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
        [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - 未认证情况下点击认证按钮相应事件
- (void)faceVerifyButtonClick:(UIButton *)sender {
    FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
    vc.isVerify = YES;
    vc.verifyed = [[V5_UserModel userFaceVerify] isEqualToString:@"1"] ? YES : NO;
    vc.verifyResult = ^(BOOL result) {
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
