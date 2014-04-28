package view.interact.keyboard
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import view.interact.CoreMediator;
	
	/**
	 * 键盘文档编辑状态
	 */
	public class DisKeyboardState extends KeyboardStateBase
	{
		public function DisKeyboardState(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 *去默认状态 
		 */
		override public function toEnableState():void
		{
			mainUIMediator.currentKeyboardState = mainUIMediator.enableKeyboardState;
		}
		
		/**
		 *键盘事件处理 
		 */
		override public function keyDownBoardHandler(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.ESCAPE:
					
					mainUIMediator.esc();
					
					break;
			}
		}
		
		/**
		 */		
		override public function keyUpBoardHandler(evt:KeyboardEvent):void
		{
		}
	}
}