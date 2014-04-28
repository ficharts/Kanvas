package cn.vision.events
{
	public class EventCommand extends VSEvent
	{
		public function EventCommand($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		/**
		 * UPDATE_START常量定义UPDATE_START事件的<code>type</code>属性值。
		 * @default updateStart
		 */
		public static const EXECUTE_START:String = "executeStart";
		
		/**
		 * UPDATE_END常量定义UPDATE_END事件的<code>type</code>属性值。
		 * @default updateEnd
		 */
		public static const EXECUTE_END  :String = "executeEnd";
	}
}