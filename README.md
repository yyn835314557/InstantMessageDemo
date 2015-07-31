# Swift1.2 iPhone6 微信

使用方法:
* `git clone https://github.com/yyn835314557/InstantMessageDemo.git` 有点大耐心点。
* 打开里面的Resource文件夹里面有([Adium_1.5.10.dmg](Resource/),[ejabberd-14.12](Resource/))安装包进行安装
* 用Xcode6.3打开(其他版本估计有些小错误,可以添加活着去掉感叹号)
* 启动 /Applications/ejabberd-14.12/bin/start 进行配置
* 就可以打开iMessage，Adium，以及应用程序，可以进行通讯了
			
***
# 开发流程:
## 服务器搭建
通讯协议:XMPP(eXtensible Messaging and Presence Protocol)
根据XML格式文本进行极其自由的扩展 语音，视频，群
* 基于XML
```xml
<message type="chat" from "835314557@qq.com" to "yyn835314557@163.com">
	<body>你好 iOS!</body>
	</message>
```
* 安装和启动:
	* 安装语言：simplified Chinese
	* 定义域：xiaoboswift.com
	* 启动：start
* 客户端 Adium,iMessage 两者之间互相通信
	* 应用程序－信息
* 服务器:ejabberd
	* Mac OS X 版本
* 添加客户端用户
	* admin interface
	* 虚拟主机
	* 用户
* 客户端连接设置
	* 用户名
	* 密码

## 界面构建
* 好友列表界面:
	* UI:table,state,login,navigation
	* BuddyListViewController(UITableViewController)
	* Array:bList
	* struct:WXMessage
* 聊天界面: 
	* 返回，纪录，输入，发送，预测
* 聊天界面：
	* 用户名，服务器，密码 
	* 保存到系统默认用户设置：NSUserDefaults.standardUserDefaults
	* 导航栏 －完成和取消 LoginViewController
* 场景过渡： 
	* 主场景，登录，聊天，启动动画
	* 登录：模态Modally，取消和完成按钮的反向过渡（unwind）
	* 好友列表到聊天：
		1. 选择好友所在单元格时，先建立自定义过渡（push），preformSegueWithIdentifier
		2. 好友列表代理聊天页面，prepareSegue过渡（推荐）
