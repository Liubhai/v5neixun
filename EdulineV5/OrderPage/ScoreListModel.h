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

@property (strong, nonatomic) NSString *scoreCount;
@property (strong, nonatomic) NSString *moneyCount;
@property (assign, nonatomic) BOOL is_selected;

@end

NS_ASSUME_NONNULL_END
