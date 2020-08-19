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
#import "UserModel.h"
#import "AppDelegate.h"
#import "TeacherCategoryVC.h"
#import "FeedBackViewController.h"
#import "WkWebViewController.h"

#import "SetingCell.h"

@interface SetingViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, SetingCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong ,nonatomic) NSString *totaiZise;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"设置";
    _dataSource = [NSMutableArray new];
    if (SWNOTEmptyStr([UserModel oauthToken])) {
        [_dataSource addObjectsFromArray:@[@[@{@"title":@"修改密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
          @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
        @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}],
        @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@"",@"status":@"off"}]]];
    } else {
        [_dataSource addObjectsFromArray:@[@[@{@"title":@"修改密码",@"type":@"password",@"rightTitle":@"",@"status":@"off"},
          @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ",@"status":@"off"}],
        @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@"",@"status":@"off"},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switchPlay",@"rightTitle":@"",@"status":@"off"},@{@"title":@"允许3G/4G网络缓存视频、音频",@"type":@"switchDownLoad",@"rightTitle":@"",@"status":@"off"},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@"",@"status":@"off"},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@"",@"status":@"off"},@{@"title":@"关于",@"type":@"about",@"rightTitle":@"",@"status":@"off"}]]];
    }
    [self makeTableView];
    
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
    
    //计算本地缓存
//    NSString *onePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
//    NSInteger oneSize = [self fileSizeWithPath:onePath];
//
//    NSString *twoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
//    NSInteger twoSize = [self fileSizeWithPath:twoPath];
//
//    NSLog(@"%ld  %ld",oneSize,twoSize);
//    _totaiZise = oneSize + twoSize;
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
        UIActionSheet *shit = [[UIActionSheet alloc]initWithTitle:@"清理缓存?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        shit.tag = 100;
        [shit showInView:self.view];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"logout"]) {
        UIActionSheet *shit = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"退出", nil];
        shit.tag = 200;
        [shit showInView:self.view];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"password"]) {
        if (SWNOTEmptyStr([UserModel oauthToken])) {
            PWResetViewController *vc = [[PWResetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"study"]) {
        if (!SWNOTEmptyStr([UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
        vc.isChange = YES;
        vc.typeString = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"type"] isEqualToString:@"feedback"]) {
        if (!SWNOTEmptyStr([UserModel oauthToken])) {
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

@end
