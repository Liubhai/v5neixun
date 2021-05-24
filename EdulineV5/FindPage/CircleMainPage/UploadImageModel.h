//
//  UploadImageModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/24.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadImageModel : NSObject

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSString *imageId;
@property (strong, nonatomic) NSString *imageIndex;

@end

NS_ASSUME_NONNULL_END
