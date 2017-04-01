//
//  JVControlRunLoopViewController.m
//  JVRunLoopExample
//
//  Created by JarvanZhang on 2017/3/31.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

#import "JVControlRunLoopViewController.h"

@interface JVControlRunLoopViewController ()

@end

@implementation JVControlRunLoopViewController
{
    CFRunLoopSourceRef source;
    NSThread *_thread;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


static void DoNothingRunLoopCallback(void *info)
{
    
    NSLog(@"do something");
}


- (IBAction)createRunLoopInNewThread:(UIButton *)sender {
    //开启子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        存储下这个线程
        _thread = [NSThread currentThread];
        [self creatRunLoop];
    });
}


-(void)creatRunLoop{
    NSLog(@"create RunLoop");
    @autoreleasepool {
        //source上下文
        CFRunLoopSourceContext context = {0};
        //指定事件回调
        context.perform = DoNothingRunLoopCallback;
        //        为source添加事件
        source = CFRunLoopSourceCreate(NULL, 0, &context);
        // source添加到RunLoop
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
        //监听事件直到RunLoop停止
        CFRunLoopRun();
        
        //停止RunLoop的时候 移除source
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
        CFRelease(source);
        NSLog(@"RunLoop has stopped");
    }
}


- (IBAction)wakeUpRunLoop:(id)sender {
    
    [self performSelector:@selector(wakeUP)
                 onThread:_thread
               withObject:nil
            waitUntilDone:NO];
}

-(void)wakeUP{
    
    CFRunLoopSourceSignal(source);
    
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}


- (IBAction)stopRunLoop:(UIButton *)sender {
    
    [self performSelector:@selector(stop)
                 onThread:_thread
               withObject:nil
            waitUntilDone:NO];
    _thread = nil;
    NSLog(@"thread should have stopped");
}


-(void)stop{
    CFRunLoopStop(CFRunLoopGetCurrent());
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
