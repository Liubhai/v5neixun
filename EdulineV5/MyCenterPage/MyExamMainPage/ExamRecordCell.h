//
//  ExamRecordCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXamRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ExamRecordCell;

@protocol ExamRecordCellDelegate <NSObject>

@optional
- (void)examRecordManagerSelectButtonClick:(ExamRecordCell *)cell;

@end

@interface ExamRecordCell : UITableViewCell

@property (weak, nonatomic) id<ExamRecordCellDelegate> delegate;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *taojuanTitleLabel;
@property (strong, nonatomic) UILabel *allCountLabel;
@property (strong, nonatomic) UIView *fenggeLineView;
@property (strong, nonatomic) UILabel *rightCountLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *lineView;
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (strong, nonatomic) EXamRecordModel *courseModel;

- (void)setExamRecordRootManagerModel:(EXamRecordModel *)model indexpath:(NSIndexPath *)indexpath isPublic:(BOOL)isPublic;

@end

NS_ASSUME_NONNULL_END
