//
//  ShopDetailViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *shopId;
@property (strong ,nonatomic)NSDictionary   *dataSource;

@property (assign, nonatomic) BOOL canScroll;

/** 视频播放了之后整个外部tableview就不允许滚动了 */
@property (assign, nonatomic) BOOL canScrollAfterVideoPlay;

@end

NS_ASSUME_NONNULL_END
