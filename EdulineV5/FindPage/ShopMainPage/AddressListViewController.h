//
//  AddressListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/25.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^addressInfoSelected)(NSDictionary *addressInfo);

@interface AddressListViewController : BaseViewController

@property (nonatomic, copy) addressInfoSelected addressSelect;

@property (assign, nonatomic) BOOL fromCenter;// 设置里面过来的

@end

NS_ASSUME_NONNULL_END
