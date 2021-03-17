//
//  ExamCalculateHeight.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamIDListModel.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamCalculateHeight : NSObject

@property (strong, nonatomic) ExamDetailModel *examAnswerCellExamDetailModel;
@property (strong, nonatomic) ExamDetailModel *gapfillingExamDetailModel;
@property (strong, nonatomic) ExamDetailOptionsModel *examAnswerCellOpitionModel;

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithExamDetailModel:(ExamDetailModel *)model opitionModel:(ExamDetailOptionsModel *)opModel;

/** 完形填空 */
- (instancetype)initWithGapfillingExamDetailModel:(ExamDetailModel *)gapfillingModel examDetailModel:(ExamDetailModel *)model opitionModel:(ExamDetailOptionsModel *)opModel;


@end

NS_ASSUME_NONNULL_END
