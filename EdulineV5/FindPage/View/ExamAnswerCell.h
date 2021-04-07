//
//  ExamAnswerCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/8.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamIDListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ExamAnswerCell;

@protocol ExamAnswerCellDelegate <NSObject>

@optional
/** 填空输入 */
- (void)inputTextFieldSure:(ExamDetailModel *)cellDetailModel cellOptionModel:(ExamDetailOptionsModel *)cellOptionModel answerCell:(ExamAnswerCell *)answerCell;
/** 完形填空选择 */
- (void)gapfillingChooseStatusChanged:(ExamAnswerCell *)answerCell button:(UIButton *)sender;

@end

@interface ExamAnswerCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (assign, nonatomic) id<ExamAnswerCellDelegate> delegate;

@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UIButton *mutSelectButton;
@property (strong, nonatomic) UILabel *keyTitle;
@property (strong, nonatomic) UITextView *valueTextView;

@property (strong, nonatomic) UITextView *userInputTextView;//用户输入内容(解答题)

@property (strong, nonatomic) UILabel *gapfillingIndexTitle;
@property (strong, nonatomic) UITextField *userInputTextField;//用户输入内容(填空题)

@property (strong, nonatomic) UIView *clozeBackView;// 完形填空容器
@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property (strong, nonatomic) ExamDetailModel *cellDetailModel;//当前cell对应的试题详情
@property (strong, nonatomic) ExamDetailModel *examDetailModel;//当前完形填空或者材料题cell对应的试题详情
@property (strong, nonatomic) ExamDetailOptionsModel *cellOptionModel;//当前cell对应的选项详情
@property (assign, nonatomic) BOOL examModuleType; // 区分是否能操作主观题(填空 解答题 能否输入)

- (void)setAnswerInfo:(ExamDetailOptionsModel *)model mainExamDetail:(ExamDetailModel *)mainExamDetail  examDetail:(ExamDetailModel *)detailModel cellIndex:(NSIndexPath *)cellIndexPath;

/** 针对完形填空 */
- (void)setExamDetail:(ExamDetailModel *)detailModel cellModel:(ExamDetailModel *)cellModel cellIndex:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
