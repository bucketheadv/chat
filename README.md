# 基于Rails5的消息应用

## 技术选型

本次需要实现的功能列表为：
- 这是一个 web app
- 用户之间可以收、发私信
- 可以查看自己的私信联系人列表
- 私信列表中显示对方 ID 以及未读数量提醒
- 用户可以删除某个私信会话记录，但保留与对方用户的消息数据
- 用户可以删除私信会话中的自己发的消息
- 新消息实时提醒

从最后一点来看，可以实现的Ruby框架选型可以为`volt`框架。但`Rails5`集成了`actioncable`也能很容易实现，而`rails`开发更方便熟练，因此技术选型`rails`最佳。

从其他需求来看，需要实现的基本上都是普通的`CURD`请求，只有`会话`一项需要做成实时响应的。那么只需要定义一个`websocket` server，在打开`会话`页面时，连接上这个`websocket` server即可。

## 模型与关联

首先，必须要有User对象，用于存储用户个人信息和处理登录。用户之间发送的消息是发件人和收件人都能看到的，但是两个人看到的是同一条完全一样的信息，因此一条信息同时属于两个用户，一个sender和一个receiver，分别是一个User对象。但是用户每条信息都有一个是否已读的标识，因此Message需要与receiver之间有一个关联，用MessageStatus模型来表示这个关联，而sender不需要与Message关联，因为sender对于这条Message必然是已读的。

如果仅仅是Message和User关联，那么无法做到用户删除自己的对话时，对方的对话信息依然存在；因此需要一个Conversation对象，表示一个对话，这个对话是同时属于两个用户sender和receiver的，因此是一个多对多的关系，于是使用UserConversationRelation来表示这个关系，一个sender与一个receiver之间拥有一个唯一的UserConversationRelation对象，当一个用户要删除某个对话时，即是删除这个对象，不影响对方的此次对话。

同时，用户与好友之间才能进行对话，好友关系是多对多，使用FriendRelation来表示，当一个用户A添加一个好友B时，B的好友列表里也要同时加上A。属于User与User之间的多对多关联。

通过以上设计，得出以下模型数据：

- User， 用于表示用户数据
- FriendRelation， 朋友关系数据，通过 friend_relations表实现user与user之间的朋友关系关联（多对多的关系）
- Conversation， 会话，一个会话包含了多条消息（一对多），一个用户可以拥有多个会话，一个会话必属于两个用户
- Message， 消息，必属于一个会话，并且拥有一个发送者(User)与一个接收者(User)
- MessageStatus，消息状态，拥有一个接收者，属于一个消息，保存该接收者是否已读该条消息
- UserConversationRelation，用户与会话的关联，一个会话必属于两个用户(User)，这两个用户同时为发送者和接收者

## 关于测试

由于时间问题，本次只编写了`model`的单元测试，也没有做分页，但基本上每一个方法都包含了一个单元测试。在目录下执行以下命令跑测试：

```ruby
bundle exec rspec spec
```

## 关于部署

原本已经部署了一份在阿里云上，但`CentOS`上跑`rails5`，死活不能启动`ActionCable`进程，导致无法实时通信，尚未找出原因，因此附上部署步骤，由于`production`环境需要跑`rake assets:precompile`、配置`Nginx`以及其他一些繁琐的操作，容易疏漏出现问题，因此看效果建议在`development`环境。

```ruby
git clone https://github.com/sven199109/chat
cd chat
bundle install
rake db:create && rake db:migrate
```

然后请配置`shell`环境变量，在`~/.zshrc`(或`~/.bashrc`等其他shell)中，配置以下环境变量(配置完成后执行命令`source ~/.zshrc` 或其他shrc文件)：

```ruby
export MYSQL_DATABASE_SOCKET=/var/lib/mysql/mysql.sock # 如果是Mac，此项为'/tmp/mysql.sock'；如果是ubuntu，则为'/var/run/mysqld/mysqld.sock'
export CHAT_DATABASE_USERNAME=root # MySQL 用户名
export CHAT_DATABASE_PASSWORD=     # MySQL 密码
export SECRET_KEY_BASE=33ba417314ae1a25031cdf8dfd35fe09dee26d4be0cee4c94894e5459d5c61f53f7d122a1dc208aa5af77c7a6886052fe20831ae45a70226f7c305dc4c7bf7d7 # cookie加密用的值，是自定义的，production环境才需要
```

此外还依赖`node.js`运行时，可通过`nvm`进行安装；`Redis`服务也是必须的。安装完成后，运行`rails s`即可查看效果。
