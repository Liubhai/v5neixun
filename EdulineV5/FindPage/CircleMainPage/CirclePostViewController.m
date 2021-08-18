//
//  CirclePostViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CirclePostViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ScanPhotoViewController.h"
#import "UploadImageModel.h"

@interface CirclePostViewController ()<UITextFieldDelegate, UITextViewDelegate, TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,sendPhotoArrDelegate> {
    BOOL isTextField;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;// 整个容器 便于滚动
@property (strong, nonatomic) UIButton *topSpaceView;// 头部间隔区域
@property (strong, nonatomic) UIView *contentTextBackView;// 文字输入区域父视图
@property (strong, nonatomic) UITextView *contentTextView;// 文字输入区域
@property (strong, nonatomic) UILabel *contentPlaceL;// 默认提示文字
@property (strong, nonatomic) UIView *pictureBackView;// 图片视频放置区域

// 转发
@property (strong, nonatomic) UIView *forwardBackView;// 转发的内容容器
@property (strong, nonatomic) UILabel *forwardContent;// 转发内容的文字
@property (strong, nonatomic) UIImageView *forwardPicture;// 转发内容的图片

//@property (strong, nonatomic) UIView *swicthBackView;// 悬赏开关父视图
//@property (strong, nonatomic) UISwitch *switchOther;// 悬赏开关
//@property (strong, nonatomic) UITextField *scoreTextField;// 悬赏额度

// 储存图片信息
@property (strong, nonatomic) NSMutableArray *pictureArray;
@property (strong, nonatomic) NSString *pictureIds;// 图片上传后ID
@property (strong, nonatomic) NSMutableArray *pictureIdsArray;//存储 UploadImageModel

@end

@implementation CirclePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"发布动态";
    
    if (_isForward) {
        _titleLabel.text = @"转发动态";
    } else {
        _titleLabel.text = @"发布动态";
        if (_isComment || _isReplayComment) {
            _titleLabel.text = @"评论";
        }
    }
    _rightButton.frame = CGRectMake(MainScreenWidth - 15 - 50, 0, 50, 28);
    _rightButton.centerY = _titleLabel.centerY;
    _rightButton.hidden = NO;
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"发布" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    _rightButton.layer.masksToBounds = YES;
    _rightButton.layer.cornerRadius = 3;
    if (_isForward) {
        _rightButton.backgroundColor = EdlineV5_Color.themeColor;
        _rightButton.enabled = YES;
    } else {
        _rightButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
        _rightButton.enabled = NO;
    }
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = [EdlineV5_Color backColor];
    
    _pictureArray = [NSMutableArray new];
    _pictureIdsArray = [NSMutableArray new];
    _pictureIds = @"";
    
    if (_isForward && SWNOTEmptyDictionary(_forwardInfo)) {
        [self getForwardCircleInfo];
    } else {
        [self makeSubView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    _topSpaceView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 25)];
    _topSpaceView.backgroundColor = [UIColor whiteColor];
    [_topSpaceView addTarget:self action:@selector(topSpaceViewClick) forControlEvents:UIControlEventTouchUpInside];
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
    _contentPlaceL.text = @" 发布动态～";
    if (_isForward) {
        _contentPlaceL.text = @" 转发动态～";
    } else {
        _contentPlaceL.text = @" 发布动态～";
        if (_isComment) {
            _contentPlaceL.text = @" 评论内容～";
        }
        if (_isReplayComment) {
            _contentPlaceL.text = @" 回复评论～";
            if (SWNOTEmptyDictionary(_replayCommentInfo)) {
                NSString *replayUsername = [NSString stringWithFormat:@"%@",[_replayCommentInfo objectForKey:@"nick_name"]];
                _contentPlaceL.text = [NSString stringWithFormat:@" 回复:@%@",replayUsername];
            }
        }
    }
    _contentPlaceL.textColor = EdlineV5_Color.textThirdColor;
    _contentPlaceL.font = SYSTEMFONT(14);
    _contentPlaceL.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_contentPlaceL addGestureRecognizer:placeTap];
    [_contentTextBackView addSubview:_contentPlaceL];
    
    _pictureBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentTextBackView.bottom, MainScreenWidth, 10 + 109 + 10)];// 上下间距10
    _pictureBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_pictureBackView];
    
    if (_isForward && SWNOTEmptyDictionary(_forwardInfo) && SWNOTEmptyDictionary(_forwardRealInfo)) {
        _forwardBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _contentTextBackView.bottom, _contentTextBackView.width, 40 + 64 + 10)];
        _forwardBackView.backgroundColor = EdlineV5_Color.backColor;
        [_mainScrollView addSubview:_forwardBackView];
        
        // 40 64 10
        _forwardContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _forwardBackView.width - 20, 40)];
        _forwardContent.font = SYSTEMFONT(13);
        _forwardContent.textColor = EdlineV5_Color.textThirdColor;
        NSString *forwardName = [NSString stringWithFormat:@"@%@：",_forwardRealInfo[@"nick_name"]];
        NSString *fullForwardString = [NSString stringWithFormat:@"%@%@",forwardName,_forwardRealInfo[@"content"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:fullForwardString];
        [att addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, forwardName.length)];
        _forwardContent.attributedText = [[NSAttributedString alloc] initWithAttributedString:att];
        [_forwardBackView addSubview:_forwardContent];
        
        NSArray *picArray = [NSArray arrayWithArray:[_forwardRealInfo objectForKey:@"attach_url"]];
        if (SWNOTEmptyArr(picArray)) {
            _forwardPicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, _forwardContent.bottom, 64, 64)];
            _forwardPicture.clipsToBounds = YES;
            _forwardPicture.contentMode = UIViewContentModeScaleAspectFill;
            [_forwardPicture sd_setImageWithURL:EdulineUrlString(picArray[0]) placeholderImage:DefaultImage];
            [_forwardBackView addSubview:_forwardPicture];
            [_forwardBackView setHeight:40 + 64 + 10];
        } else {
            [_forwardBackView setHeight:40];
        }
    } else {
        [self dealPictureUI];
    }
    
    [_contentTextView becomeFirstResponder];
    
