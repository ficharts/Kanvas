package view.interact.keyboard
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import view.interact.CoreMediator;
	

	/**
	 * 键盘事件机制状态基类
	 */
	public class KeyboardStateBase
	{
		public function KeyboardStateBase(mainMediator:CoreMediator)
		{
			this.mainUIMediator = mainMediator;
		}
		
		/**
		 * 键盘生效状态
		 */
		public function toEnableState():void
		{
			
		}
		
		/**
		 * 键盘实效状态
		 */
		public function toDisableState():void
		{
			
		}
		
		/**
		 *键盘事件处理 
		 * 
		 */
		public function keyDownBoardHandler(evt:KeyboardEvent):void
		{
			
		}
		
		public function keyUpBoardHandler(evt:KeyboardEvent):void
		{
			
		}
		
		/**
		 * 鼠标事件处理
		 * @param evt
		 * 
		 */
		public function mouseHandler(evt:MouseEvent):void
		{
			
		}
		
		/**
		 * 总画布的控制器
		 */	
		protected var mainUIMediator:CoreMediator;
	}
}