//
//  ExamCollectCellModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamCollectCellModel : NSObject

/*
 "id": 2,
 "topic_type": 1,
 "topic_id": 3,
 "wrong_count": 11,
 "answer_count": 13,
 "wrong_time": 1614740800,
 "topic_title": "<p>判断题</p>"
 */

@property (strong, nonatomic) NSString *errorId;//试题ID
@property (strong, nonatomic) NSString *topic_id;//试题ID
@property (strong, nonatomic) NSString *topic_type;// 试题类型
@property (strong, nonatomic) NSString *topic_title; // 试题题干
@property (strong, nonatomic) NSString *answer_count;// 总题数
@property (strong, nonatomic) NSString *wrong_count;// 正确作答题数
@property (strong, nonatomic) NSString *wrong_time; // 上次作答提交时间
@property (assign, nonatomic) BOOL selected; // 管理时候是否选中

@end

NS_ASSUME_NONNULL_END
