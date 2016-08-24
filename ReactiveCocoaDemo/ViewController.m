//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/16.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *subDatasource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.datasource = @[@"Control",
                        @"UITextField",
                        @"RACSubject",
                        @"RACSequence和RACTuple简单使用",
                        @"RACCommand简单使用",].mutableCopy;
    
    self.subDatasource = @[@"ControlViewController",
                           @"TextFieldViewController",
                           @"RACSubjectViewController",
                           @"RACSequenceViewController",
                           @"RACCommandViewController"].mutableCopy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = _subDatasource[indexPath.row];
    Class pushClass = NSClassFromString(className);
    if (!pushClass) {
        return;
    }
    UIViewController *VC = pushClass.new;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
