package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * 复制临时组合
	 */	
	public class CopyTemGroupCMD extends Command
	{
		public function CopyTemGroupCMD()
		{
			super();
		}
		
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			CoreFacade.coreMediator.setElementForPaste();
			CoreFacade.coreMediator.multiSelectControl.copy();
		}
	}
}