//
//  StudyLatestCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudyLatestCell : UITableViewCell

@property (strong, nonatomic) UIScrollView *mainScrollView;

- (void)setLatestLearnInfo:(NSArray *)learnArray;

@end

NS_ASSUME_NONNULL_END
