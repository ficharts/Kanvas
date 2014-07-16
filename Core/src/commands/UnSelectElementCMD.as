package commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.MediatorNames;
	import view.interact.CoreMediator;
	
	/**
	 * 取消选择，单前图形切换到非选择状态，型变框关闭，主应用切换至非选择状态
	 */	
	public class UnSelectElementCMD extends SimpleCommand
	{
		public function UnSelectElementCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			var mainMediator:CoreMediator = facade.retrieveMediator(MediatorNames.CORE_MEDIATOR) as CoreMediator;
			
			if (mainMediator.currentElement)
			{
				mainMediator.currentElement.toUnSelectedState();
				mainMediator.currentElement = null;
				
				if (mainMediator.curInteractElement)
					mainMediator.curInteractElement = null;
				
			}
			else if (mainMediator.curInteractElement)//为了防止有时文字不能被选择
			{
				mainMediator.curInteractElement.toUnSelectedState();
				mainMediator.curInteractElement = null;
			}
			else
			{
				
			}
			
			mainMediator.toUnSelectedMode();
			
		}
	}
}