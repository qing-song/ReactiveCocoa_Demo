//
//  TextFieldViewController.m
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/19.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation TextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // filter ：过滤器 将信号进行过滤，从而得到我们想要的信号。   subscribeNext ：订阅信号。
    // **只有订阅了的信号，信号流才会起作用。**

    /*
    [[self.nameTextField.rac_textSignal filter:^BOOL(id value) {
     
        NSString *text = value;
        return text.length > 3;
     
    }] subscribeNext:^(id x) {
     
        NSLog(@"x   %@",x);
    }];
     */
    
    // 这个是将上面的信号管道进行拆分
    
     // 1. 先获取  self.usernameTextField.rac_textSignal 信号

    RACSignal *usernameSourceSignal =
    self.nameTextField.rac_textSignal;
    // 2. 在过滤信号
    
    RACSignal *filteredUsername =[usernameSourceSignal
                                  filter:^BOOL(id value){
                                      
                                      NSString*text = value;
                                      
                                      return text.length > 3;
                                      
                                  }];
    
    // 3. 订阅信号
    [filteredUsername subscribeNext:^(id x){
        
        NSLog(@"%@", x);
    }];
    
    
    
    
    // 字符长短
    /*
     
    [[[self.nameTextField.rac_textSignal map:^id(NSString *value) {
        
        return @(value.length);
        
    }] filter:^BOOL(NSNumber *length) {
        
        return [length integerValue] > 3;
        
    }] subscribeNext:^(id x) {
     
        NSLog(@"x   %@",x);
    }];
     
    */
    
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
