package cn.vision.events
{
	public class EventModel extends VSEvent
	{
		public function EventModel($type:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		/**
		 * UPDATE_START常量定义UPDATE_START事件的<code>type</code>属性值。
		 * @default updateStart
		 */
		public static const UPDATE_START:String = "updateStart";
		
		/**
		 * UPDATE_END常量定义UPDATE_END事件的<code>type</code>属性值。
		 * @default updateEnd
		 */
		public static const UPDATE_END  :String = "updateEnd";
	}
}