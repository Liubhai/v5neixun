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
@property (strong, nonatomic) NSDictionary *detailInfo;
@property (strong, nonatomic) NSDictionary *commentInfo;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