* 导入[XMPP库](https://github.com/robbiehanson/XMPPFramework)
	* xmppframework 
	* Project Buliding Settings: Header Serach Paths
	* /usr/include/libxml2
	* $(PROJECT_DIR)/xmpp/Core
* 界面设计:
	* 启动画面：
	* 导入库：
	* 场景关系：
	* 好友列表：
	* 登录：
	* 聊天：

## 通信实现 
* Swift调用OC桥接头文件
	* 连接和XML解析：connect，authenticate ，Receive presence，Receive message
	* 单举：UIApplication.shareApplication().delegate
	* 通信代理和协议：为公用一个连接和解析设定一个总代理
* XMPP通信建立实现
* 建立数据模型及代理协议:
	* 数据模型(DataModel):	
	* WXMsg：body,from,isCompossing,isDelay,isMe
	* Zhuangtai：user,isOnline
	* 消息代理协议(XxDl):newMsg(收到新消息)
	* 状态代理协议(ZtDl)：isOn上线，isOff下线，meOff自己下线
	* 登录过渡准备:
	* 增加自动登录组件：UISwitch,添加用户配置数据字段
	* 同步配置：synchronize
	* 明确Sender类型：UIBarButtonItem
* 好友UI：
	* 代理方法：
		- 状态上线：添加或者更新状态
		- 状态下线：将相应的好友状态设为下线
	* 属性和方法：
		- 获取总代理:登入，登出；状态数组，消息数组，已登入
	* 视图显示：
		- viewDidAppear，配置了自动登录，则登录
		- 接管消息代理（离线或者未读） 接管状态代理
	* 状态代理：
		- 上线 添加状态isOn:
			- 在列表中逐条查找：for in 循环
			- 分解出列表索引 enumerate
			- 判断新旧状态的用户名是否相符
			- 如果相符则从列表中移除旧状态
			- 一旦找到就停止：退出循环
		- 离线 更改状态isOFF:
			- 在列表中逐条查找：for in 循环
			- 分解出列表索引 enumerate
			- 判断新旧状态的用户名是否相符
			- 如果相符则从更改为离线
			- 一旦找到就停止：退出循环
	* 收到离线和未读消息处理：
		- 收到未读：
			- 处理收到的消息事件
			- 判断消息是否有正文body
			- 如果有则加入该数组
			- 无则忽略
			- 刷新表格
	* 开始登入：
		- 状态数组清零
		- 连接服务器总代理操作
		- 导航左按钮设定在线图像
		- 导航标题“我”的好友
	* 表格显示处理(表格状态数组):
		- 部分（仅有1个组）
		- 行数：状态数组的长度
		- 单元格内容：
			- 单元格在线/离线 图片切换 
			- 获取状态实例的用户名
			- 获取相应用户的未读消息条数
			- 组装用户名和未读条数
			- 显示为单元格的文本
		- 详情(点击tableViewCell)：
			- 新建视图属性
			- 当前用户名
			- 设为状态实例的用户名
			- 跳转到聊天视图场景
		- 手动上下线:
			- 开始聊天：
				准备过渡处理情报
			- 上下线按钮：
				根据登录状态进行连接/断开，改变按钮图片，切换登录状态
			- 重新登录：
				反向过渡(unwind)，从登录视图返回，若果需要重新登录则自己下线meOff，再重新登入


## 聊天界面定制
*  聊天视图过渡情报准备
	* A穿越: segue.identifier, segue.destinationViewController
	* B传递:
		- 逐条找出未读
		- 找出当前好友的未读
		- 添加到目标的消息中
	* C移除：
		- 移除当前好友的未读信息
		- 刷新表格
* 聊天删除好友的未读消息(泛型匹配) <T:Equatable>
* 聊天视图：
	* 视图启动(viewDidLoad)
		- 新方法：appDelegate 获取总代理
		- 新属性：聊天对象的用户名
		- 将总代理的消息代理设置为自己
	* 代理方法：
		- 新属性：消息数组
		- 收到消息：判断是否正在输入isCompossing改变导航条标题，否则将导航条标题改成 聊天对象用户名
		- 正文不为空则加入到消息数组 刷新表格
	* 发送按钮点击：
		- 获取文本框文本，如不则为空，创建XML格式文本xmlmsg; 类型:DDXMLElement;增加属性:;
		- 类型type聊天chat至to聊天对象的用户名来自from系统存储的登录用户名
		- 子节点正文为body文本框文本
		- XML文本增加子节点addChild
		- 总代理 发送XML文本，文本框清空，本条消息加入消息数组，是本人发送iSMe，刷新表格
	* 发送正在输入的状态（文本框(editingChanged)）:
		- 创建消息体，设置属性from，to 创建输入状态，
		- 设置属性xmlns http://jabber.org/protocol/chatstates
		- 消息体加入子节点输入状态
	* 表格数据－聊天记录展现(聊天视图表格定制)
		- 单元格:消息正文;行:消息数;部:1
		- 获取消息：索引indexPath.row
		- isMe：本人所发
		- 单元格文字居右：textAlignment
		- 字体灰色：textColor
		- 非本人：字体橙色
		- 单元格：文本设置

## 最终测试:XMPP协议
* 根据XML格式文本可以进行极其自由的扩展，语音，视频群等功能。

#核心功能：
* 登录
	- 界面 信息存储，状态判断，
* 好友列表： 
	- 上下线状态更新，离线消息提示
* 文字聊天：
	- 多国文字和表情文字，预测对方输入状态 文字对齐排列
* 离线消息：
	- 个好友的离线及好友列表界面的未读消息
