package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 * 改变元素样式
	 */	
	public final class ChangeElementColorCMD extends Command
	{
		public function ChangeElementColorCMD()
		{
			super();
		}
		
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			element = CoreFacade.coreMediator.currentElement;
			
			oldColorObj = notification.getBody();
			newColorObj = {color:element.vo.color, colorIndex:element.vo.colorIndex};
			
			changColor(newColorObj, true);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			changColor(oldColorObj);
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			changColor(newColorObj);
		}
		
		/**
		 */		
		private function changColor(obj:Object, exec:Boolean = false):void
		{
			element.vo.color = obj.color;
			element.vo.colorIndex = obj.colorIndex;
			element.render();
			if (exec)
				v = CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
			else
				CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:ElementBase;
		
		/**
		 */	
		private var oldColorObj:Object;
		
		/**
		 */	
		private var newColorObj:Object;
		
		private var v:Vector.<PageVO>;
	}
}