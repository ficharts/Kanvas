package landray.kp.utils
{
	import com.kvs.utils.Base64;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPPresenter;
	import landray.kp.core.kp_internal;
	
	import util.img.ImgInsertor;

	public final class ExternalUtil
	{
		public static function initCallBack($kplayer:KPlayer):Boolean
		{
			kplayer = $kplayer;
			
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("setImgDomainServer"   , setImgDomainServer);
				//传入一个URL，然后通过URL获取数据
				ExternalInterface.addCallback("loadDataFromServer"   , loadDataFromServer);
				//传入一个XML String数据
				ExternalInterface.addCallback("setXMLData"           , setXMLData);
				//传入一个通过BASE64和BYTEARRAY压缩的XML String
				ExternalInterface.addCallback("setBase64Data"        , setBase64Data);
				//模拟鼠标滚轮
				ExternalInterface.addCallback("onWebMouseWheel"      , onWebMouseWheel);
				
				ExternalInterface.addCallback("horizontalMove"       , horizontalMove);
				
				ExternalInterface.addCallback("unselected"           , unselected);
				
				ExternalInterface.addCallback("setStartOriginalScale", setStartOriginalScale);
				
				ExternalInterface.addCallback("showLinkOveredTip"    , showLinkOveredTip);
			}
			return ExternalInterface.available;
		}
		
		//---------------------------------------------------------------------------
		// JS回调函数
		// 提供外层网页容器调用
		//---------------------------------------------------------------------------
		
		private static function setImgDomainServer(value:String):void
		{
			ImgInsertor.IMG_DOMAIN_URL = value;
		}
		
		/**
		 * @private
		 * js回调函数，传入一个URL，然后通过URL获取数据
		 * 
		 * @param value 传入的地址
		 */
		private static function loadDataFromServer(value:String):void
		{
			try  
			{
				if (value) 
				{
					//kplayer presenter初始化
					presenter.start(kplayer, kplayer.appID, true, value);
				}
			}
			catch (e:Error) { }
		}
		
		/**
		 * @private
		 * js回调函数，传入一个XML String
		 * 
		 * @param value 传入的XML String
		 */
		private static function setXMLData(value:String):void
		{
			if (value) 
			{
				//kplayer presenter初始化
				presenter.start(kplayer, kplayer.appID, false, value);
			}
		}
		
		/**
		 * @private
		 * js回调函数，传入一个BASE64加密的XML String
		 * 
		 * @param value 传入的加密XML String
		 */
		private static function setBase64Data(value:String, ifCompress:Boolean = true):void
		{
			if (value) 
			{
				//传入的参数不为URL
				//处理外部传入的BASE64压缩数据
				var newByte:ByteArray = Base64.decodeToByteArray(value);
				
				if (ifCompress)
					newByte.uncompress();
				
				//kplayer presenter初始化
				presenter.start(kplayer, kplayer.appID, false, String(newByte.toString()));
			}
		}
		
		/**
		 * @private
		 * js回调函数，当在网页中为transparent，鼠标滚轮会不起作用，此时从JS模拟FLASH鼠标滚轮事件
		 */
		private static function onWebMouseWheel(value:int):void
		{
			kplayer.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, NaN, NaN, null, false, false, false, false, value));
		}
		
		/**
		 * @private
		 * js回调函数，画布横向移动一段距离
		 */
		private static function horizontalMove(value:Number):void
		{
			config.kp_internal::controller.zoomMoveOff(1, value, 0);
		}
		
		/**
		 * @private
		 * js回调函数，取消元素的选择状态
		 */
		private static function unselected():void
		{
			config.kp_internal::mediator.bgClicked();
		}
		
		/**
		 * @private
		 * js回调函数，取消元素的选择状态
		 */
		private static function setStartOriginalScale(scale:Boolean):void
		{
			config.originalScale = scale;
		}
		
		/**
		 * @private
		 * js回调函数，取消元素的选择状态
		 */
		private static function showLinkOveredTip(msg:String, w:Number = 0):void
		{
			config.kp_internal::toolTip.showToolTip(msg, w);
			//config.kp_internal::viewer.kp_internal::showLinkOveredTip(msg, w);
		}
		
		//---------------------------------------------------------------------------
		// AS调用JS函数
		// 提供外层网页容器调用
		//---------------------------------------------------------------------------
		
		
		/**
		 * kanvas 初始化完毕
		 */
		public static function kanvasReady():void
		{
			ExternalInterface.call("KANVAS.ready", kplayer.appID);
		}
		
		/**
		 * kanvas 取消选择
		 */
		public static function kanvasUnselected():void
		{
			ExternalInterface.call("KANVAS.unselected", kplayer.appID);
		}
		
		/**
		 * kanvas 图形点击
		 */
		public static function kanvasLinkClicked(elementID:uint):void
		{
			ExternalInterface.call("KANVAS.linkClicked", kplayer.appID, elementID);
		}
		
		/**
		 * kanvas 图形鼠标移入
		 */
		public static function kanvasLinkOvered(elementID:uint):void
		{
			ExternalInterface.call("KANVAS.linkOvered", kplayer.appID, elementID);
		}
		
		private static var kplayer:KPlayer;
		
		private static const presenter:KPPresenter = KPPresenter.instance;
		private static const config:KPConfig = KPConfig.instance;
	}
}