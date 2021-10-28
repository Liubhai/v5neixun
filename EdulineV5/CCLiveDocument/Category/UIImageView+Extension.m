//
//  UIImageView+Extension.m
//  CCLiveCloud
//
//  Created by Apple on 2020/11/4.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

#import "UIImageView+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Extension)

- (void)setHeader:(NSString *)url
{
    UIImage *placeholder = [UIImage imageNamed:@"lottery_icon_nor"];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? image : placeholder;
    }];
}

@end
