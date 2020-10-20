//
//  OtherTypeLoginBindVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/9/4.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OtherTypeLoginBindVC.h"
#import "V5_Constant.h"
#import "RegisterAndForgetPwVC.h"
#import "PWResetViewController.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"
#import "TeacherCategoryVC.h"
#import "FeedBackViewController.h"
#import "WkWebViewController.h"
#import "InstitutionsChooseVC.h"
#import "UnBindMsgCodeVC.h"

#import "RootV5VC.h"
#import "OtherTypeBindCell.h"
#import "Net_Path.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMSocialQQHandler.h>

@interface OtherTypeLoginBindVC ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    BOOL shouldLoad;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *otherTypeArray;

@end

@implementation OtherTypeLoginBindVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (shouldLoad) {
        [self getUserBindStatus];
    }
    shouldLoad = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = @"第三方账号绑定";
    _otherTypeArray = [NSMutableArray new];
    _dataSource = [NSMutableArray new];
    [self makeTableView];
    [self getUserBindStatus];
    // Do any additional setup after loading the view.
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
//    line.backgroundColor = EdlineV5_Color.fengeLineColor;
//    return line;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 10.0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.001;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"OtherTypeBindCell";
    OtherTypeBindCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[OtherTypeBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setSetingCellInfo:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *bindStatus = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"bind"]];
    if ([bindStatus isEqualToString:@"0"]) {
        // 去绑定
        [self bindTypeNet:@"bind" type:_dataSource[indexPath.row][@"key"]];
    } else {
        // 解除绑定
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要解除绑定吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self bindTypeNet:@"unbind" type:_dataSource[indexPath.row][@"key"]];
        }];
        [alertController addAction:commentAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)dealDataSourceArrayKey:(NSString *)objectKey replayKey:(NSString *)replayKey objectValue:(NSString *)objectValue {
    for (int i = 0; i<_dataSource.count; i++) {
        NSMutableArray *pass = [NSMutableArray arrayWithArray:_dataSource[i]];
        for (int j = 0; j<pass.count; j ++) {
            if ([[pass[j] objectForKey:@"type"] isEqualToString:objectKey]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:pass[j]];
                [dic setObject:objectValue forKey:replayKey];
                NSDictionary *passdic = [NSDictionary dictionaryWithDictionary:dic];
                [pass replaceObjectAtIndex:j withObject:passdic];
                [_dataSource replaceObjectAtIndex:i withObject:[NSArray arrayWithArray:pass]];
                return;
            }
        }
    }
}

// MARK: - 其他方式配置
- (void)getOtherTypeConfigNet {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path appthirdloginTypeConfigNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_otherTypeArray removeAllObjects];
                [_otherTypeArray addObjectsFromArray:responseObject[@"data"]];
            }
        }
        [self configOtherShowOrNot:_otherTypeArray];
    } enError:^(NSError * _Nonnull error) {
        [self configOtherShowOrNot:_otherTypeArray];
    }];
}

