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

@property (strong, nonatomic) NSString *topic_id;//试题ID
@property (strong, nonatomic) NSString *qustion_type;// 试题类型
@property (strong, nonatomic) NSString *title; // 试题题干
@property (strong, nonatomic) NSString *allCount;// 总题数
@property (strong, nonatomic) NSString *rightCount;// 正确作答题数
@property (strong, nonatomic) NSString *examTime; // 上次作答提交时间
@property (assign, nonatomic) BOOL selected; // 管理时候是否选中

@end

NS_ASSUME_NONNULL_END
