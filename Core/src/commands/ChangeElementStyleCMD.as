package commands
{
	import model.CoreFacade;
	import model.CoreProxy;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.StyleUtil;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 * 改变元素的整体样式，包括边框于填充
	 */	
	public class ChangeElementStyleCMD extends Command
	{
		public function ChangeElementStyleCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			element = CoreFacade.coreMediator.currentElement;
			
			oldStyleID = element.vo.styleID;
			newStyleID = notification.getBody().toString();
			
			setStyle(newStyleID, true);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			setStyle(oldStyleID);
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			setStyle(newStyleID);
		}
		
		/**
		 */		
		private function setStyle(id:String, exec:Boolean = false):void
		{
			element.vo.styleID = id;
			StyleUtil.applyStyleToElement(element.vo);
			element.render();
			
			if (exec)
				v = CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
			else
				CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		private var oldStyleID:String;
		private var newStyleID:String;
		
		/**
		 */		
		private var element:ElementBase;
		
		private var v:Vector.<PageVO>;
	}
}