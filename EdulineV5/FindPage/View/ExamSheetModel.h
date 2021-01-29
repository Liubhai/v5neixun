//
//  ExamSheetModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/29.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ExamSheetModel, ExamModel;

@interface ExamSheetModel : NSObject

@property (strong, nonatomic) NSString *question_type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray<ExamModel *> *child;

@end

@interface ExamModel : NSObject

@property (strong, nonatomic) NSString *exam_id;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL selected;

@end

NS_ASSUME_NONNULL_END
