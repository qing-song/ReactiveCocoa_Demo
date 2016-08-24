//
//  RacSubjectSecondViewController.m
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/23.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "RacSubjectSecondViewController.h"

@interface RacSubjectSecondViewController ()

@end

@implementation RacSubjectSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)subjectButTouchUpInside:(UIButton *)sender {
    
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@"🙄"];
    }
    
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
