//
//  SetingViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SetingViewController.h"
#import "V5_Constant.h"
#import "RegisterAndForgetPwVC.h"
#import "PWResetViewController.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"
#import "TeacherCategoryVC.h"
#import "FeedBackViewController.h"
#import "WkWebViewController.h"
#import "InstitutionsChooseVC.h"
#import "OtherTypeLoginBindVC.h"
#import "SurePwViewController.h"

#import "SetMoneyPwFirstVC.h"
#import "ModifyMoneyPwVC.h"

#import "RootV5VC.h"
#import "SetingCell.h"
#import "Net_Path.h"

@interface SetingViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, SetingCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong ,nonatomic) NSString *totaiZise;
@property (strong, nonatomic) NSMutableArray *otherTypeArray;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"设置";
    _otherTypeArray = [NSMutableArray new];
    _dataSource = [NSMutableArray new];
//    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
//        if ([Show_Config isEqualToString:@"1"]) {
//            [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
//              @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
//            @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
//            @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
//        } else {
//            [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
//              @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
//            @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
//            @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
//        }
//    } else {
//        if ([Show_Config isEqualToString:@"1"]) {
//            [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
//              @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
//            @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
//        } else {
//            [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
//              @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
//            @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
//        }
//    }
    [self makeTableView];
    [self getOtherTypeConfigNet];
}

- (void)canculateLocalMemorySize {
    /** 计算缓存 */
    float count = 0.0;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath4  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"/Caches"];
    NSString *filePath3  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    NSString *filePath2  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"];
    NSString *filePath5  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/videos"];
    NSString *filePath6  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/chatDetail"];
    count += [self folderSizeAtPath:filePath4];
    count += [self folderSizeAtPath:filePath2];
    count += [self folderSizeAtPath:filePath3];
    count += [self folderSizeAtPath:filePath5];
    count += [self folderSizeAtPath:filePath6];

    _totaiZise = [NSString stringWithFormat:@"%.2fM",count];

    [self dealDataSourceArrayKey:@"memory" replayKey:@"rightTitle" objectValue:_totaiZise];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"allow4G"]) {
        BOOL allow4G = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allow4G"] boolValue];
        [self dealDataSourceArrayKey:@"switchPlay" replayKey:@"status" objectValue:allow4G ? @"on" : @"off"];
    }
    [_tableView reloadData];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    return line;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SetingCell";
    SetingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[SetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setSetingCellInfo:_dataSource[indexPath.section][indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"memory"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清理缓存?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self removeBenDi];
        }];
        [deleteAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [alertController addAction:deleteAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"logout"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self quit];
        }];
        [deleteAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [alertController addAction:deleteAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"password"]) {
        if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
            if (SWNOTEmptyStr([V5_UserModel userPhone])) {
                if ([V5_UserModel need_set_password]) {
                    SurePwViewController *vc = [[SurePwViewController alloc] init];
                    vc.justSetPW = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    PWResetViewController *vc = [[PWResetViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"study"]) {
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
        vc.isChange = YES;
        vc.typeString = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"feedback"]) {
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        FeedBackViewController *vc = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"about"]) {
        WkWebViewController *vc = [[WkWebViewController alloc] init];
        vc.titleString = @"关于我们";
        vc.agreementKey = @"about_us";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"institution"]) {
        InstitutionsChooseVC *vc = [[InstitutionsChooseVC alloc] init];
        vc.fromSetingVC = YES;
        vc.institutionChooseFinished = ^(BOOL succesed) {
            [RootV5VC destoryShared];
            RootV5VC * tabbar = [RootV5VC sharedBaseTabBarViewController];
            AppDelegate *app = [AppDelegate delegate];
            app.window.rootViewController = tabbar;
            [app.window makeKeyAndVisible];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"third"]) {
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        OtherTypeLoginBindVC *vc = [[OtherTypeLoginBindVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"paypassword"]) {
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        if (SWNOTEmptyStr([V5_UserModel userPhone])) {
            if ([V5_UserModel userPhone].length>=11) {
                if ([V5_UserModel need_set_paypwd]) {
                    SetMoneyPwFirstVC *vc = [[SetMoneyPwFirstVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    ModifyMoneyPwVC *vc = [[ModifyMoneyPwVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self showHudInView:self.view showHint:@"请先在个人信息里面绑定手机号"];
            }
        } else {
            [self showHudInView:self.view showHint:@"请先在个人信息里面绑定手机号"];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 100) {//说明是清除缓存
        switch (buttonIndex) {
            case 0:
                [self removeBenDi];
                break;
            default:
                break;
        }
        
    } else if (actionSheet.tag == 200) {//退出程序
        switch (buttonIndex) {
            case 0:
                [self quit];
                break;
            default:
                break;
        }
    }
}

- (void)removeBenDi {
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSString *caches1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
//    [manager removeItemAtPath:caches1 error:nil];
//
//    NSLog(@"---%@",caches1);
//
//    NSString *caches2 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
//    [manager removeItemAtPath:caches2 error:nil];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath4  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"Caches/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath4])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath4 error:nil];
    }
    
    NSString *fileDb = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thinksns.db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileDb])
    {
        [[NSFileManager defaultManager] removeItemAtPath:fileDb error:nil];
    }

    NSString *filePath2  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath2]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:nil];
    }
    
    NSString *filePath3  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath3]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath3 error:nil];
    }
    
    NSString *filePath5  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/videos"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath5]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath5 error:nil];
    }
    
    NSString *filePath6  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/chatDetail"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath6]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath6 error:nil];
    }

    [[SDImageCache sharedImageCache] clearWithCacheType:SDImageCacheTypeDisk completion:nil];
    [self showHudInView:self.view showHint:@"清除成功"];
    
    _totaiZise = @"0.00M";
    [self dealDataSourceArrayKey:@"memory" replayKey:@"rightTitle" objectValue:_totaiZise];
    [_tableView reloadData];
    
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    float folderSize = 0.0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    if(folderSize <= 0 || !folderSize){
        return 0;
    }else{
        return folderSize/(1024*1024.0);
    }
}