// MARK: - 根据接口处理数据(目前就简单排序并且清除掉没有开启的third方式)
//{
//    "key": "qq",
//    "open": 0,
//    "bind": 0
//}
- (void)configOtherShowOrNot:(NSMutableArray *)showArray {
    [_dataSource removeAllObjects];
    if (SWNOTEmptyArr(showArray)) {
        [_dataSource addObjectsFromArray:@[@"1",@"1",@"1"]];
    }
    NSMutableArray *indexArray = [NSMutableArray new];// 需要移除的元素下标
    for (int i = 0; i<showArray.count; i++) {
        if ([showArray[i][@"key"] isEqualToString:@"weixin"]) {
            [_dataSource replaceObjectAtIndex:0 withObject:showArray[i]];
        }
        if ([showArray[i][@"key"] isEqualToString:@"qq"]) {
            [_dataSource replaceObjectAtIndex:1 withObject:showArray[i]];
        }
        if ([showArray[i][@"key"] isEqualToString:@"sina"]) {
            [_dataSource replaceObjectAtIndex:2 withObject:showArray[i]];
        }
        if ([[NSString stringWithFormat:@"%@",showArray[i][@"open"]] isEqualToString:@"0"]) {
            // 记录未开启的索引  等下要移除
            [indexArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
        }
    }
    for (int i = 0; i<indexArray.count; i++) {
        [_dataSource removeObjectAtIndex:[indexArray[i] integerValue]];
    }
    
//    if (SWNOTEmptyArr(showArray)) {
//        if ([showArray containsObject:@"weixin"]) {
//            [_dataSource addObject:@{@"type":@"weixin",@"image":@"login_icon_wechat_other",@"status":@"unbind"}];
//        }
//
//        if ([showArray containsObject:@"qq"]) {
//            [_dataSource addObject:@{@"type":@"qq",@"image":@"login_icon_qq_other",@"status":@"unbind"}];
//        }
//
//        if ([showArray containsObject:@"sina"]) {
//            [_dataSource addObject:@{@"type":@"sina",@"image":@"login_icon_wechat_other",@"status":@"unbind"}];
//        }
//    }
    [_tableView reloadData];
}

- (void)bindTypeNet:(NSString *)status type:(NSString *)bindType {
    if ([status isEqualToString:@"bind"]) {
        [self bindType:bindType];
    } else {
        [self unBindNet:bindType];
    }
}

- (void)unBindNet:(NSString *)typeString {
    UnBindMsgCodeVC *vc = [[UnBindMsgCodeVC alloc] init];
    vc.unbindParamString = typeString;
    if ([typeString isEqualToString:@"weixin"]) {
        vc.unbindType = @"unbind_weixin";
    } else if ([typeString isEqualToString:@"qq"]) {
        vc.unbindType = @"unbind_qq";
    } else if ([typeString isEqualToString:@"sina"]) {
        vc.unbindType = @"unbind_sina";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bindType:(NSString *)typeString {
    if ([typeString isEqualToString:@"weixin"]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            if (!error) {
                UMSocialUserInfoResponse *resp = result;
                // 第三方登录数据(为空表示平台未提供)
                // 授权数据
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@", resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                // 用户数据
                NSLog(@" name: %@", resp.name);
                NSLog(@" iconurl: %@", resp.iconurl);
                NSLog(@" gender: %@", resp.unionGender);
                // 第三方平台SDK原始数据
                NSLog(@" originalResponse: %@", resp.originalResponse);
                [self otherTypeLoginNet:@"weixin" unionId:resp.unionId];
            }
        }];
    } else if ([typeString isEqualToString:@"qq"]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
            if (!error) {
                UMSocialUserInfoResponse *resp = result;
                // 第三方登录数据(为空表示平台未提供)
                // 授权数据
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@", resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                // 用户数据
                NSLog(@" name: %@", resp.name);
                NSLog(@" iconurl: %@", resp.iconurl);
                NSLog(@" gender: %@", resp.unionGender);
                // 第三方平台SDK原始数据
                NSLog(@" originalResponse: %@", resp.originalResponse);
                [self getTCUnionId:resp];
            }
        }];
    }
}

- (void)getTCUnionId:(UMSocialUserInfoResponse *)rep {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    [manager GET:@"https://graph.qq.com/oauth2.0/me" parameters:@{@"access_token":rep.accessToken} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"EdulineV4 GET request succece \n%@\n%@",task.currentRequest.URL.absoluteString,responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     #ifdef DEBUG
         NSLog(@"EdulineV4 GET request failure \n%@",task.currentRequest.URL.absoluteString);
     #endif
         // 失败回调
         NSData *errorData = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
         NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
         NSRange range = [errorString rangeOfString:@"{"];
         NSRange range1 = [errorString rangeOfString:@"}"];
         NSString *ppp = [errorString substringWithRange:NSMakeRange(range.location, range1.location - range.location + 1)];
         NSData *jsonData = [ppp dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
         if (SWNOTEmptyDictionary(dic)) {
             [self otherTypeLoginNet:@"qq" unionId:dic[@"openid"]];
         }
     }];
}

- (void)otherTypeLoginNet:(NSString *)type unionId:(NSString *)unionId {
    [Net_API requestPOSTWithURLStr:[Net_Path otherTypeBindNet] WithAuthorization:nil paramDic:@{@"type":type,@"oauth":unionId} finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:responseObject[@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self getUserBindStatus];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"网络请求超时"];
    }];
}

// MARK: - 单独接口请求的当前用户绑定状态
- (void)getUserBindStatus {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path otherTypeBindNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_otherTypeArray removeAllObjects];
                [_otherTypeArray addObjectsFromArray:responseObject[@"data"]];
            }
        }
        [self configOtherShowOrNot:_otherTypeArray];
    } enError:^(NSError * _Nonnull error) {
        [self configOtherShowOrNot:_otherTypeArray];
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
