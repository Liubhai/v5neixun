//
//  QuestionPostViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/7.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "QuestionPostViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ScanPhotoViewController.h"

@interface QuestionPostViewController ()<UITextFieldDelegate, UITextViewDelegate, TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,sendPhotoArrDelegate> {
    BOOL isTextField;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;// 整个容器 便于滚动
@property (strong, nonatomic) UIView *topSpaceView;// 头部间隔区域
@property (strong, nonatomic) UIView *contentTextBackView;// 文字输入区域父视图
@property (strong, nonatomic) UITextView *contentTextView;// 文字输入区域
@property (strong, nonatomic) UILabel *contentPlaceL;// 默认提示文字
@property (strong, nonatomic) UIView *pictureBackView;// 图片视频放置区域
@property (strong, nonatomic) UIView *swicthBackView;// 悬赏开关父视图
@property (strong, nonatomic) UISwitch *switchOther;// 悬赏开关
@property (strong, nonatomic) UITextField *scoreTextField;// 悬赏额度

// 储存图片信息
@property (strong, nonatomic) NSMutableArray *pictureArray;


@end

@implementation QuestionPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [EdlineV5_Color backColor];
    _titleLabel.text = @"发布问题";
    _rightButton.hidden = NO;
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"发布" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = [EdlineV5_Color backColor];
    
    _pictureArray = [NSMutableArray new];
    
    [self makeSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = [EdlineV5_Color backColor];
    [self.view addSubview:_mainScrollView];
    
    _topSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 25)];
    _topSpaceView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_topSpaceView];
    
    _contentTextBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _topSpaceView.bottom, MainScreenWidth, 100)];
    _contentTextBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_contentTextBackView];
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 100)];
    _contentTextView.font = SYSTEMFONT(14);
    _contentTextView.textColor = EdlineV5_Color.textFirstColor;
    _contentTextView.delegate = self;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    [_contentTextBackView addSubview:_contentTextView];
    
    _contentPlaceL = [[UILabel alloc] initWithFrame:CGRectMake(_contentTextView.left, _contentTextView.top + 1, _contentTextView.width, 30)];
    _contentPlaceL.text = @"请输入您的问题～";
    _contentPlaceL.textColor = EdlineV5_Color.textThirdColor;
    _contentPlaceL.font = SYSTEMFONT(14);
    _contentPlaceL.userInteractionEnabled = YES;
//    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
//    [_contentPlaceL addGestureRecognizer:placeTap];
    [_contentTextBackView addSubview:_contentPlaceL];
    
    _pictureBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentTextBackView.bottom, MainScreenWidth, 10 + 109 + 10)];// 上下间距10
    _pictureBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_pictureBackView];
    
    [self dealPictureUI];
    
    _swicthBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _pictureBackView.bottom + 10, MainScreenWidth, 100)];
    _swicthBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_swicthBackView];
    
    UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth / 2.0, 50)];
    switchLabel.text = @"悬赏积分";
    switchLabel.font = SYSTEMFONT(15);
    switchLabel.textColor = EdlineV5_Color.textFirstColor;
    [_swicthBackView addSubview:switchLabel];
    
    _switchOther = [[UISwitch alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 36, 0, 51, 20)];
    _switchOther.onTintColor = EdlineV5_Color.themeColor;
    _switchOther.tintColor = HEXCOLOR(0xC9C9C9);
    _switchOther.backgroundColor = HEXCOLOR(0xC9C9C9);
    _switchOther.thumbTintColor = [UIColor whiteColor];
//    [_switchOther addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [_swicthBackView addSubview:_switchOther];
    [_switchOther setSize:_switchOther.size];
    _switchOther.centerY = switchLabel.centerY;
    _switchOther.transform = CGAffineTransformMakeScale(36/51.0, 36/51.0);
    _switchOther.layer.masksToBounds = YES;
    _switchOther.layer.cornerRadius = 15;
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, MainScreenWidth / 2.0, 50)];
    scoreLabel.text = @"设置积分";
    scoreLabel.font = SYSTEMFONT(15);
    scoreLabel.textColor = EdlineV5_Color.textFirstColor;
    [_swicthBackView addSubview:scoreLabel];
    
    _scoreTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 50, 100, 50)];
    _scoreTextField.textColor = EdlineV5_Color.textSecendColor;
    _scoreTextField.font = SYSTEMFONT(15);
    _scoreTextField.textAlignment = NSTextAlignmentRight;
//    _scoreTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"账号" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _scoreTextField.delegate = self;
    _scoreTextField.text = @"120";
    _scoreTextField.returnKeyType = UIReturnKeyDone;
    [_swicthBackView addSubview:_scoreTextField];
    
}