- (NSInteger)fileSizeWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSLog(@"-----%@",path);
    NSArray *subPaths = [manager subpathsAtPath:path];
    NSInteger totalBySize = 0;
    for (NSString *subPath in subPaths) {
        NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
        BOOL dir = NO;//判断是否为文件
        [manager fileExistsAtPath:fullSubPath isDirectory:&dir];
        
        if (dir == NO) {//文件
            totalBySize += [[manager attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
    
    NSLog(@"-----%ld",totalBySize);
    return totalBySize;
}

-(void)quit {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userface"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthTokenSecret"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthToken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"avatar_small"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uname"];
    [defaults removeObjectForKey:@"balance"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fans"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"follow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"schoolID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Video_Face"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasAlipay"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_phone"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"need_set_password"];
    
    
//    [Passport removeFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
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

- (void)switchClick:(UISwitch *)sender setInfo:(NSDictionary *)setInfo {
    [self dealDataSourceArrayKey:setInfo[@"type"] replayKey:@"status" objectValue:[setInfo[@"status"] isEqualToString:@"off"] ? @"on" : @"off"];
    if ([setInfo[@"type"] isEqualToString:@"switchPlay"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[setInfo[@"status"] isEqualToString:@"off"] ? @"1" : @"0" forKey:@"allow4G"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_tableView reloadData];
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
        BOOL showOther = NO;
        
        if (SWNOTEmptyArr(_otherTypeArray)) {
            if ([_otherTypeArray containsObject:@"weixin"]) {
                showOther = YES;
            }
            
            if ([_otherTypeArray containsObject:@"qq"]) {
                showOther = YES;
            }
            
            if ([_otherTypeArray containsObject:@"sina"]) {
                showOther = YES;
            }
        }
        [self configOtherShowOrNot:showOther];
    } enError:^(NSError * _Nonnull error) {
        BOOL showOther = NO;
        
        if (SWNOTEmptyArr(_otherTypeArray)) {
            if ([_otherTypeArray containsObject:@"weixin"]) {
                showOther = YES;
            }
            
            if ([_otherTypeArray containsObject:@"qq"]) {
                showOther = YES;
            }
            
            if ([_otherTypeArray containsObject:@"sina"]) {
                showOther = YES;
            }
        }
        [self configOtherShowOrNot:showOther];
    }];
}

- (void)configOtherShowOrNot:(BOOL)show {
    [_dataSource removeAllObjects];
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
        if ([Show_Config isEqualToString:@"1"]) {
            if (show) {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
                                                     @{@"title":@"支付密码",@"type":@"paypassword",@"rightTitle":@"",@"status":@"off"},
                  @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
            } else {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},@{@"title":@"支付密码",@"type":@"paypassword",@"rightTitle":@"",@"status":@"off"}],
                @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
            }
        } else {
            if (show) {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},@{@"title":@"支付密码",@"type":@"paypassword",@"rightTitle":@"",@"status":@"off"},
                  @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
            } else {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},@{@"title":@"支付密码",@"type":@"paypassword",@"rightTitle":@"",@"status":@"off"}],
                @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
            }
        }
    } else {
        if ([Show_Config isEqualToString:@"1"]) {
            if (show) {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
            } else {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
            }
        } else {
            if (show) {
                [_dataSource addObjectsFromArray:@[@[
                  @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
            } else {
                [_dataSource addObjectsFromArray:@[@[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
            }
        }
    }
    /**
     if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
         if ([Show_Config isEqualToString:@"1"]) {
             if (show) {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
                   @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                 @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
             } else {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
             }
         } else {
             if (show) {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
                   @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                 @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
             } else {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
             }
         }
     } else {
         if ([Show_Config isEqualToString:@"1"]) {
             if (show) {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
                   @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                 @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
             } else {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"机构切换",@"type":@"institution",@"rightTitle":@"",@"status":@"off"},@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
             }
         } else {
             if (show) {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
                   @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
                 @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
             } else {
                 [_dataSource addObjectsFromArray:@[@[@{@"title":@"登录密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"}],
                 @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
             }
         }
     }
     */
    [self canculateLocalMemorySize];
}

@end
