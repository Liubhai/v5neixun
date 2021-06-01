//
//  CircleDetailViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/31.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *circle_id;//圈子ID
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *detailInfo;// 顶部圈子详情内容
@property (strong, nonatomic) NSDictionary *commentInfo;// 整个详情接口数据(顶部和评论)
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
