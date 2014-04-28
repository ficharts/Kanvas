package commands
{
	import model.CoreFacade;
	import model.CoreProxy;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;

	/**
	 * 设置样式模板
	 */	
	public class SetThemeCMD extends Command
	{
		public function SetThemeCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
				
			proxy = CoreFacade.coreProxy;
			
			oldStyle = proxy.currStyle;
			newStyle = notification.getBody().theme;
			var redoable:Boolean = notification.getBody().redoable;
			if (setStyle(newStyle, true) && redoable) 
				UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			setStyle(oldStyle);
		}
		
		override public function redoHandler():void
		{
			setStyle(newStyle);
		}
		
		/**
		 */		
		private function setStyle(value:String, exec:Boolean = false):Boolean
		{
			var result:Boolean = proxy.isHasStyle(value);
			
			if (result)
			{
				//更新图形和背景的样式信息
				proxy.setCurrTheme(value);
				
				//绘制所有图形  
				proxy.renderElements();
				
				var coreApp:CoreApp = CoreFacade.coreMediator.coreApp as CoreApp
				
				//更新文本编辑器样式属性
				coreApp.textEditor.initStyle();
				
				//绘制背景
				sendNotification(Command.RENDER_BG_COLOR, proxy.bgColor);
				
				// 通知UI更新
				coreApp.themeUpdated(value);
				coreApp.bgColorsUpdated(proxy.bgColorsXML);
				coreApp.bgColorUpdated(proxy.bgColorIndex);
				
				if (exec)
				{
					for each (var vo:PageVO in CoreFacade.coreMediator.pageManager.pages)
						CoreFacade.coreMediator.pageManager.registUpdateThumbVO(vo);
					v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
				}
				else
				{
					CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
				}
			}
			
			return result;
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var oldStyle:String = '';
		private var newStyle:String;
		
		private var proxy:CoreProxy;
		
		private var v:Vector.<PageVO>;
	}
}