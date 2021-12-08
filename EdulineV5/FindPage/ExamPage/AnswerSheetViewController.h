//
//  AnswerSheetViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "ExamIDListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseOtherExam)(NSString *examId);

@interface AnswerSheetViewController : BaseViewController

@property (nonatomic, strong) chooseOtherExam chooseOtherExam;
@property (assign, nonatomic) BOOL isPaper; // yes 是试卷 no 是试题
@property (strong, nonatomic) NSMutableArray *examArray;// 整个试卷的题目id列表(列表里面的 has_answered 字段来判断是否作答)

@property (strong, nonatomic) NSString *sheetTitle;

@property (strong, nonatomic) NSString *module_title;// 考试主页板块儿名称

@property (strong, nonatomic) NSIndexPath *currentIndexpath;

@property (assign, nonatomic) NSInteger remainTime;// 如果有值 那么就需要计时器开启
@property (assign, nonatomic) BOOL orderType;// yes 正序计时 no 倒计时

@property (strong, nonatomic) NSString *examType;// 3 公开考试 4 套卷练习
@property (strong, nonatomic) NSString *rollup_id;// 套卷练习才会有这个

@property (strong, nonatomic) ExamPaperDetailModel *currentExamPaperDetailModel;
@property (strong, nonatomic) NSMutableArray *answerManagerArray;

@property (strong, nonatomic) NSString *courseId;

@property (assign, nonatomic) NSInteger popAlertCount;// 公开考试弹框次数

@end

NS_ASSUME_NONNULL_END
