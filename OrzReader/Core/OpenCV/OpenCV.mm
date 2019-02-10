//
//  UIImage+OpenCV.m
//  jokerHub
//
//  Created by joker on 2019/1/3.
//  Copyright © 2019 joker. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import "OpenCV.h"
#import <iostream>

using namespace std;
using namespace cv;

@implementation OpenCV
+ (UIImage *)processImage:(UIImage *)image
{
    Mat input = [OpenCV cvMatFromUIImage:image];
    Mat gray;
    cvtColor(input, gray, COLOR_BGR2GRAY);
    Mat binary;
    threshold(gray, binary, 250, 255, THRESH_BINARY_INV);
    
    int left = 0;
    bool leftFound = NO;
    for(int j = left; j <= binary.cols / 2; j++) {
        for(int i = 0; i < binary.rows; i++) {
            if(binary.at<uchar>(i,j) > 0) {
                left = j;
                leftFound = YES;
                break;
            }
        }
        if(leftFound) break;
    }
    
    int right = binary.cols - 1;
    bool rightFound = NO;
    for(int j = right; j >= binary.cols / 2; j--) {
        for(int i = 0; i < binary.rows; i++) {
            if(binary.at<uchar>(i,j) > 0) {
                right = j;
                rightFound = YES;
                break;
            }
        }
        if(rightFound) break;
    }

    return [OpenCV UIImageFromCVMat:binary];
}

+ (CGFloat)contentWidthRatioOfImage: (UIImage *)image
{
    CGFloat ret = 1.0;
    
    Mat input = [OpenCV cvMatFromUIImage:image];
    Mat gray;
    cvtColor(input, gray, COLOR_BGR2GRAY);
    Mat binary;
    threshold(gray, binary, 250, 255, THRESH_BINARY_INV);
    
    int left = 0;
    bool leftFound = NO;
    for(int j = left; j <= binary.cols / 2; j++) {
        for(int i = 0; i < binary.rows; i++) {
            if(binary.at<uchar>(i,j) > 0) {
                left = j;
                leftFound = YES;
                break;
            }
        }
        if(leftFound) break;
    }
    
    int right = binary.cols - 1;
    bool rightFound = NO;
    for(int j = right; j >= binary.cols / 2; j--) {
        for(int i = 0; i < binary.rows; i++) {
            if(binary.at<uchar>(i,j) > 0) {
                right = j;
                rightFound = YES;
                break;
            }
        }
        if(rightFound) break;
    }
    
    if(right - left > 0){
        ret = (right - left) / image.size.width;
    }
    
    return ret;
}

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}
@end
