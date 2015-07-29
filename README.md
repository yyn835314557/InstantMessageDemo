# Swift iPhone6 微信

***

## 服务器搭建
	通讯协议:XMPP(eXtensible Messaging and Presence Protocol)
	根据XML格式文本进行极其自由的扩展 语音，视频，群
	* 基于XML
		<message type="chat" from "xiao@swiftv.cn" to "bo@swiftv.cn">
			<body>你好!</body>
			</message>
	* 安装和启动:
		安装语言：simplified Chinese
		定义域：xiaoboswift.com
		启动：start
	* 客户端 Adium,iMessage 两者之间互相通信
		应用程序－信息
	* 服务器:ejabberd
		Mac OS X 版本
	* 添加客户端用户
		admin interface
		虚拟主机
		用户
	* 客户端连接设置
		用户名
		密码

## 界面构建
	* 好友列表界面:
		UI:table,state,login,navigation
		BuddyListViewController(UITableViewController)
		Array:bList
		struct:WXMessage
	* 聊天界面: 
		返回，纪录，输入，发送，预测
	* 聊天界面：
		用户名，服务器，密码 
		保存到系统默认用户设置：NSUserDefaults.standardUserDefaults
		导航栏 －完成和取消 LoginViewController
	* 场景过渡： 
		主场景，登录，聊天，启动动画
		登录：模态Modally，取消和完成按钮的反向过渡（unwind）
		好友列表到聊天：
			1. 选择好友所在单元格时，先建立自定义过渡（push），preformSegueWithIdentifier
			2. 好友列表代理聊天页面，prepareSegue过渡（推荐）
	* 导入XMPP库
		xmppframework 
		Project Buliding Settings: Header Serach Paths
		/usr/include/libxml2
		$(PROJECT_DIR)/xmpp/Core
	* 界面设计:
		启动画面：
		导入库：
		场景关系：
		好友列表：
		登录：
		聊天：

## 通信实现 
	* Swift调用OC桥接头文件
		连接和XML解析：connect，authenticate ，Receive presence，Receive message
		单举：UIApplication.shareApplication().delegate
		通信代理和协议：为公用一个连接和解析设定一个总代理
	* XMPP通信建立实现
	* 建立数据模型及代理协议:
		数据模型(DataModel):	
			WXMsg：body,from,isCompossing,isDelay,isMe
			Zhuangtai：user,isOnline
		消息代理协议(XxDl):newMsg(收到新消息)
		状态代理协议(ZtDl)：isOn上线，isOff下线，meOff自己下线
	* 登录过渡准备:
		增加自动登录组件：UISwitch,添加用户配置数据字段
		同步配置：synchronize
		明确Sender类型：UIBarButtonItem

## 聊天界面定制


#核心功能：
* 登录
	界面 信息存储，状态判断，
* 好友列表： 
	上下线状态更新，离线消息提示
* 文字聊天：
	多国文字和表情文字，预测对方输入状态 文字对齐排列
* 离线消息：
	个好友的离线及好友列表界面的未读消息