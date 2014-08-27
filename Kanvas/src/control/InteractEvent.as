package control
{
	import flash.events.Event;
	
	/**
	 * 交互事件，用于传递面板UI交互指令
	 */	
	public class InteractEvent extends Event
	{
	
		/**
		 *  插入图表 
		 */		
		public static const OPEN_CHART_PANEL:String = "openChartPanel";
		
		public static const CLOSE_PANEL:String = "closeChartPanel";
		
		/**
		 * 插入图片
		 */		
		public static const INSERT_IMAGE:String = 'insertImage';
		
		/**
		 * 开启图形创建面板 
		 */		
		public static const OPEN_SHAPE_PANEL:String = 'openShapePanel';
		
		/**
		 * 开启整体风格样式设置面板 
		 */		
		public static const OPEN_THEME_PANEL:String = 'openThemePanel';
		
		/**
		 */		
		public static const PREVIEW:String = 'preview';
		
		/**
		 * 右侧 
		 */		
		public static const RIGHT_PANEL_OPEN:String = 'rightPanelOpen';
		
		/**
		 */		
		public function InteractEvent(type:String)
		{
			super(type, true);
		}
	}
}