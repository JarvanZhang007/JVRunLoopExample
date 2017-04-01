//
//  JVTimerWithOberverViewController.m
//  JVRunLoopExample
//
//  Created by JarvanZhang on 2017/3/31.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

#import "JVTimerWithObserverViewController.h"

@interface JVTimerWithObserverViewController (){

    NSThread *_thread;
    CFRunLoopTimerRef timer;
}
@end

@implementation JVTimerWithObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (IBAction)start:(UIButton *)sender {
//    开启次线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        持有线程 为了在此线程执行代码
        _thread = [NSThread currentThread];
//        创建RunLoop  Apple 提供CFRunLoopGetCurrent
        CFRunLoopRef runLoop = CFRunLoopGetCurrent();
        /*上下文 第二个参数把自己传递过去 在 myCFTimerCallBack 里面的*info参数可获取到 */
        CFRunLoopTimerContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
//        初始化 timer myCFTimerCallBack为回调函数
        timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 1, 1, 0, 0,
                                                       &myCFTimerCallBack, &context);
//        添加到CommonModes
        CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
        
        /* Run Loop Observer Activities 中文注释 */
        NSDictionary *keyDict = @{
                                  @(kCFRunLoopEntry) : @"即将进入Loop",
                                  @(kCFRunLoopBeforeTimers) : @"即将处理 Timer",
                                  @(kCFRunLoopBeforeSources) : @"即将处理 Source",
                                  @(kCFRunLoopBeforeWaiting) : @"即将进入休眠",
                                  @(kCFRunLoopAfterWaiting) : @"刚从休眠中唤醒",
                                  @(kCFRunLoopExit) : @"即将退出Loop",
                                  };
        /*我们需要监控的状态 这里我们监控所有状态*/
        CFRunLoopActivity flags =
        kCFRunLoopEntry |
        kCFRunLoopBeforeTimers |
        kCFRunLoopBeforeSources |
        kCFRunLoopBeforeWaiting |
        kCFRunLoopAfterWaiting |
        kCFRunLoopExit |
        kCFRunLoopAllActivities;
        
//        为了美观分成2行
        CFRunLoopObserverRef runloopObserver;
        /*第一个参数一般都是kCFAllocatorDefault，
         第二个参数是我们要监控的状态
         第三个参数是否重复
         第四个优先级
         第五个是回调block
         */
       runloopObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                           flags,
                                           YES,
                                           0,
                                           ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                                               //通过key取出对应中文注释
                                            NSLog(@"RunLoop状态：%@", keyDict[@(activity)]);
                                           });
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), runloopObserver, kCFRunLoopCommonModes);
        CFRunLoopRun();
        
        /*RunLoop退出才会执行*/
        CFRelease(timer);
        NSLog(@"thread has stopped");
    });
    
}

- (IBAction)stop:(UIButton *)sender {
    

    [self performSelector:@selector(_stop)
                 onThread:_thread
               withObject:nil
            waitUntilDone:NO];
    
    _thread = nil;
    
}


-(void)_stop{

    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static void myCFTimerCallBack(CFRunLoopTimerRef timer, void *info){


    NSLog(@"hello %@",info);
    
}


-(void)dealloc{

    NSLog(@"dealloc");
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
