package view.element.text
{
	import model.CoreFacade;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.element.state.ElementStateBase;
	import view.element.state.IEditShapeState;

	/**
	 * 文本框的选择状态
	 */	
	public class TextSelectState extends ElementStateBase implements IEditShapeState
	{
		public function TextSelectState(element:ElementBase)
		{
			super(element);
		}
		
		
		/**
		 */		
		override public function del():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.DEL_TEXT, element));
		}
		
		/**
		 * 当前状态鼠标按下后处理方法
		 */
		override public function clicked():void
		{
			toEditState();
		}
		
		/**
		 */		
		override public function toUnSelected():void
		{
			element.currentState = element.unSelectedState;
		}
		
		/**
		 */		
		override public function toSelected():void
		{
		}
		
		/**
		 * 多选状态
		 */
		override public function toMultiSelection():void
		{
			element.currentState = element.multiSelectedState;
		}
		
		/**
		 * 
		 */		
		public function toEditState():void
		{
			element.currentState = (element as TextEditField).editTextState as ElementStateBase;
			
			element.dispatchEvent(new ElementEvent(ElementEvent.EDIT_TEXT, element));
			(element as TextEditField).clearText();
			element.disable();
		}
	}
}