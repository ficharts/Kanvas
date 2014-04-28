package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.imgElement.ImgElement;

	/**
	 */	
	public class DeleteImgCMDBase extends Command
	{
		public function DeleteImgCMDBase()
		{
			super();
		}
		
		/**
		 * 如果图片原始数据不再被其他图片元素共用，则取消其在图片库中的引用；
		 * 
		 * 撤销时重新注册到图片库中
		 * 
		 * 图片的删除并不会直接从服务器端删除，最多从kanvas的图片库中删除数据
		 * 
		 * 服务器端负责无效图片数据的统一清理
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			element = notification.getBody() as ImgElement;
			
			elementIndex = element.index;
			
			CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
			CoreFacade.removeElement(element);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			
			v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(element, elementIndex);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.addPageAt(element.vo.pageVO, element.vo.pageVO.index);
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(element);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		protected var element:ImgElement;
		
		protected var elementIndex:int;
		
		private var v:Vector.<PageVO>;
	}
}