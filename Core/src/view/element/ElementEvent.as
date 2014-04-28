package view.element
{
	import flash.events.Event;
	
	/**
	 * 由原件上发出的事件
	 */
	public class ElementEvent extends Event
	{
		
		/**
		 * 临时组合的子元素被点击 
		 */		
		public static const TEM_GROUP_CHILD_CLICKED:String = "temGroupChildClicked";
		
		/**
		 * 临时组合的子元素被按下，相当于临时组合被按下
		 */		
		public static const TEM_GROUP_CHILD_DOWN:String = "temGroupChildDown";
		
		/**
		 * 临时组合的子元素被释放，相当于临时组合被释放
		 */		
		public static const TEM_GROUP_CHILD_UP:String = "temGroupChildUp";
		
		/**
		 * 临时组合的子元件开始移动 ，相当于开始移动临时组合
		 */		
		public static const START_MOVE_TEM_GROUP:String = 'startMoveTemGroup';
		
		/**
		 * 临时组合的子元件停止移动，相当与停止移动临时组合
		 */		
		public static const STOP_MOVE_TEM_GROUP:String = 'stopMoveTemGroup';
		
		/**
		 */		
		public static const IMAGE_TO_RENDER:String = "imageToRender";
		
		
		
		
		
		//------------------------------------------------------------------------------
		
		
		
		/**
		 * 鼠标点击了一下 "非选择状态" 下的元件，并且没有移动其，仅仅是点击了一下；
		 * 
		 * 接下来元件会被多选或者进入选择状态
		 */
		public static const FIRST_CLICKED:String = "firstClickElement";
		
		/**
		 * 鼠标点击了一下已经处于选择状态下的元件 ，接下来会触发文本创建动作；
		 */		
		public static const RE_CLICKED:String = 'reClickElement';
		
		/**
		 * 鼠标按下非选择状态的图形， 如果整体处于选择状态，则进入非选择状态
		 */		
		public static const FIRST_DOWN:String = 'firstDown';
		
		/**
		 * 已经处于选择状态的元素被按下后，型变框虚化
		 */		
		public static const RE_DOWN:String = 'reDown';
		
		
		/**
		 * 即将开始移动原件 
		 */		
		public static const START_MOVE:String = 'startMove';
		
		/**
		 * 正在拖动原件
		 */
		public static const MOVING:String = "elementMoving";
		
		/**
		 * 停止移动原件
		 */		
		public static const STOP_MOVE:String = 'stopMove';
		
		/**
		 * 鼠标滑入元件，此事件用于显示鼠标感应效果 
		 */		
		public static const OVER_ELEMENT:String = 'overElement';
		
		/**
		 * 鼠标滑出元件
		 */		
		public static const OUT_ELEMENT:String = 'outElement'; 
		
		/**
		 * 编辑文本 
		 */		
		public static const EDIT_TEXT:String = 'openTextEditor';
		
		/**
		 * 删除文本
		 */		
		public static const DEL_TEXT:String = 'deleteText';
		
		/**
		 * 删除图形
		 */		
		public static const DEL_SHAPE:String = 'deleteShape';
		
		/**
		 * 删除图片 
		 */		
		public static const DEL_IMG:String = 'deleteIMG';
		
		
		public static const DEL_PAGE:String = "deletePage";
		
		public static const CONVERT_PAGE_2_ELEMENT:String = "convertPage2Element";
		
		
		
		//--------------复制，粘贴不同元件区别对待
		
		/**
		 */		
		public static const COPY_ELEMENT:String = 'copyElement';
		
		/**
		 */		
		public static const COPY_TEM_GROUP:String = 'copyTemGroup';
		
		/**
		 */		
		public static const COPY_GROUP:String = 'copyGroup';
		
		/**
		 */		
		public static const PAST_ELEMENT:String = 'pastElement';
		
		/**
		 */		
		public static const PASTE_TEM_GROUP:String = 'pastTemGroup';
		
		/**
		 */		
		public static const PAST_GROUP:String = 'pastGroup';
		
		
		/**
		 * 元素
		 */
		public var element:ElementBase;
		
		/**
		 * 
		 */		
		public function ElementEvent(type:String, element:ElementBase = null)
		{
			super(type, true);
			
			this.element = element;
		}
	}
}