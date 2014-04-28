package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * 绘制背景颜色，此命令不具有回撤功能
	 */	
	public class RenderBgColorCMD extends Command
	{
		public function RenderBgColorCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			CoreFacade.coreMediator.renderBGWidthColor(CoreFacade.coreProxy.bgColor);
		}
	}
}