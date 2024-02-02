//
//  AddressModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/27.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  AddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<AddressModel *> *children;

@end

NS_ASSUME_NONNULL_END