//    _swicthBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _pictureBackView.bottom + 10, MainScreenWidth, 100)];
//    _swicthBackView.backgroundColor = [UIColor whiteColor];
//    [_mainScrollView addSubview:_swicthBackView];
//
//    UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth / 2.0, 50)];
//    switchLabel.text = @"悬赏积分";
//    switchLabel.font = SYSTEMFONT(15);
//    switchLabel.textColor = EdlineV5_Color.textFirstColor;
//    [_swicthBackView addSubview:switchLabel];
//
//    _switchOther = [[UISwitch alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 36, 0, 51, 20)];
//    _switchOther.onTintColor = EdlineV5_Color.themeColor;
//    _switchOther.tintColor = HEXCOLOR(0xC9C9C9);
//    _switchOther.backgroundColor = HEXCOLOR(0xC9C9C9);
//    _switchOther.thumbTintColor = [UIColor whiteColor];
////    [_switchOther addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
//    [_swicthBackView addSubview:_switchOther];
//    [_switchOther setSize:_switchOther.size];
//    _switchOther.centerY = switchLabel.centerY;
//    _switchOther.transform = CGAffineTransformMakeScale(36/51.0, 36/51.0);
//    _switchOther.layer.masksToBounds = YES;
//    _switchOther.layer.cornerRadius = 15;
//
//    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, MainScreenWidth / 2.0, 50)];
//    scoreLabel.text = @"设置积分";
//    scoreLabel.font = SYSTEMFONT(15);
//    scoreLabel.textColor = EdlineV5_Color.textFirstColor;
//    [_swicthBackView addSubview:scoreLabel];
//
//    _scoreTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 50, 100, 50)];
//    _scoreTextField.textColor = EdlineV5_Color.textSecendColor;
//    _scoreTextField.font = SYSTEMFONT(15);
//    _scoreTextField.textAlignment = NSTextAlignmentRight;
////    _scoreTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"账号" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
//    _scoreTextField.delegate = self;
//    _scoreTextField.text = @"120";
//    _scoreTextField.returnKeyType = UIReturnKeyDone;
//    [_swicthBackView addSubview:_scoreTextField];
    
}

// MARK: - 根据图片数据布置界面
- (void)dealPictureUI {
    if (_pictureArray.count>0 || _contentTextView.text.length>0) {
        _rightButton.backgroundColor = EdlineV5_Color.themeColor;
        _rightButton.enabled = YES;
    } else {
        _rightButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
        _rightButton.enabled = NO;
    }
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
//            [_swicthBackView setTop:_pictureBackView.bottom + 10];
            _mainScrollView.contentSize = CGSizeMake(0, ((_pictureBackView.bottom + 40) > _mainScrollView.height) ? (_pictureBackView.bottom + 40) : _mainScrollView.height);
        }
        [_pictureBackView addSubview:postIcon];
    }
}

