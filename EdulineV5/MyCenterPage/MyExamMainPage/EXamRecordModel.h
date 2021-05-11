//
//  EXamRecordModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EXamRecordModel : NSObject

/**
 "id": 1,
 "paper_id": 1,
 "unique_code": "6883c67c6babe7bd94ef51d8e857624d",
 "answer_times": 1,
 "time_takes": 1100,
 "commit_time": 1618826226,
 "answer_status": 0,
 "score": 0,
 "paper_title": "第一套试卷"
 */

@property (strong, nonatomic) NSString *topic_id;//排序Id
@property (strong, nonatomic) NSString *paper_id;//试题ID
@property (strong, nonatomic) NSString *user_score;//得分
@property (strong, nonatomic) NSString *paper_score;//试卷总分
@property (strong, nonatomic) NSString *answer_status;//阅卷状态【0：提交答案；1：客观题已阅卷；2：主观题已阅卷，完成阅卷】
@property (strong, nonatomic) NSString *paper_title; // 试题题干
@property (strong, nonatomic) NSString *rollup_title; // 套卷名称
@property (strong, nonatomic) NSString *commit_time;// 提交时间
@property (strong, nonatomic) NSString *time_takes;// 考试用时/秒
@property (strong, nonatomic) NSString *answer_times; // 参考次数
@property (strong, nonatomic) NSString *unique_code; // 上次作答提交时间

@property (strong, nonatomic) NSString *answer_count;// 总题数
@property (strong, nonatomic) NSString *right_count;// 正确作答题数

@end

NS_ASSUME_NONNULL_END
