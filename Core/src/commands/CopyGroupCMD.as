package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * 复制组合
	 */	
	public class CopyGroupCMD extends Command
	{
		public function CopyGroupCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			CoreFacade.coreMediator.setElementForPaste();
		}
	}
}