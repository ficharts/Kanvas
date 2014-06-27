package commands
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	import model.vo.SWFVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.imgElement.ImgElement;
	import view.element.imgElement.ImgElementBase;
	import view.element.imgElement.SWFElement;
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
		protected function createImg(data:Object, imgID:uint, fileData:ByteArray = null):void
		{
			var vo:ElementVO;
			
			if (data is BitmapData)
			{
				// 元素ID与图片资源ID单独管理
				vo = new ImgVO();
				var imgVO:ImgVO = vo as ImgVO;
				
				imgVO.id = ElementCreator.id;
				imgVO.imgID = imgID;
				imgVO.viewData = data as BitmapData;
				
				imgVO.width = imgVO.viewData.width;
				imgVO.height = imgVO.viewData.height;
				
				layoutVO(vo);
				
				element = new ImgElement(imgVO);
			}
			else
			{
				vo = new SWFVO;
				var swfVO:SWFVO = vo as SWFVO;
				
				swfVO.id = ElementCreator.id;
				swfVO.imgID = imgID;
				
				swfVO.viewData = data;
				swfVO.fileBytes = fileData;
				
				swfVO.width = swfVO.viewData.width;
				swfVO.height = swfVO.viewData.height;
				
				layoutVO(vo);
				
				element = new SWFElement(swfVO);
			}
			
			CoreFacade.addElement(element);
			
			elementIndex = CoreFacade.getElementIndex(element);
			
		//	this.sendNotification(Command.SElECT_ELEMENT, element);
			
			// 图形创建时 添加动画效果
			TweenLite.from(element, 0.3, {alpha: 0, scaleX : 0, scaleY : 0, ease: Back.easeOut, onComplete: created});
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private function layoutVO(vo:ElementVO):void
		{
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
			//防止图片太大，，这里提前缩小图片比例
			var maxSize:Number;
			var imgScale:Number = 1;
			if (vo.width > vo.height)
				maxSize = vo.width;
			else
				maxSize = vo.height;
			
			if (maxSize > MAX_SIZE)
				imgScale = MAX_SIZE / maxSize;
			
			var canvas:Canvas = CoreFacade.coreMediator.canvas;
			
			vo.scale = layoutTransformer.compensateScale * imgScale;
			vo.rotation = -canvas.rotation;
			var x:Number = canvas.stage.stageWidth / 2;
			var y:Number = canvas.stage.stageHeight / 2;
			var p:Point = LayoutUtil.stagePointToElementPoint(x, y, canvas);
			vo.x = p.x;
			vo.y = p.y;
		}
		
		/**
		 */		
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
		protected var element:ImgElementBase;
	}
}