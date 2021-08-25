//
//  ScoreListModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreListModel : NSObject

@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *num;
@property (assign, nonatomic) BOOL is_selected;
@property (assign, nonatomic) BOOL is_default;

@end

NS_ASSUME_NONNULL_END
