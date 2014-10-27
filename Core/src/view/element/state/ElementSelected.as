package view.element.state
{
	import flash.display.Sprite;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	
	/**
	 * 选中状态
	 */
	public class ElementSelected extends ElementStateBase
	{
		public function ElementSelected(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 */		
		override public function del():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.DEL_SHAPE, element));
		}
		
		/**
		 * 再次click已处于选择状态下的图形会，取消选择，然后创建文本框
		 */
		override public function clicked():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.RE_CLICKED, element));
		}
		
		/**
		 * 此时型变框会虚化
		 */		
		override public function mouseDown():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.RE_DOWN, element));
		}
		
		/**
		 * 没选择状态
		 */
		override public function toUnSelected():void
		{
			element.currentState = element.unSelectedState;
			element.disableBG();
		}
		
		/**
		 */		
		override public function disable():void
		{
			super.disable();
			
			toUnSelected();
		}
		
		/**
		 * 多选状态
		 */
		override public function toMultiSelection():void
		{
			element.currentState = element.multiSelectedState;
		}
		
		/**
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			element.mouseChildren = element.mouseEnabled = false;
			element.clearHoverEffect();
			
			element.currentState = element.prevState;
			
			element.returnFromPrevFun = function():void{
				element.mouseChildren = element.mouseEnabled = true;
				element.currentState = element.selectedState;
				element.currentState.drawPageNum();
			}
		}
	}
}