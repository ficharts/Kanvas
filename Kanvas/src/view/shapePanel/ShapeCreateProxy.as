package view.shapePanel
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	import model.ElementProxy;
	
	import view.shapePanel.pageForCreateCompt.CreateShapeEvent;

	/**
	 * 通用图形创建控制器， 负责与核心应用打交道，告知core创建
	 * 
	 * 图形
	 */	
	public class ShapeCreateProxy
	{
		public function ShapeCreateProxy(mainApp:Kanvas)
		{
			this.mainApp = mainApp;
			
			shapeDragCreatIcon.mouseEnabled = false;
			mainApp.stage.addChild(shapeDragCreatIcon);
			
			mainApp.addEventListener(CreateShapeEvent.SHAPE_CLICKED, shapeClickedHandler, false, 0, true);
			mainApp.addEventListener(CreateShapeEvent.SHAPE_START_MOVE, startDragShapeHandelr, false, 0, true);
			mainApp.addEventListener(CreateShapeEvent.SHAPE_STOP_MOVE, endDragShapeHandler, false, 0, true);
		}
		
		/**
		 * 画布中心点创建一个图形
		 */		
		private function shapeClickedHandler(evt:CreateShapeEvent):void
		{
			evt.stopPropagation();
			
			CoreFacade.coreMediator.createNewShapeMouseUped = true;
			
			evt.shapeIcon.shape.x = mainApp.stage.stageWidth / 2;
			evt.shapeIcon.shape.y = mainApp.stage.stageHeight / 2;
			evt.shapeIcon.shape.rotation = - core.canvas.rotation;
			
			evt.shapeIcon.shape.flashTime = 0.5;
			core.createShape(evt.shapeIcon.shape);
		}
		
		/**
		 * 拖放图形到指定位置并创建其;
		 */		
		private function startDragShapeHandelr(evt:CreateShapeEvent):void
		{
			isShapeCreating = false;
			
			currShape = evt.shapeIcon.shape;
			
			var rect:Rectangle = evt.shapeIcon.getRect(mainApp.stage);
			var bmd:BitmapData = BitmapUtil.getBitmapData(evt.shapeIcon, true);
			
			BitmapUtil.drawBitmapDataToSprite(bmd, shapeDragCreatIcon, bmd.width, bmd.height);
			
			shapeDragCreatIcon.x = rect.x;
			shapeDragCreatIcon.y = rect.y;
			shapeDragCreatIcon.startDrag();
			
			mainApp.stage.addEventListener(MouseEvent.MOUSE_MOVE, outShapePanelHandler, false, 0, true);
		}
		
		/**
		 */		
		private function outShapePanelHandler(evt:MouseEvent):void
		{
			if (shapeDragCreatIcon.x < mainApp.stage.stageWidth - mainApp.shapePanel.w - shapeDragCreatIcon.width)
			{
				var rect:Rectangle = shapeDragCreatIcon.getRect(mainApp.stage);
				
				stopDrag();
				
				rect.x += rect.width / 2;
				rect.y += rect.height / 2;
				
				currShape.x = rect.x;
				currShape.y = rect.y;
				currShape.rotation = - mainApp.kvsCore.canvas.rotation;
				
				core.createShape(currShape);
				
				core.hideSelector();
				core.startDragElement();
				isShapeCreating = true;
			}
		}
		
		/**
		 */		
		private function stopDrag():void
		{
			shapeDragCreatIcon.stopDrag();
			shapeDragCreatIcon.graphics.clear();
			mainApp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, outShapePanelHandler);
		}
		
		/**
		 * 
		 */		
		private var isShapeCreating:Boolean = false;
		
		/**
		 */		
		private var currShape:ElementProxy;
		
		/**
		 *  图形创建时拖放示意图片
		 */		
		private var shapeDragCreatIcon:Sprite = new Sprite;
		
		/**
		 */		
		private function endDragShapeHandler(evt:CreateShapeEvent):void
		{
			if (isShapeCreating)
			{
				core.endDragElement();
				
				// 抖动效果
				var tgtScale:Number = core.currentElement.scale * 0.8;
				TweenLite.killTweensOf(core.currentElement, true);
				TweenLite.from(core.currentElement, 1, {scaleX: tgtScale, scaleY: tgtScale, ease: Elastic.easeOut});
				core.showSelector();
				
				isShapeCreating = false;
			}
			else
			{
				stopDrag();
			}
			
		}
		
		/**
		 */		
		private function get core():CoreApp
		{
			return mainApp.kvsCore;
		}
		
		/**
		 */		
		private var mainApp:Kanvas;
	}
}