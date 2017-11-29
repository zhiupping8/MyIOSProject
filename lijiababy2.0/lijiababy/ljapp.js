//注册推送处理
// ljapp.registMessageMethod = function registMessageMethod(receiveNewMessageCallback, touchMessageCallback) {
//     ljjpush.registMessageMethod(receiveNewMessageCallback, touchMessageCallback);
// receiveNewMessageCallback: function(userInfo) {
// userInfo: { //自定义消息
//     "title": "title"
//     "content": "asdfasd"
//     "extra": {
//         "key" = "key"
//     }
// }
// userInfo: { //极光消息
//     "_j_business" = 1,
//     "_j_msgid" = 2464506093,
//     "_j_uid" = 9308919660,
//     "aps" = {
//         "alert" : {
//             "body" : "asdfasdf",
//             "subtitle" : "subtitle",
//             "title" : "title",
//         };
//         "badge" : 1,
//         "sound" :,
//         "default":,
//     };
//     "test" = "test"
// }
// }
// touchMessageCallback: function(userInfo) {userInfo://同上}
// }

//推送: 客户端打开对应的url即可(如果需要数据会提供相应的url)

//扫一扫
//callback: function (resultInfo) {
// resultInfo: {
//     "result"://扫描的字符串结果   
//     "type": //扫码的类型(条形码、二维码等)
// }
// }

var ljapp = ljapp || {};

//获取推送用户标识接口
// callback: function (registrationID) {
//     registrationID 推送用户标识
// }
ljapp.getRegistrationID = function getRegistrationID(callback) {
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('jpush', {}, function(responseData) {
            if (responseData.code == 0) {
                callback(responseData.registId);
                return;
            }
            callback("");
        });
    } else if (this.clientType === "ios") {
        return ljjpush.getRegistrationID(callback);
    }
}

ljapp.regitsterScanCallback = function regitsterScanCallback(callback) {
        ljscan.register(callback);
    }
    //callback: function (resultInfo) {
    // resultInfo: {
    //     "result"://扫描的字符串结果   
    //     "type": //扫码的类型(条形码、二维码等)
    // }
    // }
ljapp.scan = function scan(callback) {
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('twoSanRequest', {}, callback);
    } else if (this.clientType === "ios") {
        ljscan.scan(callback);
    }
}

//获取地理位置
//coordtype: //WGS-84、GCJ-02、BD-09等
// callback: function(locationInfo) {
// }
// locationInfo: {
// 	"code":, //0(成功), -1(访问被拒绝), -2(无法获取地理位置), -3(获取地理位置的服务不可用)
//  "coordtype": //WGS-84、GCJ-02等
// 	"latitude":, //经度
// 	"longitude": //维度
//  "accuracy": //精度(单位是米)
// }
ljapp.getLocation = function getLocation(coordtype, callback) {
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('locationRequest', { 'coordtype': coordtype }, callback);
    } else if (this.clientType === "ios") {
        ljlocation.getLocation(coordtype, callback);
    }
}

//分享
// shareInfo: {
//     "title":, //标题
//     "text": , //分享内容信息
//     "url": //链接地址
//	   "images": //图片的链接地址
// }
// callback: function(code) {
//     "code": 0 //0(分享成功), -1(用户取消), -2(分享失败) -3 参数有误
// }
ljapp.share = function share(shareInfo, callback) {
    console.info("share");
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('shareRequest', shareInfo, function(data){
			callback(data.code);
		});
    } else if (this.clientType === "ios") {
        ljshare.share(shareInfo, callback);
    }
}

//地图

// locationInfo: {
//     "coordtype": //WGS-84、GCJ-02、BD-09等
//     "locationName": "北京西站",
//     "locationAddress": "北京市丰台区莲花池东路118号",
//     "latitude": 39.900323’, //经度
//     "longitude": 116.32838 //纬度
// }

// callback: function(resultInfo) {
//     resultInfo: {
//         "tag": 1, //地图标识 0 苹果地图 1 百度地图 2 高德地图 3 谷歌地图 4 腾讯地图 -1 未选择
//         "code": 0 //操作结果状态码: 0 成功 -1 参数有误 -2 没有可用地图 -3 用户取消 -4失败
//     }
// }
ljapp.openMap = function openMap(locationInfo, callback) {
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('naviRequest', locationInfo, callback);
    } else if (this.clientType === "ios") {
        ljmap.openMap(locationInfo, callback);
    }
}

//微信支付
// orderInfo: {
//     "partnerid": "1263779101",
//     "package": "Sign=WXPay",
//     "prepayid": "wx20170508151259951f6e75160447397012",
//     "timestamp": "1494227579",
//     "noncestr": "4Si5MfrX6voD9J7r",
//     "sign": "C5599E0C0E953AB254790CEF517308CD"
// }

