//
//  RACSequenceViewController.m
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/23.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "RACSequenceViewController.h"

@interface RACSequenceViewController ()

@end

@implementation RACSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *array = @[@"hello", @"qing", @"song", @1, @2, @3];
    [array.rac_sequence.signal subscribeNext:^(id x) {
       
        NSLog(@"遍历：%@",x);
    }];
    
    // RACTuple(元组对象)
    
    NSDictionary * informationDict = @{@"name" : @"qingsong",
                                       @"age"  : @25,
                                       @"from" : @"China"};
    [informationDict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        RACTupleUnpack(NSString *key, NSString *value) = x;
        
        NSLog(@"NSDictionary    %@  %@",key,value);
    }];

    
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
