//
//  QuestionChatRightCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionChatRightCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *contentBackView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) NSDictionary *chatInfo;

- (void)setQuestionChatRightInfo:(NSDictionary *)info;


@end

NS_ASSUME_NONNULL_END
