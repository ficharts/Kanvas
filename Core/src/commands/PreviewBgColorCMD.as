package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 *  预览背景色，新背景颜色信息不反馈至UI层
	 */	
	public class PreviewBgColorCMD extends Command
	{
		public function PreviewBgColorCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			
			CoreFacade.coreProxy.bgColorIndex = uint(notification.getBody());
			CoreFacade.coreProxy.updateBgColor();
			sendNotification(Command.RENDER_BG_COLOR);
			
		}
	}
}