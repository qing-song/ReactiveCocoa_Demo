# 学习使用函数响应式编程框架（FRP）
## 1.ReactiveCocoa简介
ReactiveCocoa（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的新框架,Cocoa是苹果整套框架的简称，因此很多苹果框架喜欢以Cocoa结尾。

## ReactiveCocoa作用
-  在我们iOS开发过程中，当某些事件响应的时候，需要处理某些业务逻辑,这些事件都用不同的方式来处理。
-  比如按钮的点击使用action，ScrollView滚动使用delegate，属性值改变使用KVO等系统提供的方式。
-  其实这些事件，都可以通过RAC处理
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

## 上手ReactiveCocoa
袁峥Seemygo：http://www.jianshu.com/p/87ef6720a096

唐巧的技术客：http://blog.devtang.com/2014/02/11/reactivecocoa-introduction/