// callback: function (code) {
//     1 //其他错误
//     0 //支付成功
//     -1 //普通错误类型
//     -2 //用户点击取消并返回
//     -3 //发送失败
//     -4 //授权失败
//     -5 //微信不支持
//     -6 //微信支付参数有误
//     -7 //用户未安装微信
//     -8 //应用注册失败
// }
ljapp.wxPay = function wxPay(orderInfo, callback) {
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('weipayRequest', orderInfo, function(data){
			callback(data.code);
		});
    } else if (this.clientType === "ios") {
        ljwxpay.wxPay(orderInfo, callback);
    }
}

//支付宝支付
// orderString: //从支付宝获取的订单信息
//     callback: function(resultInfo) {
//     //resultInfo 详细参考https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.NDyppu&treeId=204&articleId=105302&docType=1
// }
ljapp.aliPay = function aliPay(orderString, callback) {
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('alipayRequest', { 'payInfo': orderString }, function(data){
			if(data.code==0){
				callback(JSON.parse(data.resultInfo));
				return;
			}
			callback("");
		});
    } else if (this.clientType === "ios") {
        ljalipay.aliPay(orderString, callback);
    }
}

//长按图片接口
ljapp.longTimeTouch = function longTimeTouch(params, shareCallback, recognizeCallback) {
    // params: {
    //     "title":, //标题
    //     "text": , //分享内容信息
    //	   "images": //图片的链接地址
    // }

    // shareCallback: function(code) {
    //     "code": 0 //0(分享成功), -1(用户取消), -2(分享失败) -3 参数有误
    // }

    //recognizeCallback: function (resultInfo) {
    // resultInfo: {
    //     "result"://扫描的字符串结果   
    //     "type": //扫码的类型(条形码、二维码等)
    // }
    // }
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('imgScan', params, function(data) {
            if (data.otype && data.otype == 1) { //扫码
                recognizeCallback(data);
            } else if (data.otype && data.otype == 2) { //分享
                shareCallback(data.code);
            }

        });
    } else if (this.clientType === "ios") {
        ljTouch.longTimeTouch(params, shareCallback, recognizeCallback);
    }
}

//调用扫码商品二维码
ljapp.scanGoods = function scanGoods(callback) {
    // params: {
    // }

    //callback: function (resultInfo) {
    // resultInfo: [
	//		{
	//			"addTime"://商品添加的时间的毫秒数
	//			"barcode"://返回值中的商品货码
	//			"name"://返回值中的商品名称
	//			"quantity"://该商品的数量信息
	//			"sku"://返回值中的货品sku
	//		}
    // ]
    // }
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('scanGoods', {}, function(data) {
            if(data&&data.result&&typeof(data.result)!='undefined'){
				callback(JSON.parse(data.result));
			}else{
				callback([]);
			}
        });
    } else if (this.clientType === "ios") {
        ljTouch.scanGoods(callback)
    }
}

//调用设置当前页面的标题等分享信息
ljapp.setShareInfo = function setShareInfo(params,callback) {
    // params: {
    //     "title":, //标题
    //     "text": , //分享内容信息
    // }

    //callback: function (resultInfo) {
    // resultInfo: {
	//	code://结果码
    // }
    // }
    if (this.clientType === "android") {
        window.WebViewJavascriptBridge.callHandler('titleContent', {}, function(data) {
            if(data){
				callback(data.code);
			}else{
				callback("");
			}
        });
    } else if (this.clientType === "ios") {
        ljscan.setShareInfo(params, callback)
    }
}


ljapp.connectWebViewJavascriptBridge = function connectWebViewJavascriptBridge(callback) {
    console.info("connectWebViewJavascriptBridge 方法执行");
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener(
            'WebViewJavascriptBridgeReady',
            function() {
                callback(WebViewJavascriptBridge)
            },
            false
        );
    }
}

