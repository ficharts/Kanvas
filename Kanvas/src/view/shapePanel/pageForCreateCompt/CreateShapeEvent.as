package view.shapePanel.pageForCreateCompt
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import view.ItemSelector;
	
	/**
	 * 图形创建事件, 创建面板里的交互动作会通过事件方式通知给
	 * 
	 * 负责创建图形的代理器， 其负责与核心core打交道
	 */	
	public class CreateShapeEvent extends Event
	{
		/**
		 * 点击了一下图形
		 */		
		public static const SHAPE_CLICKED:String = 'shapeClicked';
		
		/**
		 * 开始拖动图形 
		 */		
		public static const SHAPE_START_MOVE:String = 'startMoveShape';
		
		/**
		 * 停止拖动图形
		 */		
		public static const SHAPE_STOP_MOVE:String = 'stopMoveShape';
		
		/**
		 */		
		public function CreateShapeEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 * 图形图标，用来拖放创建图形时作为原始素材draw用
		 */		
		public var shapeIcon:ItemSelector;
		
	}
}