package
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * 核心Core向外部发送的事件，告知外部程序
	 * 
	 * 其状态发生变更
	 */	
	public class KVSEvent extends Event
	{
		/**
		 * 初始化完成 
		 */		
		public static const READY:String = 'ready';
		
		/**
		 * 整体风格样式更新
		 */		
		public static const THEME_UPDATED:String = 'themeUpdated';
		
		/**
		 * 背景颜色调色板 
		 */		
		public static const UPDATE_BG_COLOR_LIST:String = 'updateBgColorList';
		
		/**
		 * 更新背景颜色
		 */		
		public static const UPDATE_BG_COLOR:String = 'updateBgColor';
		
		/**
		 */		
		public static const UPDATE_BG_IMG:String = 'updatedBgImg';
		
		/**
		 * 连接按钮被按下
		 */		
		public static const LINK_CLICKED:String = 'linkClicked';
		
		/**
		 * 更新画布镜头区域后触发
		 */		
		public static const UPATE_BOUND:String = 'updateBound';
		
		/**
		 * 数据发生了改变，kanvas需要保存数据了 
		 */		
		public static const DATA_CHANGED:String = "dataChanged";
		
		/**
		 * 保存
		 */	
		public static const SAVE:String = "save";
		
		/**
		 */		
		public function KVSEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		public var colorList:XML;
		
		/**
		 */		
		public var colorIndex:uint = 0;
		
		/**
		 */		
		public var themeID:String = null;
		
		/**
		 */		
		public var bgIMG:BitmapData;
	}
}