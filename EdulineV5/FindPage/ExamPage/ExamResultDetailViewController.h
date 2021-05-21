//
//  ExamResultDetailViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/25.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "ExamSheetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamResultDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *examType;
@property (strong, nonatomic) NSString *examIds;
@property (strong, nonatomic) NSDictionary *paperInfo;// 试卷信息
@property (strong, nonatomic) ExamModel *currentResultModel;// 从结果页点击某个题跳转到这个解析页面
@property (assign, nonatomic) BOOL isErrorAnalysis;// 是不是错题解析
@property (strong, nonatomic) NSString *answer_status;// 阅卷状态【0：提交答案；1：客观题已阅卷；2：主观题已阅卷，完成阅卷】

@end

NS_ASSUME_NONNULL_END
