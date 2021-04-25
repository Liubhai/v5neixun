//
//  ExamResultSheetViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/25.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "ExamIDListModel.h"
#import "ExamSheetModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^resultPageChooseOtherExam)(ExamModel *model);

@interface ExamResultSheetViewController : BaseViewController

@property (nonatomic, strong) resultPageChooseOtherExam chooseOtherExam;
@property (assign, nonatomic) BOOL isPaper; // yes 是试卷 no 是试题
@property (strong, nonatomic) NSMutableArray *examArray;// 整个试卷的题目id列表(列表里面的 has_answered 字段来判断是否作答)

@property (strong, nonatomic) NSString *sheetTitle;

@property (strong, nonatomic) NSString *module_title;// 考试主页板块儿名称

@property (strong, nonatomic) NSIndexPath *currentIndexpath;

@property (assign, nonatomic) NSInteger remainTime;// 如果有值 那么就需要计时器开启
@property (assign, nonatomic) BOOL orderType;// yes 正序计时 no 倒计时

@property (strong, nonatomic) ExamResultDetailModel *currentExamPaperDetailModel;
@property (strong, nonatomic) NSMutableArray *answerManagerArray;

@end

NS_ASSUME_NONNULL_END
