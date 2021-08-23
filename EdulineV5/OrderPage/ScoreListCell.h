//
//  ScoreListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ScoreListCell;

@protocol scoreListCellDelegate <NSObject>

- (void)scoreChoose:(ScoreListCell *)scoreCell;

@end

@interface ScoreListCell : UITableViewCell

@property (assign, nonatomic) id<scoreListCellDelegate> delegate;
@property (strong, nonatomic) UILabel *scoreTitle;
@property (strong, nonatomic) UILabel *scoreIntro;
@property (strong, nonatomic) UIButton *scoreChooseButton;
@property (strong, nonatomic) NSIndexPath *cellIndexpath;
@property (strong, nonatomic) ScoreListModel *currentScoreModel;

- (void)setScoreCellInfo:(ScoreListModel *)scoreModel cellIndexPath:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
