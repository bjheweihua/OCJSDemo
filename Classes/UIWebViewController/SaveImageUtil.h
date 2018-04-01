//
//  SaveImageUtil.h
//  OCJSDemo
//
//  Created by heweihua on 2018/3/8.
//  Copyright © 2018年 heweihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveImageUtil : NSObject

+ (BOOL)saveImg:(UIImage *)img imgName:(NSString *)imgName back:(void(^)(NSString *imgPath, NSString *imgSize, NSUInteger imgLength))back;

@end

