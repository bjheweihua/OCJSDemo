//
//  SaveImageUtil.m
//  OCJSDemo
//
//  Created by heweihua on 2018/3/8.
//  Copyright © 2018年 heweihua. All rights reserved.
//

#import "SaveImageUtil.h"


@implementation SaveImageUtil

#pragma mark  保存图片到document
+ (BOOL)saveImg:(UIImage *)img imgName:(NSString *)imgName back:(void(^)(NSString *imgPath, NSString *imgSize, NSUInteger imgLength))back{
    
    NSString *path = [SaveImageUtil getDocumentFolderImagePath];
    NSData *imgData = UIImagePNGRepresentation(img);
    NSLog(@"image data length: %@", @(imgData.length));
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/", path];
    // Now we get the full path to the file
    NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:imgName];
    // and then we write it out
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件路径存在的话
    BOOL bExists = [fileManager fileExistsAtPath:imageFile];
    if (bExists){
        
        NSLog(@"文件已存在");
        if ([fileManager removeItemAtPath:imageFile error:nil]){
            
            NSLog(@"删除文件成功");
            if ([imgData writeToFile:imageFile atomically:YES]){
                
                NSLog(@"保存文件成功");
                back(imageFile, NSStringFromCGSize(img.size), imgData.length);
            }
        }
        else
        {}
    }
    else{
        
        if (![imgData writeToFile:imageFile atomically:NO]){
            
            [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            if ([imgData writeToFile:imageFile atomically:YES]){
                back(imageFile, NSStringFromCGSize(img.size), imgData.length);
            }
        }
        else{
            return YES;
        }
    }
    return NO;
}



#pragma mark  从文档目录下获取Documents路径
+ (NSString *)getDocumentFolderImagePath{
    
    NSString *document_patch = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSString stringWithFormat:@"%@/imgs", document_patch];
}


@end






