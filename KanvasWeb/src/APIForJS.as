package  
{
	import com.kvs.utils.Base64;
	import com.kvs.utils.ExternalUtil;
	import com.kvs.utils.net.Post;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import model.ConfigInitor;
	
	import util.img.ImgInsertor;
	
	import view.ui.Bubble;

	/**
	 * JS与kanvas核心core之间的API管理
	 */	
	public class APIForJS extends KanvasAPI
	{
		/**
		 * 
		 * @param core
		 * 
		 */
		public function APIForJS(core:CoreApp)
		{
			super(core);
			
			core.addEventListener(KVSEvent.LINK_CLICKED, linkBtnClicked);
			appID = core.stage.loaderInfo.parameters['id'];
			
			//初始化数据加载器
			datalLoader.dataFormat = URLLoaderDataFormat.BINARY;
			datalLoader.addEventListener(Event.COMPLETE, dataLoaded);
			datalLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
				
			//基本编辑指令
			ExternalUtil.addCallback('copy', copy);
			ExternalUtil.addCallback('cut', cut);
			ExternalUtil.addCallback('paste', paste);
			ExternalUtil.addCallback('undo', undo);
			
			//设置图片上传服务
			ExternalUtil.addCallback('setImgUploadServer', setImgUploadServer);
			
			//设置图片主域名地址
			ExternalUtil.addCallback('setImgDomainServer', setImgDomainServer);
			
			//获取页面数据
			ExternalUtil.addCallback("getPageImgData", getPageImgData);
			
			//获取图片URL列表
			ExternalUtil.addCallback('getImgURLList', getImgURLList);
			
			//获取拥有属性的ID列表
			ExternalUtil.addCallback("getOwnPropertyIDList", getOwnPropertyIDList);
			
			//加载压缩了的数据
			ExternalUtil.addCallback('loadDataFromServer', loadDataFromServer);
			
			//保存压缩数据至服务器
			ExternalUtil.addCallback('saveDataToServer', saveDataToServer);
			
			//获取xml格式的数据
			ExternalUtil.addCallback('getXMLData', getXMLData);
			
			//指定XMl格式的数据
			ExternalUtil.addCallback('setXMLData', setXMLData);
			
			//获取base64编码并压缩后的字符串数据
			ExternalUtil.addCallback('getBase64Data', getBase64Data);
			
			//设置Base64编码的数据
			ExternalUtil.addCallback('setBase64Data', setBase64Data);
			
			//保存关联数据，关联面板关闭时调用
			ExternalUtil.addCallback('setLinkData', setLinkData);
			
			//鼠标滚轮
			ExternalUtil.addCallback("onWebMouseWheel", onWebMouseWheel);
			
			ExternalUtil.addCallback("getShotCut", getShotCut);
			
			ExternalUtil.addCallback("initDataServer", initDataServer);
			
			//通知网页端，Flash初始化OK
			ExternalUtil.call('KANVAS.ready', appID);
			
		}
		
		/**
		 */		
		public var appID:String;
		
		
		
		
		
		
		
		//----------------------------------------------------
		//
		//
		// 配置相关
		//
		//
		//----------------------------------------------------
		
		/**
		 * 设置图片上传服务，图片插入时会将图片的二进制数据发送至
		 * 
		 * 此服务地址， 成功后返回图片的URL
		 */		
		private function setImgUploadServer(url:String):void
		{
			ImgInsertor.IMG_UPLOAD_URL = url;
		}
		
		private function setImgDomainServer(url:String):void
		{
			ImgInsertor.IMG_DOMAIN_URL = url;
		}
		
		
		
		
		
		
		
		
		//----------------------------------------------------
		//
		//
		// 数据相关
		//
		//
		//
		//----------------------------------------------------
		
		/**
		 * 
		 */		
		private function initDataServer(url:String, docID:String, thumbW:Number, thumbH:Number):void
		{
			ConfigInitor.SERVER_URL   = url;
			ConfigInitor.DOC_ID       = docID;
			ConfigInitor.THUMB_WIDTH  = thumbW;
			ConfigInitor.THUMB_HEIGHT = thumbH;
		}
		
		/**
		 * 上传至服务器端的图片不会随着客户端的删除操作而删除，而是保存数据时
		 * 
		 * 由服务端负责删除多余的图片数据；
		 * 
		 * 每次开始一个会话时，服务端记录下上传图片的URL记录；
		 * 
		 * 保存数据时客户端将所有最终保存下来的的图片url列表告知页面(有些图片会在编辑的过程中被删除掉，但服务端还有)， 
		 * 
		 * 页面将这个列表和Kanvas数据一并发送至服务端，服务端得到数据后
		 * 
		 * 比较两个图片URL列表，删除客户端列表中未包含的图片；
		 * 
		 */		
		private function getImgURLList():String
		{
			return stringToBase64(core.getImgURLList());
		}
		
		private function getOwnPropertyIDList():String
		{
			return core.getOwnPropertyElementIDList();
		}
		
		/**
		 * 关联按钮点击后，告知页面开启关联面板
		 */		
		private function linkBtnClicked(evt:KVSEvent):void
		{
			evt.stopPropagation();
			
			ExternalUtil.call('KANVAS.linkBtnClicked', appID, core.currentElement.vo.id);
		}
		
		/**
		 * 给当前元素设置关联属性
		 */		
		private function setLinkData(value:String):void
		{
			core.currentElement.vo.property = value;
		}
		
			
		/**
		 */		
		public function setBase64Data(value:String, isCompress:Boolean = true):void
		{
			var newByte:ByteArray = Base64.decodeToByteArray(value);
			
			if(isCompress)
				newByte.uncompress();
			
			this.setXMLData(newByte.toString());
		}
		
		private function onWebMouseWheel(value:int):void
		{
			core.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, NaN, NaN, null, false, false, false, false, -value));
		}
		
		/**
		 */		
		private function getShotCut(w:Number = 296, h:Number = 160):String
		{
			var bmd:BitmapData = core.thumbManager.getShotCut(w, h);
			var str:String = "";
			if (bmd)
			{
				var jpegEncoderOptions:JPEGEncoderOptions = new JPEGEncoderOptions;
				var bytes:ByteArray = bmd.encode(bmd.rect, jpegEncoderOptions);
				//bytes.compress();
				str = Base64.encodeByteArray(bytes);
			}
			
			return str;
		}
		
		/**
		 * 上传数据至服务器
		 */		
		public function saveDataToServer($handler:Function = null):void
		{
			handler = $handler;
			
			var bmd:BitmapData = core.thumbManager.getShotCut(ConfigInitor.THUMB_WIDTH, ConfigInitor.THUMB_HEIGHT);
			if (bmd)
			{
				var jpegEncoderOptions:JPEGEncoderOptions = new JPEGEncoderOptions;
				var bytes:ByteArray = bmd.encode(bmd.rect, jpegEncoderOptions);
			}
			
			var pages:ByteArray = core.thumbManager.getPageBytes();
			var data:Object = {};
			data.docid  = ConfigInitor.DOC_ID;
			data.thumbW = ConfigInitor.THUMB_WIDTH .toString();
			data.thumbH = ConfigInitor.THUMB_HEIGHT.toString();
			data.thumbData = bytes;
			data.data = Base64.encode(getXMLData());
			
			if (pages) data.pageImgData = pages;
			
			if (dataUpLoader)
			{
				dataUpLoader.removeEventListener(Event.COMPLETE, dataUploadedHandler);
				dataUpLoader.removeEventListener(IOErrorEvent.IO_ERROR, upIOErrorHandler);
			}
			
			dataUpLoader = new Post(ConfigInitor.SERVER_URL, data);
			dataUpLoader.addEventListener(Event.COMPLETE, dataUploadedHandler);
			dataUpLoader.addEventListener(IOErrorEvent.IO_ERROR, upIOErrorHandler);
			dataUpLoader.sendfile();
		}
		
		/**
		 * 数据上传成功
		 */		
		private function dataUploadedHandler(evt:Event):void
		{
			if (handler!= null)
			{
				handler();
				handler = null;
			}
		}
		
		private function upIOErrorHandler(evt:IOErrorEvent):void
		{
			if (handler!= null)
			{
				handler(false);
				handler = null;
			}
			
			Bubble.show("保存失败，连接服务端或数据出错！");
		}
		
		private var handler:Function;
											 
		/**
		 * 数据上传器，负责将数据发送至服务器
		 */		
		private var dataUpLoader:Post;
		
		/**
		 */		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			
		}
		
		
		
		
		
		
		/**
		 * 指定路径, 从指定路径加载数据
		 */		
		private function loadDataFromServer(url:String):void
		{
			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.GET;
			
			datalLoader.load(req);
		}
		
		/**
		 */		
		private function dataLoaded(evt:Event):void
		{
			var data:ByteArray = ByteArray(datalLoader.data);
			
			//解压缩
			data.uncompress();
			
			//转换为XMl格式
			var xmlData:XML = XML(data.toString());
			core.importData(xmlData);
		}
		
		/**
		 * 数据加载器，负责从服务端加载数据
		 */		
		private var datalLoader:URLLoader = new URLLoader;
		
		
		
		
		
		
		
		
		
		//----------------------------------------------------
		//
		//
		// 基本的编辑指令
		//
		//
		//----------------------------------------------------
		
		/**
		 */		
		private function copy():void
		{
			core.copy();
		}
		
		/**
		 */		
		private function cut():void
		{
			core.cut();
		}
		
		/**
		 */		
		private function paste():void
		{
			core.paste();
		}
		
		/**
		 */		
		private function undo():void
		{
			core.undo();
		}
		
		
	}
}