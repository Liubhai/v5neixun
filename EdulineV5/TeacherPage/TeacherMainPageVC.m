//
//  TeacherMainPageVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeacherMainPageVC.h"
#import "V5_Constant.h"
#import "TeacherIntroVC.h"
#import "TeahcerCourseListVC.h"
#import "Net_Path.h"
#import "UserCommenListVC.h"
#import "InstitutionRootVC.h"

@interface TeacherMainPageVC ()<UIScrollViewDelegate,UITextViewDelegate> {
    NSInteger wordMax;
}

@property (strong, nonatomic) TeacherIntroVC *teacherIntroVC;
@property (strong, nonatomic) TeahcerCourseListVC *teacherCourseVC;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *topBackImageView;
@property (strong, nonatomic) UIButton *leftBackButton;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *InstitutionLabel;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UIButton *introLabelBtn;
@property (strong, nonatomic) UIImageView *rightIcon;

@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *questionButton;

@property (strong, nonatomic) UIButton *guanzhuButton;
@property (strong, nonatomic) UILabel *guanzhuCountLabel;
@property (strong, nonatomic) UIButton *fensiButton;
@property (strong, nonatomic) UILabel *fensiCountLabel;
@property (strong, nonatomic) UIButton *visitorsButton;
@property (strong, nonatomic) UILabel *visitorsCountLabel;


@property (strong, nonatomic) UIView *buttonBackView;
@property (strong, nonatomic) UIButton *introButton;
@property (strong, nonatomic) UIButton *dynamicButton;
@property (strong, nonatomic) UIButton *courseButton;
@property (strong, nonatomic) UIButton *answerButton;
@property (strong, nonatomic) UIView *greenline;
@property (strong, nonatomic) UIView *greyline;

@property (strong, nonatomic) NSArray *buttonTypeArray;

/// 提问弹框
@property (strong, nonatomic) UIView *popBackView;
@property (strong, nonatomic) UIView *popWhiteView;
@property (strong, nonatomic) UIView *popTextBackView;
@property (strong, nonatomic) UITextView *popTextView;
@property (strong, nonatomic) UILabel *popTextPlaceholderLabel;
@property (strong, nonatomic) UILabel *popTextMaxCountView;
@property (strong, nonatomic) UIView *popLine1View;
@property (strong, nonatomic) UIButton *popCancelButton;
@property (strong, nonatomic) UIView *popLine2View;
@property (strong, nonatomic) UIButton *popSureButton;


@end

