package view.interact
{
	import commands.Command;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.vo.PageVO;
	
	import util.LayoutUtil;
	import util.layout.LayoutTransformer;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.elementSelector.ElementSelector;
	import view.interact.multiSelect.TemGroupElement;

	/**
	 * 元素移动控制器
	 */	
	public class ElementMoveController
	{
		public function ElementMoveController(mdt:CoreMediator)
		{
			this.coreMdt = mdt;
		}
		
		/**
		 */		
		public function startMove(element:ElementBase):void
		{
			stageStartX = mainUI.stage.mouseX;
			stageStartY = mainUI.stage.mouseY;
			
			mainUI.stage.addEventListener(MouseEvent.MOUSE_MOVE, movingElementHandler, false, 0, true);
			//var element:ElementBase = element;
			curMovingElement = element;
			
			// 选择器的位置是基准, 移动图形时先移动选择器，然后从选择器同步到图形
			var point:Point = LayoutUtil.elementPointToStagePoint(curMovingElement.x, curMovingElement.y, coreMdt.canvas);
			
			selectorStartX = selector.x = point.x;
			selectorStartY = selector.y = point.y;
			
			oldPropertyObj = {};
			oldPropertyObj.x = element.x;
			oldPropertyObj.y = element.y;
			
			group = ((curMovingElement is TemGroupElement) || (curMovingElement is GroupElement));
		}
		
		private var selectorStartX:Number;
		private var selectorStartY:Number;
		
		/**
		 * 
		 * 移动图形的时候需要同步移动鼠标感应效果框
		 */		
		private function movingElementHandler(evt:MouseEvent):void
		{
			evt.updateAfterEvent();
			
			var disX:Number = mainUI.stage.mouseX - stageStartX;
			var disY:Number = mainUI.stage.mouseY - stageStartY;
			
			selector.x = selectorStartX + disX;
			selector.y = selectorStartY + disY;
			coreMdt.currentMode.drawShotFrame();
			
			// 元素的移动是基于选择其的位置的
			var elementPoint:Point = LayoutUtil.stagePointToElementPoint(selector.x, selector.y, selector.coreMdt.canvas);
			curMovingElement.x = point.x = elementPoint.x;
			curMovingElement.y = point.y = elementPoint.y;
			
			
			align = coreMdt.autoAlignController.checkPosition(curMovingElement);
			
			var selectorPoint:Point = LayoutUtil.elementPointToStagePoint(curMovingElement.x, curMovingElement.y, coreMdt.canvas);
			selector.x = selectorPoint.x;
			selector.y = selectorPoint.y;
			
			if (curMovingElement.autoGroupChangable)
			{
				coreMdt.autoGroupController.move(curMovingElement.x - curMovingElement.vo.x, 
												 curMovingElement.y - curMovingElement.vo.y, group);
			}
		}
		
		/**
		 */		
		public function stopMove():void
		{
			mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingElementHandler);
			coreMdt.currentMode.moveElementEnd();
			
			if (align)
			{
				if (curMovingElement == null) return;
				if (! isNaN(align.x))
					point.x = curMovingElement.x + align.x;
				if (! isNaN(align.y))
					point.y = curMovingElement.y + align.y;
				if (curMovingElement.autoGroupChangable)
				{
					coreMdt.autoGroupController.move(curMovingElement.x - curMovingElement.vo.x, 
													 curMovingElement.y - curMovingElement.vo.y, group);
				}
				curMovingElement.x = point.x;
				curMovingElement.y = point.y;
			}
			
			coreMdt.autoAlignController.clear();
			
			if (coreMdt.createNewShape == false)
			{
				var index:Vector.<int> = coreMdt.autoLayerController.autoLayer(curMovingElement);
				if (index)
				{
					oldPropertyObj.indexChangeElement = coreMdt.autoLayerController.indexChangeElement;
					oldPropertyObj.index = index;
				}
				
				coreMdt.currentElement = curMovingElement;
				coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
				
				var xDir:Number = mainUI.stage.mouseX - stageStartX;
				xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
				var yDir:Number = mainUI.stage.mouseY - stageStartY;
				yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
				
				coreMdt.autofitController.autofitElementPosition(curMovingElement, xDir, yDir);
			}
			else
			{
				if (coreMdt.currentElement.vo is PageVO)
					PageVO(coreMdt.currentElement.vo).thumbUpdatable = true;
				coreMdt.createNewShape = false;
				coreMdt.createNewShapeMouseUped = true;
				if (coreMdt.createNewShapeMouseUped && coreMdt.createNewShapeTweenOver)
				{
					coreMdt.pageManager.refreshPageThumbsByElement(curMovingElement);
					coreMdt.sendNotification(Command.SElECT_ELEMENT, curMovingElement);
				}
			}
		}
		
		
		/**
		 * 坐标转换器
		 */		
		private function get layoutTransformer():LayoutTransformer
		{
			return mainUI.layoutTransformer;
		}
		
		/**
		 */		
		private function get selector():ElementSelector
		{
			return coreMdt.selector;
		}
		
		/**
		 */		
		private var stageStartX:Number;
		private var stageStartY:Number;
		
		/**
		 */		
		private var sourceX:Number;
		
		/**
		 */		
		private var sourceY:Number;
		
		/**
		 */		
		private function get curMovingElement():ElementBase
		{
			return coreMdt.curInteractElement;
		}
		
		/**
		 */		
		private function set curMovingElement(value:ElementBase):void
		{
			coreMdt.curInteractElement = value;
		}
		
		/**
		 */		
		private function get mainUI():CoreApp
		{
			return coreMdt.coreApp;
		}
		
		/**
		 */		
		private var coreMdt:CoreMediator;
		
		private var point:Point = new Point;
		private var align:Point;
		private var oldPropertyObj:Object;
		
		private var group:Boolean;
	}
}