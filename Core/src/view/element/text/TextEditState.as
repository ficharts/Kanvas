package view.element.text
{
	import com.kvs.utils.RexUtil;
	
	import view.element.ElementEvent;
	
	import flash.text.TextField;
	
	import view.element.ElementBase;
	import view.element.state.ElementStateBase;
	import view.element.state.IEditShapeState;

	/**
	 * 文本框的编辑状态
	 */	
	public class TextEditState extends ElementStateBase implements IEditShapeState
	{
		public function TextEditState(element:ElementBase)
		{
			super(element);
		}
		/**
		 */		
		override public function toUnSelected():void
		{
			element.currentState = element.unSelectedState;
			element.enable();
		}
		
		/**
		 */		
		public function toEditState():void
		{
			
		}
		
		override public function enable():void
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
		
		
	}
}