@implementation TeacherMainPageVC

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    wordMax = 300;
    _buttonTypeArray = @[@"介绍",@"动态",@"课程",@"问答"];
    _titleImage.hidden = YES;
    [self makeHeaderView];
    [self makeButtonBackView];
    [self makeMainScrollView];
    [self getTeacherInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)makeHeaderView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT + 20 + 70 + 25)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    _topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT + 20 + 70 + 25)];
    _topBackImageView.backgroundColor = EdlineV5_Color.themeColor;
    _topBackImageView.image = Image(@"study_card_img");
    [_topView addSubview:_topBackImageView];
    
    _leftBackButton = [[UIButton alloc] initWithFrame:_leftButton.frame];
    [_leftBackButton setImage:Image(@"nav_back_white") forState:0];
    [_leftBackButton addTarget:self action:@selector(leftBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_leftBackButton];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MACRO_UI_UPHEIGHT + 10, 70, 70)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = _faceImageView.height / 2.0;
    _faceImageView.image = DefaultImage;
    [_topView addSubview:_faceImageView];
    
    _InstitutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _faceImageView.top, MainScreenWidth - (_faceImageView.right + 10), 23)];
    _InstitutionLabel.font = SYSTEMFONT(16);
    _InstitutionLabel.text = @"李雷and韩梅梅";
    _InstitutionLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_InstitutionLabel];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, 0, 52, 23)];
    _levelLabel.layer.masksToBounds = YES;
    _levelLabel.layer.cornerRadius = 2;
    _levelLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _levelLabel.layer.borderWidth = 1;
    _levelLabel.font = SYSTEMFONT(11);
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.textAlignment = NSTextAlignmentCenter;
    _levelLabel.centerY = _faceImageView.centerY;
    [_topView addSubview:_levelLabel];
    
    _introLabelBtn = [[UIButton alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _faceImageView.bottom - 20, MainScreenWidth - (_faceImageView.right + 10), 18)];
    _introLabelBtn.titleLabel.font = SYSTEMFONT(13);
    [_introLabelBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_introLabelBtn addTarget:self action:@selector(jumpToInstitution:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_introLabelBtn];
    //9*9
    NSString *secondTitle = @"提问";
    CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(11)].width + 4 + 9 + 10;
    CGFloat space = 3.0;
    _questionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - secondBtnWidth, 0, secondBtnWidth, 21)];
    [_questionButton setImage:Image(@"homepage_qua_icon") forState:0];
    [_questionButton setTitle:@"提问" forState:0];
    [_questionButton setTitleColor:[UIColor whiteColor] forState:0];
    _questionButton.layer.masksToBounds = YES;
    _questionButton.layer.cornerRadius = 2;
    _questionButton.layer.borderWidth = 1;
    _questionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _questionButton.titleLabel.font = SYSTEMFONT(11);
    _questionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _questionButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    _questionButton.centerY = _faceImageView.centerY;
    [_questionButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_questionButton];
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(_questionButton.left - 10 - 50, 0, 50, 21)];
    _likeButton.backgroundColor = [UIColor whiteColor];
    [_likeButton setTitle:@"+关注" forState:0];
    [_likeButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_likeButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _likeButton.layer.masksToBounds = YES;
    _likeButton.layer.cornerRadius = 2;
    _likeButton.titleLabel.font = SYSTEMFONT(11);
    _likeButton.centerY = _faceImageView.centerY;
    [_likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_likeButton];
    NSArray *typeArray = @[@"关注",@"粉丝",@"最近访客"];
    for (int i = 0; i<typeArray.count; i++) {
        UIButton *typeBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainScreenWidth - 60 * 3) / 4.0 + ((MainScreenWidth - 60 * 3) / 4.0 + 60) * i, _faceImageView.bottom + 10, 60, 40)];
        typeBtn.tag = 666 + i;
        UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        countL.font = SYSTEMFONT(16);
        countL.textAlignment = NSTextAlignmentCenter;
        countL.textColor = [UIColor whiteColor];
        [typeBtn addSubview:countL];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
        typeLabel.font = SYSTEMFONT(12);
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.textColor = [UIColor whiteColor];
        typeLabel.text = typeArray[i];
        [typeBtn addSubview:typeLabel];
        
        if (i == 0) {
            _guanzhuButton = typeBtn;
            _guanzhuCountLabel = countL;
        } else if (i == 1) {
            _fensiButton = typeBtn;
            _fensiCountLabel = countL;
        } else {
            _visitorsButton = typeBtn;
            _visitorsCountLabel = countL;
        }
        
        [typeBtn addTarget:self action:@selector(goToUserCommenListVC:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:typeBtn];
    }
    [_topBackImageView setHeight:_faceImageView.bottom + 20 + 40 + 10];
    [_topView setHeight:_faceImageView.bottom + 20 + 40 + 10];
}

- (void)makeButtonBackView {
    _buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _topBackImageView.bottom, MainScreenWidth, 47)];
    _buttonBackView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_buttonBackView];
    [_topView setHeight:_buttonBackView.bottom];
    
    _greyline = [[UIView alloc] initWithFrame:CGRectMake(0, 46, MainScreenWidth, 1)];
    _greyline.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_buttonBackView addSubview:_greyline];
    
    _greenline = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 20, 2)];
    _greenline.backgroundColor = EdlineV5_Color.themeColor;
    _greenline.layer.masksToBounds = YES;
    _greenline.layer.cornerRadius = 1.5;
    [_buttonBackView addSubview:_greenline];
    
    for (int i = 0; i < _buttonTypeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth * i / 4.0, 0, MainScreenWidth / 4.0, 47)];
        [btn setTitle:_buttonTypeArray[i] forState:0];
        [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        btn.titleLabel.font = SYSTEMFONT(15);
        [btn addTarget:self action:@selector(buttonTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_buttonBackView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            _introButton = btn;
            _greenline.centerX = btn.centerX;
        } else if (i == 1) {
            _dynamicButton = btn;
        } else if (i == 2) {
            _courseButton = btn;
        } else if (i == 3) {
            _answerButton = btn;
        }
    }
}

- (void)makeMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.bottom, MainScreenWidth, MainScreenHeight - _topView.bottom)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth*_buttonTypeArray.count, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    _teacherIntroVC = [[TeacherIntroVC alloc] init];
    _teacherIntroVC.teacherId = _teacherId;
    _teacherIntroVC.tabelHeight = _mainScrollView.height;
    _teacherIntroVC.view.frame = CGRectMake(0,0, MainScreenWidth, _mainScrollView.height);
    [_mainScrollView addSubview:_teacherIntroVC.view];
    [self addChildViewController:_teacherIntroVC];
    
    _teacherCourseVC = [[TeahcerCourseListVC alloc] init];
    _teacherCourseVC.teacherId = _teacherId;
    _teacherCourseVC.tabelHeight = _mainScrollView.height;
    _teacherCourseVC.view.frame = CGRectMake(MainScreenWidth * 2,0, MainScreenWidth, _mainScrollView.height);
    [_mainScrollView addSubview:_teacherCourseVC.view];
    [self addChildViewController:_teacherCourseVC];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            self.greenline.centerX = self.introButton.centerX;
            self.introButton.selected = YES;
            self.dynamicButton.selected = NO;
            self.courseButton.selected = NO;
            self.answerButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.greenline.centerX = self.courseButton.centerX;
            self.introButton.selected = NO;
            self.dynamicButton.selected = NO;
            self.courseButton.selected = YES;
            self.answerButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.greenline.centerX = self.dynamicButton.centerX;
            self.introButton.selected = NO;
            self.dynamicButton.selected = YES;
            self.courseButton.selected = NO;
            self.answerButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.greenline.centerX = self.answerButton.centerX;
            self.introButton.selected = NO;
            self.dynamicButton.selected = NO;
            self.courseButton.selected = NO;
            self.answerButton.selected = YES;
        }
    }
}

