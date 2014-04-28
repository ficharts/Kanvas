package view.element.state
{
	import view.element.ElementBase;
	import view.element.ElementEvent;

	/**
	 * 元素状态基类，基本状态有选择和非选择状态
	 * 
	 * 有些负责的元素例如文本，还有编辑状态
	 */
	public class ElementStateBase
	{
		/**
		 * 默认可被智能组合，组合元件的子元素不能被组合；
		 */		
		public function get canAutoGrouped():Boolean
		{
			return true;
		}
		
		/**
		 * 元素
		 */
		protected var element:ElementBase;
		
		/**
		 */		
		public function ElementStateBase(element:ElementBase)
		{
			this.element = element;
		}
		
		/**
		 * 只有选中状态下才会触发删除消息
		 */		
		public function del():void
		{
			
		}
		
		/**
		 * 处于非选择状态下的图形click后触发
		 */
		public function clicked():void
		{
			
		}
		
		/**
		 */		
		public function mouseDown():void
		{
			
		}
		
		/**
		 */		
		public function mouseUp():void
		{
			
		}
		
		/**
		 * 当前状态鼠标经过后处理方法
		 */
		public function mouseOver():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.OVER_ELEMENT, element));
		}
		
		/**
		 * 当前状态鼠标离开后处理方法
		 */
		public function mouseOut():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.OUT_ELEMENT, element));
		}
		
		/**
		 */		
		public function startMove():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.START_MOVE, element))
		}
		
		
		/**
		 */		
		public function stopMove():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.STOP_MOVE, element))
		}
		
		/**
		 */		
		public function enable():void
		{
			if (element.alpha == 1)
				return;
			
			element.mouseChildren = element.mouseEnabled = true;
			element.alpha = 1;
		}
		
		/**
		 */		
		public function disable():void
		{
			element.alpha = 0.6;
			element.mouseChildren = element.mouseEnabled = false;
			element.clearHoverEffect();
		}
		
		/**
		 */		
		public function addToTemGroup(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			group.push(element);
			
			return group;
		}
		
		
		
		
		
		
		//-----------------------------------------------
		//
		// 状态切换
		//
		//-------------------------------------------------
		
		
		/**
		 * 选择状态
		 */
		public function toSelected():void
		{
			
		}
		
		/**
		 * 没选择状态
		 */
		public function toUnSelected():void
		{
			
		}
		
		/**
		 * 多选状态
		 */
		public function toMultiSelection():void
		{
		}
		
		/**
		 */		
		public function toPrevState():void
		{
			
		}
		
		/**
		 */		
		public function returnFromPrevState():void
		{
			
		}
		
		/**
		 * 进入到组合状态，此元件被纳入组合的子元件
		 */		
		public function toGroupState():void
		{
			
		}
	}
}