- (void)pictureViewTap:(UITapGestureRecognizer *)sender {
    [_contentTextView resignFirstResponder];
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
            // MARK: - love you thousend years billon yers should small speak louder shack maybe
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
//    [_pictureArray removeAllObjects];
    [_pictureArray addObjectsFromArray:photos];
    [self dealPictureUI];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
//    [_pictureArray removeAllObjects];
    [_pictureArray addObject:coverImage];
    [self dealPictureUI];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        [_pictureArray removeAllObjects];
        [_pictureArray addObject:image];
        [self dealPictureUI];
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
//    [_pictureArray removeAllObjects];
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
    if (!_isForward) {
        if (_pictureArray.count>0 || textView.text.length>0) {
            _rightButton.backgroundColor = EdlineV5_Color.themeColor;
            _rightButton.enabled = YES;
        } else {
            _rightButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
            _rightButton.enabled = NO;
        }
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _contentPlaceL.hidden = YES;
    [_contentTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _contentPlaceL.hidden = SWNOTEmptyStr(_contentTextView.text) ? YES : NO;
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

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([string isEqualToString:@"\n"]) {
//        [_scoreTextField resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    isTextField = YES;
//    return YES;
//}

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
//        NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGFloat otherViewOriginY = _swicthBackView.top + _scoreTextField.bottom + 10;
//        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
//        if ([endValue CGRectValue].size.height > offSet) {
//            [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
//        }
    } else {
        // 暂不作处理
    }
}

// MARK: - 顶部空白间隔区域点击事件
- (void)topSpaceViewClick {
    [_contentTextView becomeFirstResponder];
}

// MARK: - 发布按钮
- (void)rightButtonClick:(id)sender {
    _rightButton.enabled = NO;
    [self.view endEditing:YES];
    if (_isForward) {
        
    } else {
        if (!SWNOTEmptyStr(_contentTextView.text) && !SWNOTEmptyArr(_pictureArray)) {
            [self showHudInView:self.view showHint:@"请输入内容"];
            _rightButton.enabled = YES;
            return;
        }
    }
    
    [self uploadImage];
}

// MARK: - 发布按钮点击事件
- (void)postCircle {
    NSString *getUrl = [Net_Path circlePost];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_contentTextView.text)) {
        [param setObject:_contentTextView.text forKey:@"content"];
    } else {
        [param setObject:@"分享图片" forKey:@"content"];
    }
    if (_isForward) {
        getUrl = [Net_Path circleForward];
        if (SWNOTEmptyStr(_contentTextView.text)) {
            [param setObject:_contentTextView.text forKey:@"content"];
        } else {
            [param setObject:@"转发动态" forKey:@"content"];
        }
        
        /** 被转发的圈子信息组装 */
        if (SWNOTEmptyDictionary(_forwardRealInfo)) {
            [param setObject:[NSString stringWithFormat:@"%@",_forwardRealInfo[@"id"]] forKey:@"orignal_id"];
            [param setObject:[NSString stringWithFormat:@"%@",_forwardRealInfo[@"user_id"]] forKey:@"owner_id"];
        }
        
    } else {
        if (_isComment) {
            getUrl = [Net_Path circleCommentOrReplay];
            if (SWNOTEmptyStr(_contentTextView.text)) {
                [param setObject:_contentTextView.text forKey:@"content"];
            } else {
                [param setObject:@"图片评论" forKey:@"content"];
            }
            if (SWNOTEmptyDictionary(_commentCircleInfo)) {
                [param setObject:[NSString stringWithFormat:@"%@",_commentCircleInfo[@"id"]] forKey:@"circle_id"];
            }
        }
        if (_isReplayComment) {
            getUrl = [Net_Path circleCommentOrReplay];
            if (SWNOTEmptyStr(_contentTextView.text)) {
                [param setObject:_contentTextView.text forKey:@"content"];
            } else {
                [param setObject:@"图片评论" forKey:@"content"];
            }
            if (SWNOTEmptyDictionary(_commentCircleInfo)) {
                [param setObject:[NSString stringWithFormat:@"%@",_commentCircleInfo[@"id"]] forKey:@"circle_id"];
            }
            if (SWNOTEmptyDictionary(_replayCommentInfo)) {
                [param setObject:[NSString stringWithFormat:@"%@",_replayCommentInfo[@"id"]] forKey:@"comment_id"];
                [param setObject:[NSString stringWithFormat:@"%@",_replayCommentInfo[@"user_id"]] forKey:@"reply_user_id"];
            }
        }
    }
    if (SWNOTEmptyArr(_pictureIdsArray)) {
        NSString *postimageids = @"";
        for (int k = 0; k<_pictureIdsArray.count; k++) {
            UploadImageModel *modelpass = _pictureIdsArray[k];
            if (SWNOTEmptyStr(postimageids)) {
                if (SWNOTEmptyStr(modelpass.imageId)) {
                    postimageids = [NSString stringWithFormat:@"%@,%@",postimageids,modelpass.imageId];
                }
            } else {
                if (SWNOTEmptyStr(modelpass.imageId)) {
                    postimageids = [NSString stringWithFormat:@"%@",modelpass.imageId];
                }
            }
        }
        [param setObject:[NSString stringWithFormat:@"%@",postimageids] forKey:@"attach"];//[%@]
    }
    [Net_API requestPOSTWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                if (_isComment || _isReplayComment) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentActionReloadData" object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"postActionReloadData" object:nil];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
        _rightButton.enabled = YES;
    } enError:^(NSError * _Nonnull error) {
        _rightButton.enabled = YES;
    }];
}

