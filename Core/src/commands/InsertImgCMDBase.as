package commands
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.vo.ImgVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.imgElement.ImgElement;
	import view.ui.Canvas;

	/**
	 * 
	 * @author wallenMac
	 * 
	 */	
	public class InsertImgCMDBase extends Command
	{
		public function InsertImgCMDBase()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
		}
		
		/**
		 */		
		protected function createImg(bmd:BitmapData, imgID:uint):void
		{
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
			// 元素ID与图片资源ID单独管理
			var imgVO:ImgVO = new ImgVO();
			imgVO.id = ElementCreator.id;
			imgVO.imgID = imgID;
			imgVO.sourceData = bmd;
			
			imgVO.width = imgVO.sourceData.width;
			imgVO.height = imgVO.sourceData.height;
			
			//防止图片太大，，这里提前缩小图片比例
			var maxSize:Number;
			var imgScale:Number = 1;
			if (imgVO.width > imgVO.height)
				maxSize = imgVO.width;
			else
				maxSize = imgVO.height;
			
			if (maxSize > MAX_SIZE)
				imgScale = MAX_SIZE / maxSize;
			
			var canvas:Canvas = CoreFacade.coreMediator.canvas;
			
			imgVO.scale = layoutTransformer.compensateScale * imgScale;
			imgVO.rotation = -canvas.rotation;
			var x:Number = canvas.stage.stageWidth / 2;
			var y:Number = canvas.stage.stageHeight / 2;
			var p:Point = LayoutUtil.stagePointToElementPoint(x, y, canvas);
			imgVO.x = p.x;
			imgVO.y = p.y;
			
			element = new ImgElement(imgVO);
			CoreFacade.addElement(element);
			
			elementIndex = CoreFacade.getElementIndex(element);
			
			this.sendNotification(Command.SElECT_ELEMENT, element);
			
			// 图形创建时 添加动画效果
			TweenLite.from(element, 0.3, {alpha: 0, scaleX : 0, scaleY : 0, ease: Back.easeOut, onComplete: created});
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		private function created():void
		{
			CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(element);
		}
		
		/**
		 */		 
		override public function undoHandler():void
		{
			CoreFacade.removeElement(element);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(element, elementIndex);
			
			this.dataChanged();
		}
		
		/**
		 */		
		protected const MAX_SIZE:uint = 500;
		
		/**
		 */		
		protected var elementIndex:int;
		
		/**
		 */		
		protected var element:ImgElement;
	}
}