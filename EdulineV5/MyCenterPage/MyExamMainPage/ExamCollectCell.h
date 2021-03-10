//
//  ExamCollectCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamCollectCellModel.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@class ExamCollectCell;

@protocol ExamCollectCellDelegate <NSObject>

@optional
- (void)examCollectManagerSelectButtonClick:(ExamCollectCell *)cell;

@end

@interface ExamCollectCell : UITableViewCell

@property (weak, nonatomic) id<ExamCollectCellDelegate> delegate;
@property (strong, nonatomic) UIButton *selectedIconBtn;
@property (strong, nonatomic) UIImageView *examTypeImageView;
@property (strong, nonatomic) TYAttributedLabel *titleLabel;

@property (strong, nonatomic) UILabel *allCountLabel;
@property (strong, nonatomic) UIView *fenggeLineView;
@property (strong, nonatomic) UILabel *rightCountLabel;

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (strong, nonatomic) ExamCollectCellModel *courseModel;

- (void)setExamCollectRootManagerModel:(ExamCollectCellModel *)model indexpath:(NSIndexPath *)indexpath showSelect:(BOOL)showSelect;

- (void)setExamErorModel:(ExamCollectCellModel *)model indexpath:(NSIndexPath *)indexpath;

@end

NS_ASSUME_NONNULL_END
