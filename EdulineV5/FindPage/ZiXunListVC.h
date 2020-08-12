//
//  ZiXunListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZiXunListVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSString *mhm_id;//机构id

@end

NS_ASSUME_NONNULL_END
