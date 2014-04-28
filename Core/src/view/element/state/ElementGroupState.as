package view.element.state
{
	import view.element.ElementBase;
	
	/**
	 * 组合状态， 组合的子元素处于这种状态
	 * 
	 * 处于这种状态下的元件是无法响应鼠标交互的
	 * 
	 * 即便在画布缩放的过程中也无法切换到交互状态
	 */	
	public class ElementGroupState extends ElementStateBase
	{
		public function ElementGroupState(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 * 组合和其子元件不可以被智能组合
		 */		
		override public function get canAutoGrouped():Boolean
		{
			return false;
		}
		
		/**
		 */		
		override public function addToTemGroup(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			return group;
		}
		
		/**
		 */		
		override public function toMultiSelection():void
		{
			element.currentState = element.multiSelectedState;
			
			element.mouseChildren = element.mouseEnabled = true;
			element.showHoverEffect();
		}
		
		/**
		 */
		override public function mouseOver():void
		{
		}
		
		/**
		 */
		override public function mouseOut():void
		{
		}
		
		/**
		 */		
		override public function startMove():void
		{
		}
		
		/**
		 */		
		override public function stopMove():void
		{
		}
		
		/**
		 */		
		override public function enable():void
		{
		}
		
		/**
		 */		
		override public function disable():void
		{
		}
		
		/**
		 */		
		override public function toPrevState():void
		{
			element.currentState = element.prevState;
			
			element.returnFromPrevFun = function():void{
				element.currentState = element.groupState;
			}
		}
	}
}