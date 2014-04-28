package cn.vision.events
{
	public class EventFile extends VSEvent
	{
		/**
		 * <code>FileEvent</code>构造函数
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function EventFile($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		//==========================================================
		// check consts
		//==========================================================
		
		/**
		 * CHECK_ERROR常量定义CHECK_ERROR事件的<code>type</code>属性值。
		 * @default checkError
		 */
		public static const CHECK_ERROR   :String = "checkError";
		
		/**
		 * CHECK_EXIST常量定义CHECK_EXIST事件的<code>type</code>属性值。
		 * @default checkExist
		 */
		public static const CHECK_EXIST   :String = "checkExist";
		
		/**
		 * CHECK_INVALID常量定义CHECK_INVALID事件的<code>type</code>属性值。
		 * @default checkInvalid
		 */
		public static const CHECK_INVALID :String = "checkInvalid";
		
		/**
		 * CHECK_START常量定义CHECK_START事件的<code>type</code>属性值。
		 * @default checkStart
		 */
		public static const CHECK_START   :String = "checkStart";
		
		//==========================================================
		// load consts
		//==========================================================
		
		/**
		 * LOAD_COMPLETE常量定义LOAD_COMPLETE事件的<code>type</code>属性值。
		 * @default loadComplete
		 */
		public static const LOAD_COMPLETE :String = "loadComplete";
		
		/**
		 * LOAD_ERROR常量定义LOAD_ERROR事件的<code>type</code>属性值。
		 * @default loadError
		 */
		public static const LOAD_ERROR    :String = "loadError";
		
		/**
		 * LOAD_PROGRESS常量定义LOAD_PROGRESS事件的<code>type</code>属性值。
		 * @default loadProgress
		 */
		public static const LOAD_PROGRESS :String = "loadProgress";
		
		/**
		 * LOAD_START常量定义LOAD_START事件的<code>type</code>属性值。
		 * @default loadStart
		 */
		public static const LOAD_START    :String = "loadStart";
		
		//==========================================================
		// save consts
		//==========================================================
		
		/**
		 * SAVE_COMPLETE常量定义SAVE_COMPLETE事件的<code>type</code>属性值。
		 * @default saveComplete
		 */
		public static const SAVE_COMPLETE :String = "saveComplete";
		/**
		 * SAVE_ERROR常量定义SAVE_ERROR事件的<code>type</code>属性值。
		 * @default saveError
		 */
		public static const SAVE_ERROR    :String = "saveError";
		/**
		 * SAVE_START常量定义SAVE_START事件的<code>type</code>属性值。
		 * @default saveStart
		 */
		public static const SAVE_START    :String = "saveStart";
		
		//==========================================================
		// process consts
		//==========================================================
		
		/**
		 * PROCESS_START常量定义PROCESS_START事件的<code>type</code>属性值。
		 * @default processStart
		 */
		public static const PROCESS_END   :String = "processEnd";
		public static const PROCESS_PAUSE :String = "processPause";
		public static const PROCESS_RESUME:String = "processResume";
		public static const PROCESS_START :String = "processStart";
		
		//==========================================================
		// variables
		//==========================================================
		
		/**
		 * 事件描述，每个类型的事件描述都会有所不同。
		 * @default null
		 */
		public var message:String;
		
		/**
		 * 加载的字节数，<code>FileLoader</code>从路径加载发送
		 * <code>FileEvent.LOAD_PROGRESS</code>时可用，否则为NaN
		 * @default NaN
		 */
		public var bytesLoaded:Number;
		
		/**
		 * 需要加载的字节数，<code>FileLoader</code>从路径加载发送
		 * <code>FileEvent.LOAD_PROGRESS</code>时可用，否则为NaN
		 * @default NaN
		 */
		public var bytesTotal :Number;
		
	}
}