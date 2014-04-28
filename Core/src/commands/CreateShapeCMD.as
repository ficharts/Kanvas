package commands
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.ElementProxy;
	import model.vo.ElementVO;
	import model.vo.PageVO;
	import model.vo.ShapeVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.StyleUtil;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.Camera;
	import view.element.ElementBase;
	import view.element.PageElement;
	
	/**
	 * 创建形状
	 */
	public class CreateShapeCMD extends Command
	{
		
		/**
		 */		
		public function CreateShapeCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			//来自于工具面板触发的创建，
			var elementProxy:ElementProxy = notification.getBody() as ElementProxy;
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
			// VO 初始化
			var elementVO:ElementVO = ElementCreator.getElementVO(elementProxy.type);
			
			var point:Point = LayoutUtil.stagePointToElementPoint(elementProxy.x, elementProxy.y, layoutTransformer.canvas);
			elementVO.x = point.x;
			elementVO.y = point.y;
			elementVO.rotation = elementProxy.rotation;
			elementVO.width = elementProxy.width;
			elementVO.height = elementProxy.height;
			elementVO.styleType = elementProxy.styleType;
			
			// 样式初始化,
			StyleUtil.applyStyleToElement(elementVO, elementProxy.styleID);
			
			if (elementVO is ShapeVO)
				(elementVO as ShapeVO).radius = elementProxy.radius;
			
			// UI 初始化
			element = ElementCreator.getElementUI(elementVO) as ElementBase;
			
			// 新创建图形的比例总是与画布比例互补，保证任何时候创建的图形看起来是标准大小
			elementVO.scale = layoutTransformer.compensateScale;
			(element is Camera) ? CoreFacade.addElementAt(element, 1) : CoreFacade.addElement(element);
			
			//放置拖动创建时 当前原件未被指定 
			CoreFacade.coreMediator.currentElement = element;
			
			//开始缓动，将此设为false当播放完毕且鼠标弹起时进入选择状态
			CoreFacade.coreMediator.createNewShapeTweenOver = false;
			
			// 图形创建时 添加动画效果
			TweenLite.from(element, elementProxy.flashTime, {alpha: 0, scaleX : 0, scaleY : 0, ease: Back.easeOut, onComplete: shapeCreated});
			
			this.dataChanged();
		}
		
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
			//动画完毕
			CoreFacade.coreMediator.createNewShapeTweenOver = true;
			if (CoreFacade.coreMediator.createNewShapeTweenOver && CoreFacade.coreMediator.createNewShapeMouseUped)
			{
				if (element.screenshot)
					CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
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
			CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
			
			this.dataChanged();
		}
		
		override public function redoHandler():void
		{
			CoreFacade.addElement(element);
			if (indexChangeElements)
				CoreFacade.coreMediator.autoLayerController.swapElements(indexChangeElements, newIndex);
			CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:ElementBase;
		
		private var oldIndex:Vector.<int>;
		
		private var newIndex:Vector.<int>;
		
		private var indexChangeElements:Vector.<ElementBase>;
		
		private var pageIndex:int;
	}
}