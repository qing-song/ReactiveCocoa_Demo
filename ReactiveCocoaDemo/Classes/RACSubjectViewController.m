//
//  RACSubjectViewController.m
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/23.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "RACSubjectViewController.h"
#import "RacSubjectSecondViewController.h"

@interface RACSubjectViewController ()

@end

@implementation RACSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  RACSubjec 使用方法：
    
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅信号：%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅信号：%@",x);
    }];
    
    [subject sendNext:@1];
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"RACReplaySubject    第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"RACReplaySubject    第二个订阅者接收到的数据%@",x);
    }];
    
    [replaySubject sendNext:@2];
}
- (IBAction)pushButTouchUpInside:(id)sender {
 
    RacSubjectSecondViewController *pushVC = [[RacSubjectSecondViewController alloc] init];
    pushVC.delegateSignal = [RACSubject subject];
    [pushVC.delegateSignal subscribeNext:^(id x) {
        
        NSLog(@"subscribeNext %@ ",x);
    }];
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
