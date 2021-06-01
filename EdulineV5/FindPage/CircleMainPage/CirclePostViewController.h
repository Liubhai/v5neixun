//
//  CirclePostViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CirclePostViewController : BaseViewController

@property (assign, nonatomic) BOOL isForward;// 是否是转发
@property (strong, nonatomic) NSDictionary *forwardInfo;// 圈子列表传递的内容
@property (strong, nonatomic) NSDictionary *forwardRealInfo;// 转发圈子的渲染内容


@property (assign, nonatomic) BOOL isComment;// 是单纯评论
@property (strong, nonatomic) NSDictionary *commentCircleInfo;// 要评论的圈子内容

@property (assign, nonatomic) BOOL isReplayComment;// 是回复评论
@property (strong, nonatomic) NSDictionary *replayCommentInfo;// 要回复的评论内容

@end

NS_ASSUME_NONNULL_END
