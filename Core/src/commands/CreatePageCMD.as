package commands
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.ElementProxy;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.StyleUtil;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 */	
	public final class CreatePageCMD extends Command
	{
		public function CreatePageCMD()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			//来自于工具面板触发的创建，
			var pageProxy:ElementProxy = notification.getBody() as ElementProxy;
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
			pageProxy.type = "page";
			pageProxy.styleType = "shape";
			pageProxy.styleID = "Page";
			ifSelectedAfterCreate = pageProxy.ifSelectedAfterCreate;
			
			// VO 初始化
			pageVO = ElementCreator.getElementVO(pageProxy.type) as PageVO;
			
			var point:Point = LayoutUtil.stagePointToElementPoint(pageProxy.x, pageProxy.y, layoutTransformer.canvas);
			pageVO.x = point.x;
			pageVO.y = point.y;
			pageVO.rotation = pageProxy.rotation;
			pageVO.width = pageProxy.width;
			pageVO.height = pageProxy.height;
			pageVO.styleType = pageProxy.styleType;
			
			// 样式初始化,
			StyleUtil.applyStyleToElement(pageVO, pageProxy.styleID);
			
			// UI 初始化
			element = ElementCreator.getElementUI(pageVO) as ElementBase;
			
			// 新创建图形的比例总是与画布比例互补，保证任何时候创建的图形看起来是标准大小
			pageVO.scale = layoutTransformer.compensateScale;
			
			CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageProxy.index);
			CoreFacade.addElement(element);
			
			//放置拖动创建时 当前原件未被指定 
			CoreFacade.coreMediator.currentElement = element;
			
			//开始缓动，将此设为false当播放完毕且鼠标弹起时进入选择状态
			CoreFacade.coreMediator.createNewShapeTweenOver = false;
			
			// 图形创建时 添加动画效果
			TweenLite.from(element, pageProxy.flashTime, {alpha: 0, scaleX : 0, scaleY : 0, ease: Back.easeOut, onComplete: shapeCreated});
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var ifSelectedAfterCreate:Boolean;
		
		/**
		 */		
		private function shapeCreated():void
		{
			oldIndex = CoreFacade.coreMediator.autoLayerController.autoLayer(element);
			if (oldIndex)
			{
				indexChangeElements = CoreFacade.coreMediator.autoLayerController.indexChangeElement;
				newIndex = new Vector.<int>;
				var length:int = indexChangeElements.length;
				for (var i:int = 0; i <　length; i++)
					newIndex[i] = indexChangeElements[i].index;
			}
			
			pageIndex = pageVO.index;
			
			//动画完毕
			
			if (ifSelectedAfterCreate)
			{
				CoreFacade.coreMediator.createNewShapeTweenOver = true;
				if (CoreFacade.coreMediator.createNewShapeTweenOver && CoreFacade.coreMediator.createNewShapeMouseUped)
					sendNotification(Command.SElECT_ELEMENT, element);
			}
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			if (indexChangeElements)
				CoreFacade.coreMediator.autoLayerController.swapElements(indexChangeElements, oldIndex);
			CoreFacade.removeElement(element);
			CoreFacade.coreMediator.pageManager.removePage(element.vo as PageVO);
			
			this.dataChanged();
		}
		
		override public function redoHandler():void
		{
			CoreFacade.addElement(element);
			if (indexChangeElements)
				CoreFacade.coreMediator.autoLayerController.swapElements(indexChangeElements, newIndex);
			CoreFacade.coreMediator.pageManager.addPageAt(element.vo as PageVO, pageIndex);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:ElementBase;
		private var pageVO:PageVO;
		
		private var oldIndex:Vector.<int>;
		
		private var newIndex:Vector.<int>;
		
		private var indexChangeElements:Vector.<ElementBase>;
		
		private var pageIndex:int;
	}
}