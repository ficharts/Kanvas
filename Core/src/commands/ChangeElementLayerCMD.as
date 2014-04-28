package commands
{
	import flash.display.DisplayObjectContainer;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 */	
	public final class ChangeElementLayerCMD extends Command
	{
		public function ChangeElementLayerCMD()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			element = CoreFacade.coreMediator.currentElement;
			parent  = element.parent;
			oldLayer = element.index;
			newLayer = int(notification.getBody());
			setLayer(newLayer, true);
			
			UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			setLayer(oldLayer);
			
		}
		
		override public function redoHandler():void
		{
			setLayer(newLayer);
		}
		
		/**
		 */		
		private function setLayer(layer:int, exec:Boolean = false):void
		{
			if (parent && element)
			{
				parent.setChildIndex(element, layer);
				if (exec)
					v = CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
				else
					CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			}
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:ElementBase;
		
		private var oldLayer:int;
		private var newLayer:int;
		
		private var parent:DisplayObjectContainer;
		
		private var v:Vector.<PageVO>;
	}
}