- (void)jumpToInstitution:(UIButton *)sender {
    InstitutionRootVC *vc = [[InstitutionRootVC alloc] init];
    vc.institutionId = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"mhm_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToUserCommenListVC:(UIButton *)sender {
    UserCommenListVC *vc = [[UserCommenListVC alloc] init];
    if (sender.tag == 666) {
        vc.themeString = @"关注";
    } else if (sender.tag == 667) {
        vc.themeString = @"粉丝";
    } else {
        vc.themeString = @"最近访客";
    }
    vc.userId = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"user_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonTypeClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * sender.tag, 0) animated:YES];
}

- (void)leftBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likeButtonClick:(UIButton *)sender {
    if (sender == _likeButton) {
        [self followUserAction];
    } else if (sender == _questionButton) {
        [self makePopView];
    }
}

- (void)followUserAction {
    if (SWNOTEmptyDictionary(_teacherInfoDict)) {
        NSString *userId = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"user_id"]];
        if ([[_teacherInfoDict objectForKey:@"is_follow"] boolValue]) {
            [Net_API requestDeleteWithURLStr:[Net_Path userFollowNet] paramDic:@{@"user_id":userId} Api_key:nil finish:^(id  _Nonnull responseObject) {
                [self getTeacherInfo];
            } enError:^(NSError * _Nonnull error) {
                
            }];
        } else {
            [Net_API requestPOSTWithURLStr:[Net_Path userFollowNet] WithAuthorization:nil paramDic:@{@"user_id":userId} finish:^(id  _Nonnull responseObject) {
                [self getTeacherInfo];
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
        
    }
}

- (void)getTeacherInfo {
    if (!SWNOTEmptyStr(_teacherId)) {
        return;
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path teacherMainInfo:_teacherId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _teacherInfoDict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                [self setTeacherInfoData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setTeacherInfoData {
    if (SWNOTEmptyDictionary(_teacherInfoDict)) {
        [_faceImageView sd_setImageWithURL:EdulineUrlString([_teacherInfoDict objectForKey:@"avatar_url"]) placeholderImage:DefaultUserImage];
        _InstitutionLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"title"]];
        _levelLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"level_text"]];
        if ([_levelLabel.text isEqualToString:@"<null>"] || [_levelLabel.text isEqualToString:@"null"] || !SWNOTEmptyStr(_levelLabel.text)) {
            _levelLabel.hidden = YES;
        }
        [_likeButton setTitle:[[_teacherInfoDict objectForKey:@"is_follow"] boolValue] ? @"已关注" : @"+关注" forState:0];
        CGFloat levelWidth = [_levelLabel.text sizeWithFont:_levelLabel.font].width + 4;
        [_levelLabel setWidth:levelWidth];
        NSString *schoolName = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"school_name"]];
        CGFloat secondBtnWidth = [schoolName sizeWithFont:_introLabelBtn.titleLabel.font].width + 4 + 12;
        [_introLabelBtn setWidth:secondBtnWidth];
        [_introLabelBtn setImage:Image(@"jigou_") forState:0];
        [_introLabelBtn setTitle:schoolName forState:0];
        [_introLabelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_introLabelBtn.currentImage.size.width, 0, _introLabelBtn.currentImage.size.width)];
        [_introLabelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-12, 0, -(secondBtnWidth - 12))];
        if ([schoolName isEqualToString:@"<null>"] || [schoolName isEqualToString:@"null"] || !SWNOTEmptyStr(schoolName)) {
            _introLabelBtn.hidden = YES;
        }
        _guanzhuCountLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"follow"]];
        _fensiCountLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"follower"]];
        _visitorsCountLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"recent_visitors"]];
    }
}

