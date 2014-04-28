package commands
{
	import org.puremvc.as3.interfaces.INotification;
	import model.CoreFacade;
	
	/**
	 */	
	public class AutoZoomCMD extends Command
	{
		public function AutoZoomCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			CoreFacade.coreMediator.zoomAuto();
		}
	}
}