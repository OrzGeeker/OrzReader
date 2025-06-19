//
//  OpenCV.h
//  jokerHub
//
//  Created by joker on 2019/1/3.
//  Copyright © 2019 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCV: NSObject
+ (CGFloat)contentWidthRatioOfImage: (UIImage *)image;
+ (UIImage *)processImage:(UIImage *)image;
@end
