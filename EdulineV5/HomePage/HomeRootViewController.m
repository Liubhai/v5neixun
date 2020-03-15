//
//  HomeRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomeRootViewController.h"
#import "AliyunVodPlayerView.h"
#import "AliyunUtil.h"

@interface HomeRootViewController ()

@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"首页";
    [self.view addSubview:self.playerView];
}

- (void)configBaseDataSuccess:(void(^)(void))success{
    
    //加载默认的STS数据
    self.config = [[AVCVideoConfig alloc]init];
    self.config.playMethod = AliyunPlayMedthodSTS;
    __weak typeof(self)weakself = self;
    
    [AlivcAppServer getStsDataSucess:^(NSString *accessKeyId, NSString *accessKeySecret, NSString *securityToken) {
        weakself.config.stsAccessKeyId = accessKeyId;
        weakself.config.stsAccessSecret = accessKeySecret;
        weakself.config.stsSecurityToken = securityToken;
        //查询视频列表
        [AlivcVideoPlayManager requestPlayListVodPlayWithCateId:@"1000063702" sucess:^(NSArray *ary, long total) {
            
            self.listView.dataAry = ary;
            AlivcVideoPlayListModel *model = ary.firstObject;
            weakself.config.videoId = model.videoId;
            weakself.config.playMethod = AliyunPlayMedthodSTS;
            //赋值
            _currentPlayVideoModel = [ary objectAtIndex:0];
            
            NSArray *waterMarkArray = @[[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
            NSMutableArray *dataArray  = [[NSMutableArray alloc]initWithCapacity:self.listView.dataAry.count];
            for (int i=0; i<ary.count; ++i) {
                AlivcVideoPlayListModel *itemModel = [ary objectAtIndex:i];
                itemModel.stsAccessKeyId = weakself.config.stsAccessKeyId;
                itemModel.stsAccessSecret = weakself.config.stsAccessSecret;
                itemModel.stsSecurityToken = weakself.config.stsSecurityToken;
                
                if (waterMarkArray.count > i) {
                    itemModel.waterMark = [[waterMarkArray objectAtIndex:i] boolValue];
                }
                [dataArray addObject:itemModel];
            }
             self.listView.dataAry = dataArray;
            
            if (success) {
                success();
            }
        } failure:^(NSString *errString) {
            //
        }];
    } failure:^(NSString *errorString) {
        [MBProgressHUD showMessage:errorString inView:self.view];
    }];
}

- (AliyunVodPlayerView *__nullable)playerView{
    if (!_playerView) {
        CGFloat width = 0;
        CGFloat height = 0;
        CGFloat topHeight = 0;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait ) {
            width = ScreenWidth;
            height = ScreenWidth * 9 / 16.0;
            topHeight = MACRO_UI_UPHEIGHT;
        }else{
            width = ScreenWidth;
            height = ScreenHeight;
            topHeight = 0;
        }
        /****************UI播放器集成内容**********************/
        _playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,topHeight, width, height) andSkin:AliyunVodPlayerViewSkinRed];
//        _playerView.currentModel = _currentPlayVideoModel;
        _playerView.circlePlay = YES;
//        [_playerView setDelegate:self];
       // [_playerView setAutoPlay:YES];
        
        [_playerView setPrintLog:YES];
        
        _playerView.isScreenLocked = false;
        _playerView.fixedPortrait = false;
    
    }
    return _playerView;
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