- (void)uploadImage {
    if (!SWNOTEmptyArr(_pictureArray)) {
        [self postCircle];
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("uploadcircleimage", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        __weak typeof(self) weakself = self;
        __block int finishNum = 0;
        [weakself.pictureIdsArray removeAllObjects];
        for (int i = 0; i<weakself.pictureArray.count; i++) {
            UploadImageModel *model = [UploadImageModel new];
            model.imageId = @"";
            model.imageArray = [NSMutableArray new];
            [model.imageArray addObject:weakself.pictureArray[i]];
            model.imageIndex = [NSString stringWithFormat:@"%@",@(i+1)];
            [weakself.pictureIdsArray addObject:model];
            
            [Net_API POST:[Net_Path uploadImageField] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                //上传图片
                NSLog(@"发布图片第 %@ 张图片",model.imageIndex);
                for (int i = 0; i<model.imageArray.count; i++) {
                    NSData *dataImg=UIImageJPEGRepresentation(model.imageArray[i], 0.5);
                    [formData appendPartWithFileData:dataImg name:@"file" fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpg"];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                model.imageId = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]];
                if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
                    finishNum ++ ;
                    if (finishNum == weakself.pictureArray.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 回到主线程进行UI操作
                            NSString *faildIndex = @"";
                            for (int k = 0; k<weakself.pictureIdsArray.count; k++) {
                                UploadImageModel *modelpass = weakself.pictureIdsArray[k];
                                NSLog(@"发布图片第 %@ 张图片的ID = %@",modelpass.imageIndex,modelpass.imageId);
                                if (!SWNOTEmptyStr(modelpass.imageId)) {
                                    if (!SWNOTEmptyStr(faildIndex)) {
                                        faildIndex = [NSString stringWithFormat:@"%@",modelpass.imageIndex];
                                    } else {
                                        faildIndex = [NSString stringWithFormat:@"%@、%@",faildIndex,modelpass.imageIndex];
                                    }
                                }
                            }
                            [weakself hideHud];
                            
                            if (SWNOTEmptyStr(faildIndex)) {
                                [weakself showHudInView:weakself.view showHint:[NSString stringWithFormat:@"上传第 %@ 图片超时,请重试",faildIndex]];
                                _rightButton.enabled = YES;
                            } else {
                                [weakself postCircle];
                            }
                        });
                    }
                } else {
//                    [weakself showHudInView:weakself.view showHint:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                finishNum ++ ;
                if (finishNum == weakself.pictureArray.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 回到主线程进行UI操作
                        _rightButton.enabled = YES;
                        NSString *faildIndex = @"";
                        for (int k = 0; k<weakself.pictureIdsArray.count; k++) {
                            UploadImageModel *modelpass = weakself.pictureIdsArray[k];
                            NSLog(@"发布图片第 %@ 张图片的ID = %@",modelpass.imageIndex,modelpass.imageId);
                            if (!SWNOTEmptyStr(modelpass.imageId)) {
                                if (!SWNOTEmptyStr(faildIndex)) {
                                    faildIndex = [NSString stringWithFormat:@"%@",modelpass.imageIndex];
                                } else {
                                    faildIndex = [NSString stringWithFormat:@"%@、%@",faildIndex,modelpass.imageIndex];
                                }
                            }
                        }
                        [weakself hideHud];
                        
                        if (SWNOTEmptyStr(faildIndex)) {
                            [weakself showHudInView:weakself.view showHint:[NSString stringWithFormat:@"上传第 %@ 图片超时,请重试",faildIndex]];
                        } else {
                            [weakself postCircle];
                        }
                    });
                }
            }];
        }
    });
}

// MARK: - 请求转发圈子信息
- (void)getForwardCircleInfo {
    if (SWNOTEmptyDictionary(_forwardInfo)) {
        NSString *orignal_id = [NSString stringWithFormat:@"%@",_forwardInfo[@"id"]];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path circleForward] WithAuthorization:nil paramDic:@{@"orignal_id":orignal_id} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _forwardRealInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    [self makeSubView];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

@end
