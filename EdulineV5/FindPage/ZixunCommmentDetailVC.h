//
//  ZixunCommmentDetailVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZixunCommmentDetailVC : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *commentInfo;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL cellType;// yes 是点评 no 是笔记

@property (strong, nonatomic) NSDictionary *topCellInfo;// 外部传入的数据
@property (strong, nonatomic) NSString *commentId;

@end

NS_ASSUME_NONNULL_END
