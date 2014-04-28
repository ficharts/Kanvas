package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	/**
	 * 复制一般元素
	 */
	public class CopyElementCMD extends Command
	{
		/**
		 */		
		public function CopyElementCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			CoreFacade.coreMediator.setElementForPaste();
			CoreFacade.coreMediator.autoGroupController.copyElements();
		}
		
	}
}