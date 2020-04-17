//
//  CourseCommentViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCommentViewController : BaseViewController

@property (assign, nonatomic) BOOL isComment;// yes 评论 no 笔记
@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSDictionary *originCommentInfo;

@end

NS_ASSUME_NONNULL_END
