//
//  LiveRoomPersonCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TICRenderView.h"
#import "TICManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveRoomPersonCell : UICollectionViewCell

//@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) TICRenderView *render;
@property (strong, nonatomic) UILabel *nameLabel;

- (void)setLiveUserInfo:(NSString *)userid localUserId:(NSString *)localUserId;

@end

NS_ASSUME_NONNULL_END
