package view.elementSelector.scaleRollControl
{
	import com.greensock.TweenLite;
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import commands.Command;
	
	import flash.display.Sprite;
	
	import view.element.GroupElement;
	import view.element.PageElement;
	import view.element.text.TextEditField;
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	import view.interact.multiSelect.TemGroupElement;
	
	/**
	 */	
	public class ScaleControl implements IClickMove
	{
		public function ScaleControl(holder:ElementSelector, ui:Sprite)
		{
			this.selector = holder;
			
			clickMoveControl = new ClickMoveControl(this, ui);
		}
		
		/**
		 */		
		private var clickMoveControl:ClickMoveControl
		
		/**
		 */		
		private var selector:ElementSelector;
		
		/**
		 * 尺寸缩放的过程中当前元素尺寸同步缩放(因选择框的位置尺寸受当前元素VO的scale影响), 
		 * 
		 * 但智能组合元素不是VO层面的尺寸缩放，直到调用缩放命令才真正进行缩放；
		 * 
		 * 此时，当前元素无视缩放命令
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			// 比例的增量
			var scaleDis:Number = (selector.curRDis) / selector.rDis;
			var s:Number = selector.curScale * Math.abs(scaleDis);
			//缩放自动对齐检测，如检测不到需要对齐的缩放值，返回NaN
			scale = selector.coreMdt.autoAlignController.checkScale(selector.element, s);
			
			selector.element.scale = s;
			
			selector.coreMdt.autoGroupController.scale(selector.element.scale / selector.curScale, selector.element, group);
			
			selector.layoutInfo.update(false);
			selector.render();
			
			if (selector.element is PageElement)
				(selector.element as PageElement).layoutPageNum(s);
			
		}
		
		/**
		 */		
		public function clicked():void
		{
			
		}
		
		/**
		 */		
		public function startMove():void
		{
			//防止元素创建动画未完毕时缩放图形，这样会造成图形比例紊乱
			TweenLite.killTweensOf(selector.element, true);
			
			selector.rDis = selector.curRDis;
			selector.curScale = selector.element.scale;
			
			oldPropertyObj = {};
			oldPropertyObj.scale = selector.element.scale;
			
			lastMouseX = selector.coreMdt.coreApp.stage.mouseX;
			lastMouseY = selector.coreMdt.coreApp.stage.mouseY;
			
			group = ((selector.element is TemGroupElement) || (selector.element is GroupElement));
		}
		
		/**
		 */			
		public function stopMove():void
		{
			if (!isNaN(scale))
			{
				selector.element.scale = scale;
				selector.coreMdt.autoGroupController.scale(selector.element.scale / selector.curScale, selector.element, group);
			}
			
			var index:Vector.<int> = selector.coreMdt.autoLayerController.autoLayer(selector.element);
			if (index)
			{
				oldPropertyObj.indexChangeElement = selector.coreMdt.autoLayerController.indexChangeElement;
				oldPropertyObj.index = index;
			}
			
			selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
			
			var xDir:int = selector.coreMdt.coreApp.stage.mouseX - lastMouseX;
			xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
			var yDir:int = selector.coreMdt.coreApp.stage.mouseY - lastMouseY;
			yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
			
			selector.coreMdt.autofitController.autofitElementPosition(selector.coreMdt.currentElement, xDir, yDir);
			selector.coreMdt.autoAlignController.clear();
			
		}
		
		private var oldPropertyObj:Object;
		
		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private var scale:Number;
		private var group:Boolean;
	}
}