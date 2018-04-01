//
//  WebViewController.m
//  OCJSDemo
//
//  Created by heweihua on 2018/3/8.
//  Copyright © 2018年 heweihua. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SaveImageUtil.h"// 这是保存图片的类


// JSDelegate js to native
@protocol JSDelegate <JSExport>

- (void)jsToNative:(id)params;// window.document.iosDelegate.jsToNative(JSON.stringify(params));

@end


@interface WebViewController ()
<
JSDelegate,
UIWebViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@property(strong, nonatomic) JSContext *jsContext;
@property(retain, nonatomic) UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView*)webView{
    
    if (!_webView){

        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _webView = [[UIWebView alloc] initWithFrame:rect];
        _webView.delegate = self;
    }
    return _webView;
}


#pragma mark UIWebViewDelegate 加载完成开始监听JS的方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"iosDelegate"] = self;//window.document.iosDelegate.getImage(JSON.stringify(parameter));
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
        context.exception = exception;
        NSLog(@"self.jsContext exception:%@",exception);
    };
}

#pragma mark -JSDelegate js to native
- (void)jsToNative:(id)params{

    NSString *json = [NSString stringWithFormat:@"%@", params];
    NSLog(@"js to native json: %@", json);
    NSDictionary *jsDict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil];
    NSInteger bussinesType = [jsDict[@"bussinesType"] integerValue];
    switch (bussinesType) {
        case 1:
        {
            // 主队列,异步打开相机
            dispatch_async(dispatch_get_main_queue(), ^{
                [self takePhoto];
            });
        }
            break;
            
        default:
            break;
    }
}

#pragma mark open camera
- (void) takePhoto{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark 点击相册取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 选择照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]){
        
        // get photos
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSLog(@"image size: %@", NSStringFromCGSize(image.size));
        [SaveImageUtil saveImg:image imgName:@"test.png" back:^(NSString *imgPath, NSString *imgSize, NSUInteger imgLength) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"imagePath：%@",imgPath);
                // native to js
                JSValue *jsValue = self.jsContext[@"setImageWithImagePath"];
                
                NSString* content = [NSString stringWithFormat:@"imgSize:%@; imgLength:%@k; imgPath:%@ %@",imgSize,@(imgLength/1024),imgPath,@"保存图片成功，图片路径传给JS,让HTML显示~"];
                [jsValue callWithArguments:@[@{@"imagePath":imgPath, @"content":content}]];
            });
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

@end