// MARK: - 根据图片数据布置界面
- (void)dealPictureUI {
    [_pictureBackView removeAllSubviews];
    CGFloat xx = 15.0;
    CGFloat yy = 10.0;
    CGFloat inSpace = (MainScreenWidth - xx * 2 - 109 * 3) / 2.0;
    CGFloat ww = 109;
    for (int i = 0; i<_pictureArray.count+1; i++) {
        UIImageView *postIcon = [[UIImageView alloc] initWithFrame:CGRectMake(xx + (inSpace + ww) * (i%3), yy + (yy + ww) * (i/3), ww, ww)];
        postIcon.tag = i + 66;
        postIcon.clipsToBounds = YES;
        postIcon.contentMode = UIViewContentModeScaleAspectFill;
        if (i==_pictureArray.count) {
            // 这个是添加按钮
            postIcon.image = Image(@"addimg");
        } else {
            // 普通图片
            if ([_pictureArray[i] isKindOfClass:[UIImage class]]) {
                postIcon.image = (UIImage *)_pictureArray[i];
            } else {
                [postIcon sd_setImageWithURL:[NSURL URLWithString:_pictureArray[i]] placeholderImage:Image(@"站位图")];
            }
        }
        postIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureViewTap:)];
        [postIcon addGestureRecognizer:picTap];
        if (i == _pictureArray.count) {
            [_pictureBackView setHeight:postIcon.bottom + yy];
            [_swicthBackView setTop:_pictureBackView.bottom + 10];
            _mainScrollView.contentSize = CGSizeMake(0, ((_swicthBackView.bottom + 40) > _mainScrollView.height) ? (_swicthBackView.bottom + 40) : _mainScrollView.height);
        }
        [_pictureBackView addSubview:postIcon];
    }
}

- (void)pictureViewTap:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == _pictureArray.count + 66) {
        // 选择图片
        if (_pictureArray.count >= PostImageMaxCount) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"最多选%d张图片",PostImageMaxCount] toView:self.view];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"图片选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册里选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:PostImageMaxCount - _pictureArray.count delegate:self];
            imagePickerVc.allowCameraLocation = NO;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *_imagePickerController1 = [[UIImagePickerController alloc]init];
                _imagePickerController1.sourceType = UIImagePickerControllerSourceTypeCamera;
                _imagePickerController1.delegate = self;
                _imagePickerController1.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
                _imagePickerController1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                _imagePickerController1.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:_imagePickerController1 animated:YES completion:^{
                    
                }];
            } else {
                [self showHudInView:self.view showHint:@"设备不支持"];
            }
        }];
        [deleteAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [cameraAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [alertController addAction:deleteAction];
        [alertController addAction:cameraAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // 查看图片
        ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
        scanVC.imgArr = _pictureArray;
        scanVC.index = sender.view.tag - 66;
        scanVC.delegate = self;
        scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:scanVC animated:YES completion:^{
        }];
        return;
    }
}

// MARK: - 图片选择代理
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [_pictureArray removeAllObjects];
    [_pictureArray addObjectsFromArray:photos];
    [self dealPictureUI];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    [_pictureArray removeAllObjects];
    [_pictureArray addObject:coverImage];
    [self dealPictureUI];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [_pictureArray removeAllObjects];
        [_pictureArray addObject:image];
        [self dealPictureUI];
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_pictureArray removeAllObjects];
    [_pictureArray addObjectsFromArray:photos];
    [self dealPictureUI];
}

-(void)sendPhotoArr:(NSArray *)array{
    [_pictureArray removeAllObjects];
    [_pictureArray addObjectsFromArray:array];
    [self dealPictureUI];
}

// MARK: - 输入框代理
- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _contentPlaceL.hidden = NO;
    } else {
        _contentPlaceL.hidden = YES;
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _contentPlaceL.hidden = YES;
    [_contentTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _contentPlaceL.hidden = YES;
    isTextField = NO;
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_contentTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_scoreTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    isTextField = YES;
    return YES;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    if (_contentTextView.text.length<=0) {
        _contentPlaceL.hidden = NO;
    } else {
        _contentPlaceL.hidden = YES;
    }
    // 重置
    isTextField = NO;
}
- (void)keyboardWillShow:(NSNotification *)notification{
    if (isTextField) {
        NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat otherViewOriginY = _swicthBackView.top + _scoreTextField.bottom + 10;
        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
        if ([endValue CGRectValue].size.height > offSet) {
            [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
        }
    } else {
        // 暂不作处理
    }
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
