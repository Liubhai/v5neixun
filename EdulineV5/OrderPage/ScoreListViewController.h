//
//  ScoreListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "ScoreListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScoreListViewControllerDelegate <NSObject>

- (void)scoreChooseModel:(ScoreListModel *)model;

@end

@interface ScoreListViewController : BaseViewController

@property (weak, nonatomic) id<ScoreListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *changeStatusArray;
@property (strong, nonatomic) ScoreListModel *currentSelectModel;// 当前已经选择的model

@end

NS_ASSUME_NONNULL_END
