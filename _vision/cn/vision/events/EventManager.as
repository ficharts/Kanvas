package cn.vision.events
{
	public class EventManager extends VSEvent
	{
		public function EventManager($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		/**
		 * STEP_START常量定义STEP_START事件的<code>type</code>属性值。
		 * @default stepStart
		 */
		public static const STEP_START :String = "stepStart";
		
		/**
		 * STEP_END常量定义STEP_END事件的<code>type</code>属性值。
		 * @default stepEnd
		 */
		public static const STEP_END   :String = "stepEnd";
		
		/**
		 * QUENE_START常量定义QUENE_START事件的<code>type</code>属性值。
		 * @default queneStart
		 */
		public static const QUENE_START:String = "queneStart";
		
		/**
		 * QUENE_END常量定义QUENE_END事件的<code>type</code>属性值。
		 * @default queneEnd
		 */
		public static const QUENE_END  :String = "queneEnd";
	}
}