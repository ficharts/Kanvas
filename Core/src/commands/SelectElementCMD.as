package commands
{
	import org.puremvc.as3.interfaces.INotification;
	
	import view.MediatorNames;
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 * 设置当前元素, 设置其为选择状态，切换主场景的状态也为选择状态
	 * 
	 * 开启型变框；便捷工具条由图形主动开启，每种图形对应各自工具条
	 */
	public class SelectElementCMD extends Command
	{
		
		/**
		 */		
		public function SelectElementCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			var coreMdt:CoreMediator = facade.retrieveMediator(MediatorNames.CORE_MEDIATOR) as CoreMediator;
			
			coreMdt.createNewShapeTweenOver = false;
			coreMdt.createNewShapeMouseUped = false;
			
			coreMdt.currentElement = notification.getBody() as ElementBase;
			coreMdt.currentElement.toSelectedState();
			
			//trace("SelectElementCMD.excute() index:"+coreMdt.currentElement.index)
			
			coreMdt.toSelectedMode();
			
			//防止键盘移动元件时智能组合实效，默认点击元件才会启用智能组合
			coreMdt.checkAutoGroup(coreMdt.currentElement);
			
			//判断元素的坐标是否超出屏幕一半
			coreMdt.autofitController.autofitElementPosition(coreMdt.currentElement);
			
		}
	}
}