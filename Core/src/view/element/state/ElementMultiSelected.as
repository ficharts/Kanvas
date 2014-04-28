package view.element.state
{
	import view.element.ElementBase;
	import view.element.ElementEvent;
	
	/**
	 * 多选状态
	 */
	public class ElementMultiSelected extends ElementStateBase
	{
		public function ElementMultiSelected(element:ElementBase)
		{
			super(element);
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
			element.dispatchEvent(new ElementEvent(ElementEvent.START_MOVE_TEM_GROUP));
		}
		
		/**
		 */		
		override public function stopMove():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.STOP_MOVE_TEM_GROUP));
		}
		
		/**
		 */
		override public function clicked():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.TEM_GROUP_CHILD_CLICKED, element));
		}
		
		/**
		 */		
		override public function mouseDown():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.TEM_GROUP_CHILD_DOWN));
		}
		
		/**
		 */		
		override public function mouseUp():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.TEM_GROUP_CHILD_UP));
		}
		
		/**
		 */		
		override public function toSelected():void
		{
			element.currentState = element.selectedState;
			element.enableBG();
		}
		
		/**
		 * 没选择状态
		 */
		override public function toUnSelected():void
		{
			element.currentState = element.unSelectedState;
			element.disableBG();
			
			element.clearHoverEffect();
		}
		
		/**
		 */		
		override public function toGroupState():void
		{
			element.clearHoverEffect();
			element.mouseChildren = element.mouseEnabled = false;
			
			element.currentState = element.groupState;
		}
		
		/**
		 */				
		override public function disable():void
		{
			element.mouseChildren = element.mouseEnabled = false;
		}
	}
}