ljapp.connectWebViewJavascriptBridge(function(bridge) {
    bridge.init(function(message, responseCallback) {
        console.log('JS got a message', message);
        var data = {
            'Javascript Responds': '测试中文!'
        };
        console.log('JS responding with', data);
        responseCallback(data);
    });

    bridge.registerHandler("logOnHtml", function(data, responseCallback) {
        bridgeLog("data from Java: = " + data);
        var responseData = "Javascript Says Right back aka!";
        responseCallback(responseData);
    });
})
ljapp.initFlag = false;
ljapp.init = function() {

    if (this.initFlag) {
        return;
    }
    this.initFlag = true;

    var agent = navigator.userAgent.toLowerCase();
    if (agent.indexOf('android') != -1 || agent.indexOf('linux') != -1) {
        this.clientType = "android";
    } else if (agent.indexOf("iphone") != -1) {
        this.clientType = "ios";
    }
    console.info("设置平台为：" + ljapp.clientType);

    if (window.WebViewJavascriptBridge) {
        return;
    }

    var messagingIframe;
    var sendMessageQueue = [];
    var receiveMessageQueue = [];
    var messageHandlers = {};

    var CUSTOM_PROTOCOL_SCHEME = 'yy';
    var QUEUE_HAS_MESSAGE = '__QUEUE_MESSAGE__/';

    var responseCallbacks = {};
    var uniqueId = 1;

    function _createQueueReadyIframe(doc) {
        messagingIframe = doc.createElement('iframe');
        messagingIframe.style.display = 'none';
        doc.documentElement.appendChild(messagingIframe);
    }

    //set default messageHandler
    function init(messageHandler) {
        if (WebViewJavascriptBridge._messageHandler) {
            throw new Error('WebViewJavascriptBridge.init called twice');
        }
        WebViewJavascriptBridge._messageHandler = messageHandler;
        var receivedMessages = receiveMessageQueue;
        receiveMessageQueue = null;
        for (var i = 0; i < receivedMessages.length; i++) {
            _dispatchMessageFromNative(receivedMessages[i]);
        }
    }

    function send(data, responseCallback) {
        _doSend({
            data: data
        }, responseCallback);
    }

    function registerHandler(handlerName, handler) {
        messageHandlers[handlerName] = handler;
    }

    function callHandler(handlerName, data, responseCallback) {
        _doSend({
            handlerName: handlerName,
            data: data
        }, responseCallback);
    }

    //sendMessage add message, 触发native处理 sendMessage
    function _doSend(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }

        sendMessageQueue.push(message);
        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
    }

    // 提供给native调用,该函数作用:获取sendMessageQueue返回给native,由于android不能直接获取返回的内容,所以使用url shouldOverrideUrlLoading 的方式返回内容
    function _fetchQueue() {
        var messageQueueString = JSON.stringify(sendMessageQueue);
        sendMessageQueue = [];
        //android can't read directly the return data, so we can reload iframe src to communicate with java
        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://return/_fetchQueue/' + encodeURIComponent(messageQueueString);
    }

    //提供给native使用,  处理一次java对js的调用
    function _dispatchMessageFromNative(messageJSON) {
        setTimeout(function() {
            var message = JSON.parse(messageJSON);
            var responseCallback;
            //如果存在responseId表示是js调用java方法成功后回调js的方法
            if (message.responseId) {
                responseCallback = responseCallbacks[message.responseId];
                if (!responseCallback) {
                    return;
                }
                responseCallback(JSON.parse(message.responseData));
                delete responseCallbacks[message.responseId];
            } else {
                //java调用js方法
                if (message.callbackId) {
                    var callbackResponseId = message.callbackId;
                    responseCallback = function(responseData) {
                        _doSend({
                            responseId: callbackResponseId,
                            responseData: responseData
                        });
                    };
                }

                var handler = WebViewJavascriptBridge._messageHandler;
                if (message.handlerName) {
                    handler = messageHandlers[message.handlerName];
                }
                //查找指定handler
                try {
                    handler(message.data, responseCallback);
                } catch (exception) {
                    if (typeof console != 'undefined') {
                        console.log("WebViewJavascriptBridge: WARNING: javascript handler threw.", message, exception);
                    }
                }
            }
        });
    }

    /*
        提供给native调用,receiveMessageQueue 在会在页面加载完后赋值为null,所以
    */
    function _handleMessageFromNative(messageJSON) {
        console.log(messageJSON);
        if (receiveMessageQueue && receiveMessageQueue.length > 0) {
            receiveMessageQueue.push(messageJSON);
        } else {
            _dispatchMessageFromNative(messageJSON);
        }
    }

    var WebViewJavascriptBridge = window.WebViewJavascriptBridge = {
        init: init,
        send: send,
        registerHandler: registerHandler,
        callHandler: callHandler,
        _fetchQueue: _fetchQueue,
        _handleMessageFromNative: _handleMessageFromNative
    };

    var doc = document;
    _createQueueReadyIframe(doc);
    var readyEvent = doc.createEvent('Events');
    readyEvent.initEvent('WebViewJavascriptBridgeReady');
    readyEvent.bridge = WebViewJavascriptBridge;
    doc.dispatchEvent(readyEvent);
}
