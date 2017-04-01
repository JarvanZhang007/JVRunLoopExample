//
//  JVcontrastViewController.m
//  JVRunLoopExample
//
//  Created by JarvanZhang on 2017/3/31.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

#import "JVcontrastViewController.h"

@interface JVcontrastViewController ()

@end

@implementation JVcontrastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainRunLoopTest:(UIButton *)sender {

        NSLog(@"主线程RunLoop测试");
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    //当前runLoop 一直睡眠 直到被唤醒
    [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    主线程有监听等，比如点击等等  将会唤醒   唤醒后打印
    NSLog(@"主线程RunLoop被唤醒接着跑");
}



- (IBAction)otherRunLoopTest:(id)sender {
    NSLog(@"次线程RunLoop测试");
    __block  NSUInteger count=0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        我们打印5次方便查看
        while (count<5) {
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            //当前runLoop 一直睡眠 直到被唤醒
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//             RunLoop 必须要有至少一个 Timer/Observer/Source 否则 runloop直接退出 直接打印
            NSLog(@"次线程没有被暂停");
            count++;
        }
    });    
}

- (IBAction)testClick:(UIButton *)sender {
    NSLog(@"你点击了");
}

@end
