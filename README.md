# 学习使用函数响应式编程框架（FRP）
## 1.ReactiveCocoa简介
ReactiveCocoa（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的新框架,Cocoa是苹果整套框架的简称，因此很多苹果框架喜欢以Cocoa结尾。

## 为什么我们要学习使用RAC？
为了提高我们的开发效率。RAC在某些`特定情况`下开发时可以大大简化代码，并且目前来看安全可靠。

## ReactiveCocoa作用
-  在我们iOS开发过程中，当某些事件响应的时候，需要处理某些业务逻辑,这些事件都用不同的方式来处理。
-  比如按钮的点击使用action，ScrollView滚动使用delegate，属性值改变使用KVO等系统提供的方式。
-  其实这些事件，都可以通过RAC处理。
-  ReactiveCocoa为事件提供了很多处理方法，而且利用RAC处理事件很方便，可以把要处理的事情，和监听的事情的代码放在一起，这样非常方便我们管理，就不需要跳到对应的方法里。非常符合我们开发中`高聚合，低耦合`的思想。


## ReactiveCocoa常见类
在RAC中最核心的类`RACSiganl`
`RACSiganl`:信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
> - 信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
> - 默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
> - 如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。

RACSiganl简单使用:
``` python
// RACSignal使用步骤：
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 - (void)sendNext:(id)value


// RACSignal底层实现：
// 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
// 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
// 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
// 2.1 subscribeNext内部会调用siganl的didSubscribe
// 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
// 3.1 sendNext底层其实就是执行subscriber的nextBlock

// 1.创建信号
RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

// block调用时刻：每当有订阅者订阅信号，就会调用block。

// 2.发送信号
[subscriber sendNext:@1];

// 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
[subscriber sendCompleted];

return [RACDisposable disposableWithBlock:^{

// block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。

// 执行完Block后，当前信号就不在被订阅了。

NSLog(@"信号被销毁");

}];
}];

// 3.订阅信号,才会激活信号.
[siganl subscribeNext:^(id x) {
// block调用时刻：每当有信号发出数据，就会调用block.
NSLog(@"接收到数据:%@",x);
}];
```

## ReactiveCocoa开发技巧：
1. 监听了textFild的UIControlEventEditingChanged事件，当事件发生时实现方法NSLog：
`PS`：举一反三，以后的UIButton点击事件我们都可以用RAC方法进行添加，再也不用add Target了。
```python
[[self.textFild rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x){
NSLog(@"change");
}];
```
对于textFild的文字更改监听也有更简单的写法，每次改变TextFild都输出改变后的结果：
```python
[[self.textFild rac_textSignal] subscribeNext:^(id x) {
NSLog(@"%@",x);
}];
```

2. 添加手势：
```python
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
[[tap rac_gestureSignal] subscribeNext:^(id x) {
NSLog(@"tap");
}];
[self.view addGestureRecognizer:tap];
```
3. 代理：
`PS`:*用RAC写代理是有局限的，它只能实现返回值为void的代理方法*
```python
UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"RAC TEST" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
[[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
NSLog(@"%@",tuple.first);
NSLog(@"%@",tuple.second);
NSLog(@"%@",tuple.third);
}];
[alertView show];
```
AlertView代理也有简化的代码：
PS: 这里的x就是各个Button的序号
```python
[[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
NSLog(@"%@",x);
}];
```
4. 通知：
`PS`：**RAC中的通知不需要remove observer**，因为在rac_add方法中他已经写了remove
```python
// 发送通知
NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
[[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataAr

// 接收通知
[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification *notification) {
NSLog(@"%@", notification.name);
NSLog(@"%@", notification.object);
}];
```

## 快速上手ReactiveCocoa
- [唐巧的技术客](http://blog.devtang.com/2014/02/11/reactivecocoa-introduction/)
- [适合给新手看的RAC用法总结](http://www.jianshu.com/p/ff79a5ae0353)
- [袁峥Seemygo](http://www.jianshu.com/p/87ef6720a096)
- [伯乐在线](http://ios.jobbole.com/82356/)
- [青玉伏案的博客](http://www.cnblogs.com/ludashi/p/4925042.html)
- [CocoaChina](http://www.cocoachina.com/ios/20140609/8737.html) 
