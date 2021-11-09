//
//  UIImage+yunImage.m
//  CCClassRoom
//
//  Created by Chenfy on 2021/9/24.
//  Copyright © 2021 cc. All rights reserved.
//

#import "UIImage+yunImage.h"

@implementation UIImage (yunImage)

+ (UIImage *)yun_imageNamed:(NSString *)imageName {
    NSString *imgPath = [YUNLanguage hds_imagePath:imageName];
    NSLog(@"yun--<%@>--:%@",imageName,imgPath);
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    
    return img;
}

@end