// MARK: - 提问弹框
- (void)makePopView {
    if (_popBackView == nil) {
        _popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _popBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [self.view addSubview:_popBackView];
        
        _popWhiteView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth - 270) / 2.0, MainScreenHeight / 2.0 - 180, 270, 180)];
        _popWhiteView.backgroundColor = [UIColor whiteColor];
        _popWhiteView.layer.masksToBounds = YES;
        _popWhiteView.layer.cornerRadius = 7;
        [_popBackView addSubview:_popWhiteView];
        
        _popTextBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, _popWhiteView.width - 40, 95)];
        _popTextBackView.layer.masksToBounds = YES;
        _popTextBackView.layer.cornerRadius = 4;
        _popTextBackView.layer.borderWidth = 0.5;
        _popTextBackView.layer.borderColor = HEXCOLOR(0xE4E7ED).CGColor;
        [_popWhiteView addSubview:_popTextBackView];
        
        _popTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 12, _popTextBackView.width - 24, 75 - 12)];
        _popTextView.font = SYSTEMFONT(14);
        _popTextView.textColor = EdlineV5_Color.textFirstColor;
        _popTextView.delegate = self;
        _popTextView.returnKeyType = UIReturnKeyDone;
        [_popTextBackView addSubview:_popTextView];
        
        _popTextPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_popTextView.left, _popTextView.top + 1, _popTextView.width, 30)];
        _popTextPlaceholderLabel.text = @"输入提问内容";
        _popTextPlaceholderLabel.textColor = EdlineV5_Color.textThirdColor;
        _popTextPlaceholderLabel.font = SYSTEMFONT(14);
        _popTextPlaceholderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
        [_popTextPlaceholderLabel addGestureRecognizer:placeTap];
        [_popTextBackView addSubview:_popTextPlaceholderLabel];
        
        _popTextMaxCountView = [[UILabel alloc] initWithFrame:CGRectMake(_popTextBackView.width - 4 - 100, _popTextBackView.height - 20, 100, 16)];
        _popTextMaxCountView.font = SYSTEMFONT(12);
        _popTextMaxCountView.textColor = EdlineV5_Color.textThirdColor;
        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
        _popTextMaxCountView.textAlignment = NSTextAlignmentRight;
        [_popTextBackView addSubview:_popTextMaxCountView];
        
        _popCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _popWhiteView.height - 50, (_popWhiteView.width - 1) / 2.0, 50)];
        [_popCancelButton setTitle:@"取消" forState:0];
        [_popCancelButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        _popCancelButton.titleLabel.font = SYSTEMFONT(18);
        [_popCancelButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_popCancelButton];
        
        _popLine2View = [[UIView alloc] initWithFrame:CGRectMake(_popCancelButton.right, _popCancelButton.top, 1, 50)];
        _popLine2View.backgroundColor = EdlineV5_Color.fengeLineColor;
        [_popWhiteView addSubview:_popLine2View];
        
        _popSureButton = [[UIButton alloc] initWithFrame:CGRectMake(_popLine2View.right, _popWhiteView.height - 50, (_popWhiteView.width - 1) / 2.0, 50)];
        [_popSureButton setTitle:@"提问" forState:0];
        [_popSureButton setTitleColor:EdlineV5_Color.themeColor forState:0];
        _popSureButton.titleLabel.font = SYSTEMFONT(18);
        [_popSureButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_popSureButton];
        
        _popLine1View = [[UIView alloc] initWithFrame:CGRectMake(0, _popLine2View.top - 1, _popWhiteView.width, 1)];
        _popLine1View.backgroundColor = EdlineV5_Color.fengeLineColor;
        [_popWhiteView addSubview:_popLine1View];
        
    }
    _popBackView.hidden = NO;
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _popTextPlaceholderLabel.hidden = NO;
    } else {
        _popTextPlaceholderLabel.hidden = YES;
    }
    _popTextMaxCountView.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(wordMax)];
    if (textView.text.length>wordMax) {
        NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_popTextMaxCountView.text];
        [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _popTextMaxCountView.text.length - 4)];
        _popTextMaxCountView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    } else {
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _popTextPlaceholderLabel.hidden = YES;
    [_popTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _popTextPlaceholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_popTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)popButtonClick:(UIButton *)sender {
    [_popTextView resignFirstResponder];
    if (sender == _popCancelButton) {
        _popBackView.hidden = YES;
    } else if (sender == _popSureButton) {
        _popBackView.hidden = YES;
        if (!SWNOTEmptyStr(_popTextView.text)) {
            [self showHudInView:self.view showHint:@"请输入提问内容"];
            return;
        }
        if (!SWNOTEmptyDictionary(_teacherInfoDict)) {
            return;
        }
        [Net_API requestPOSTWithURLStr:[Net_Path askQuestionNet] WithAuthorization:nil paramDic:@{@"recive_user_id":[NSString stringWithFormat:@"%@",_teacherInfoDict[@"user_id"]],@"content":_popTextView.text} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _popTextView.text = @"";
                    _popTextPlaceholderLabel.hidden = NO;
                    _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络请求超时"];
        }];
    }
}

@end
