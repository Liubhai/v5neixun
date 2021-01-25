//
//  ExamPointModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/25.
//  Copyright © 2021 刘邦海. All rights reserved.
//

// 知识点分类列表 Model
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ExamPointModel;

@interface ExamPointModel : NSObject

@property (strong, nonatomic) NSString *cateGoryId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *child;
@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL isExpend;

@end

NS_ASSUME_NONNULL_END
