package commands
{
	
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.ProxyNames;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.MediatorNames;
	import view.interact.CoreMediator;
	
	/**
	 * 预创建文本，此时开启文本输入框，输入文本;
	 */	
	public class PreCreateTextCMD extends SimpleCommand
	{
		public function PreCreateTextCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			var canvasProxy:CoreProxy = facade.retrieveProxy(ProxyNames.CORE_PROXY) as CoreProxy;
			var mainMediator:CoreMediator = facade.retrieveMediator(MediatorNames.CORE_MEDIATOR) as CoreMediator;
			
			this.sendNotification(Command.UN_SELECT_ELEMENT);
			
			// 定位文本编辑器的位置
			var rect:Rectangle = new Rectangle;
			rect.x = mainMediator.canvas.stage.mouseX;
			rect.y = mainMediator.canvas.stage.mouseY;
			
			mainMediator.setEditorASText();
			mainMediator.willCreateElement(rect);
			
			CoreFacade.coreMediator.autofitController.autofitEditorInputText();
		}
	}
}