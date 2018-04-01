//
//  MainViewController.m
//  OCJSDemo
//
//  Created by heweihua on 2018/3/28.
//  Copyright © 2018年 heweihua. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat pointx = (CGRectGetWidth(self.view.frame) - 200)/2;
    [button setFrame:CGRectMake(pointx, 200, 200, 50)];
    [button setBackgroundColor:[UIColor purpleColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 JS同原生交互
 JS获取原生照片, 通过照片流(UIImage base64编码)给JS, 如果图片数据量比较大, 必然会导致原生跟H5的通信卡顿, 延迟问题;
 解决方案:
 把图片数据保存到本地, 通过图片路径传递给H5, h5通过路径读取;
 */
-(void) buttonAction{
    
    WebViewController* web = [[WebViewController alloc] init];
    [self.navigationController pushViewController:web animated:YES];
}

@end



