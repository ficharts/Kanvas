package landray.kp.maps.mind.event
{
	import flash.events.Event;
	
	import landray.kp.maps.mind.model.TreeElementVO;
	import landray.kp.maps.mind.view.TreeElement;
	
	public class MindToolEvent extends Event
	{
		/**
		 * 思维导图数据更新
		 **/
		public static const Event_MindData_UPDATE:String="minddataupdate";
		
		/**
		 * 工具条自适应按钮点击
		 **/
		public static const Event_Tool_ClickAuto:String="toolchilckauto";
		
		/**
		 * 展开
		 */
		public static const EXPAND:String = "expand";
		
		/**
		 * 合并
		 */
		public static const MERGER:String = "merger";
		
		/**
		 * 更新布局 
		 */
		public static const UPDATE_LAYOUT:String = "updataLayout";
		
		public function MindToolEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		public var vo:TreeElementVO;
		public var element:TreeElement;
	}
}