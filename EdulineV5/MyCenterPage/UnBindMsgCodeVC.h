//
//  UnBindMsgCodeVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/9/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnBindMsgCodeVC : BaseViewController

//unbundling_weixin：解绑第三方微信；unbundling_qq：解绑第三方QQ；unbundling_sina：解绑第三方新浪
@property (strong, nonatomic) NSString *unbindType;
@property (strong, nonatomic) NSString *unbindParamString;// 类型传值

@end

NS_ASSUME_NONNULL_END
