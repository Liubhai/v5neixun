//
//  CircleListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CircleListVC.h"
#import "V5_Constant.h"
#import "CircleListCell.h"
#import "Net_Path.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"

@interface CircleListVC ()<UITableViewDelegate, UITableViewDataSource, CircleListCellDelegate, ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource> {
    NSInteger page;
    UIImageView *currentShowPicImageView;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *currentShowPicArray;

@end

@implementation CircleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleImage.hidden = YES;
    
    _dataSource = [NSMutableArray new];
    _currentShowPicArray = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    // Do any additional setup after loading the view.
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CircleListCell";
    CircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setCircleCellInfo:_dataSource[indexPath.row] circleType:_circleType];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    QuestionDetailListViewController *vc = [[QuestionDetailListViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_circleType)) {
        [param setObject:_circleType forKey:@"type"];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path circleListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            [_dataSource removeAllObjects];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                }
            }
            [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
            [_tableView reloadData];
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_circleType)) {
        [param setObject:_circleType forKey:@"type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path circleListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)showCirclePic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(nonnull UIImageView *)toImageView {
    currentShowPicImageView = toImageView;
    [_currentShowPicArray removeAllObjects];
    [_currentShowPicArray addObjectsFromArray:dict[@"attach_url"]];
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    pickerBrowser.editing = NO;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [pickerBrowser showPickerVc:window.rootViewController];
    });
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _currentShowPicArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:_currentShowPicArray[indexPath.row]];
//    NSString *imageURLStr;
//    // 如果没有原图，会拿到一个null字符串，注意是字符串
//    if (![self.originalImageArray[indexPath.row] isEqualToString:@"null"]) {
//        imageURLStr = self.originalImageArray[indexPath.row];
//    }
//    else{
//        imageURLStr = _webImageUrlStrArray[indexPath.row];
//    }
//    photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[NSURL URLWithString:imageURLStr]];
//    photo.toView = currentShowPicImageView;
    return photo;
}

// MARK: - 点赞按钮点击事件
- (void)likeCircleClick:(CircleListCell *)cell {
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    BOOL liked = [[NSString stringWithFormat:@"%@",cell.userCommentInfo[@"liked"]] boolValue];
    NSString *circleId = [NSString stringWithFormat:@"%@",cell.userCommentInfo[@"id"]];
    [Net_API requestPOSTWithURLStr:[Net_Path circleLikeNet] WithAuthorization:nil paramDic:@{@"type":_circleType,@"obj_id":circleId,@"status":(liked ? @"0" : @"1")} finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:responseObject[@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
//                cell.zanCountButton.selected = !liked;
                NSIndexPath *cellpath = [self.tableView indexPathForCell:cell];
                NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource[cellpath.row]];
                [pass setObject:liked ? @"0" : @"1" forKey:@"liked"];
                NSString *likeNum = [NSString stringWithFormat:@"%@",pass[@"like_num"]];
                [pass setObject:liked ? @([likeNum integerValue] - 1) : @([likeNum integerValue] + 1) forKey:@"like_num"];
                [_dataSource replaceObjectAtIndex:cellpath.row withObject:[NSDictionary dictionaryWithDictionary:pass]];
                [_tableView reloadRowAtIndexPath:cellpath withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"操作失败,请稍后再试"];
    }];
    
}

@end
