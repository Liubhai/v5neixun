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

@end

NS_ASSUME_NONNULL_END
