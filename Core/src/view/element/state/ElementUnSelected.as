package view.element.state
{
	import view.element.ElementEvent;
	
	import view.element.ElementBase;
	
	/**
	 * 没选中状态
	 */
	public class ElementUnSelected extends ElementStateBase
	{
		public function ElementUnSelected(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 * 当前状态鼠标按下后处理方法
		 */
		override public function clicked():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.FIRST_CLICKED, element));
		}
		
		/**
		 * 此时如果其他元素被选择，则关闭其型变框
		 */		
		override public function mouseDown():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.FIRST_DOWN, element));
		}
		
		/**
		 * 进入选择状态，激活背景，设置为当前图形
		 */
		override public function toSelected():void
		{
			element.currentState = element.selectedState;
			element.enableBG();
		}
		
		/**
		 */		
		override public function toUnSelected():void
		{
			
		}
		
		/**
		 * 多选状态
		 */
		override public function toMultiSelection():void
		{
			element.currentState = element.multiSelectedState;
			element.showHoverEffect();
		}
		
		/**
		 */		
		override public function toGroupState():void
		{
			element.mouseChildren = element.mouseEnabled = false;
			element.clearHoverEffect();
			
			element.currentState = element.groupState;
		}
		
		/**
		 */		
		override public function toPrevState():void
		{
			element.enable();
			element.clearHoverEffect();
			element.mouseChildren = element.mouseEnabled = false;
			element.currentState = element.prevState;
			
			element.returnFromPrevFun = function():void{
				element.mouseChildren = element.mouseEnabled = true;
				element.currentState = element.unSelectedState;
			}
		}
		
	}
}