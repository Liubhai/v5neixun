//
//  MyCirclePageVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/6/2.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "MyCirclePageVC.h"
#import "V5_Constant.h"
#import "UserCircleListVC.h"
#import "Net_Path.h"
#import "UserCommenListVC.h"
#import "InstitutionRootVC.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"
#import "PersonalInformationVC.h"

@interface MyCirclePageVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UserCircleListVC *userCircleListVC;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *topBackImageView;
@property (strong, nonatomic) UIButton *leftBackButton;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *InstitutionLabel;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UIButton *introLabelBtn;
@property (strong, nonatomic) UIImageView *rightIcon;

@property (strong, nonatomic) UIButton *questionButton;

@property (strong, nonatomic) UIButton *guanzhuButton;
@property (strong, nonatomic) UILabel *guanzhuCountLabel;
@property (strong, nonatomic) UIButton *fensiButton;
@property (strong, nonatomic) UILabel *fensiCountLabel;
@property (strong, nonatomic) UIButton *visitorsButton;
@property (strong, nonatomic) UILabel *visitorsCountLabel;

@end

@implementation MyCirclePageVC

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    [self makeHeaderView];
    [self makeCircleListVC];
    [self getTeacherInfo];
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
    NSString *secondTitle = @"编辑资料";
    CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(11)].width + 4 + 9 + 10;
    CGFloat space = 3.0;
    _questionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - secondBtnWidth, 0, secondBtnWidth, 21)];
    [_questionButton setImage:Image(@"homepage_qua_icon") forState:0];
    [_questionButton setTitle:@"编辑资料" forState:0];
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
    [_topBackImageView setHeight:_faceImageView.bottom + 10 + 40 + 10];
    [_topView setHeight:_faceImageView.bottom + 10 + 40 + 10];
}

- (void)makeCircleListVC {
    _userCircleListVC = [[UserCircleListVC alloc] init];
    _userCircleListVC.tabelHeight = MainScreenHeight - _topView.bottom;
    _userCircleListVC.view.frame = CGRectMake(0,_topView.bottom, MainScreenWidth, MainScreenHeight - _topView.bottom);
    [self.view addSubview:_userCircleListVC.view];
    [self addChildViewController:_userCircleListVC];
}

- (void)jumpToInstitution:(UIButton *)sender {
    InstitutionRootVC *vc = [[InstitutionRootVC alloc] init];
    vc.institutionId = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"mhm_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToUserCommenListVC:(UIButton *)sender {
    UserCommenListVC *vc = [[UserCommenListVC alloc] init];
    if (sender.tag == 666) {
        vc.themeString = @"我的关注";
    } else if (sender.tag == 667) {
        vc.themeString = @"我的粉丝";
    } else {
        vc.themeString = @"最近访客";
    }
    vc.userId = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"user_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likeButtonClick:(UIButton *)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    PersonalInformationVC *vc = [[PersonalInformationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        CGFloat levelWidth = [_levelLabel.text sizeWithFont:_levelLabel.font].width + 4;
        [_levelLabel setWidth:levelWidth];
        NSString *schoolName = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"school_name"]];
        NSString *mhm_id = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"mhm_id"]];
        CGFloat secondBtnWidth = [schoolName sizeWithFont:_introLabelBtn.titleLabel.font].width + 4 + 12;
        [_introLabelBtn setWidth:secondBtnWidth];
        [_introLabelBtn setImage:Image(@"jigou_") forState:0];
        [_introLabelBtn setTitle:schoolName forState:0];
        [_introLabelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_introLabelBtn.currentImage.size.width, 0, _introLabelBtn.currentImage.size.width)];
        [_introLabelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-12, 0, -(secondBtnWidth - 12))];
        if (SWNOTEmptyStr(mhm_id)) {
            if ([mhm_id isEqualToString:@"1"]) {
                schoolName = @"";
            }
        } else {
            schoolName = @"";
        }
        if ([schoolName isEqualToString:@"<null>"] || [schoolName isEqualToString:@"null"] || !SWNOTEmptyStr(schoolName)) {
            _introLabelBtn.hidden = YES;
        }
        _guanzhuCountLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"follow"]];
        _fensiCountLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"follower"]];
        _visitorsCountLabel.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"recent_visitors"]];
    }
}

@end
