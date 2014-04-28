package view.elementSelector.sizeControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	
	import commands.Command;
	
	import flash.geom.Point;
	
	import util.LayoutUtil;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 */	
	public class RightPointControl extends SizeControlPointBase
	{
		public function RightPointControl(holder:ElementSelector, ui:ControlPointBase)
		{
			super(holder);
			this.moveControl = new ClickMoveControl(this, ui);
		}
		
		/**
		 */		
		override public function startMove():void
		{
			super.startMove();
			
			oldSize = holder.element.vo.width;
			oldPropertyObj = {};
			oldPropertyObj.width = holder.element.vo.width;
			oldPropertyObj.x = holder.element.vo.x;
			oldPropertyObj.y = holder.element.vo.y;
			
			middleLeft = holder.element.middleLeft;
			middleRight = holder.element.middleRight;
			
			lastMouseX = holder.coreMdt.coreApp.stage.mouseX;
			lastMouseY = holder.coreMdt.coreApp.stage.mouseY;
		}
		
		override public function stopMove():void
		{
			super.stopMove();
			
			if (align && ! isNaN(align.x) && ! isNaN(align.y))
			{
				holder.element.vo.width = Point.distance(orign, align) / holder.element.scale;
				var center:Point = Point.interpolate(orign, align, .5);
				holder.element.vo.x = center.x;
				holder.element.vo.y = center.y;
				holder.element.render();
			}
			
			updateHolderLayout();
			
			var index:Vector.<int> = holder.coreMdt.autoLayerController.autoLayer(holder.element);
			if (index)
			{
				oldPropertyObj.indexChangeElement = holder.coreMdt.autoLayerController.indexChangeElement;
				oldPropertyObj.index = index;
			}
			
			holder.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
			
			var xDir:int = holder.coreMdt.coreApp.stage.mouseX - lastMouseX;
			xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
			var yDir:int = holder.coreMdt.coreApp.stage.mouseY - lastMouseY;
			yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
			
			holder.coreMdt.autofitController.autofitElementPosition(holder.coreMdt.currentElement, xDir, yDir);
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			var rad:Number = curRad - Math.PI / 2;;
			
			//鼠标到图形旋转法线垂线的距离, 影响到图形的宽度
			var newDis:Number = getDisFromMpToLine(rad);
			
			// 防止因旋转角度不同造成的拉伸方向颠倒
			if (Math.cos(rad) > 0)
				newDis *= - 1;
			
			var hDis:Number = newDis - oldDis;
			var newSize:Number = oldSize + hDis / holder.element.scale / holder.layoutTransformer.canvas.scaleX;
			oppsite = (newSize < 0);
			
			holder.element.vo.width = Math.abs(newSize);
			
			var rote:Number = rad - Math.PI / 2;
			var temp:Point = LayoutUtil.stagePointToElementPoint(oldX - hDis / 2 * Math.cos(rote), oldY - hDis / 2 * Math.sin(rote), holder.coreMdt.canvas);
			holder.element.vo.x = temp.x;
			holder.element.vo.y = temp.y;
			holder.element.render();
			
			var currPoint:Point = (oppsite) ? holder.element.middleLeft : holder.element.middleRight;
			orign = (oppsite) ? middleRight : middleLeft;
			
			align = holder.coreMdt.autoAlignController.checkPosition(holder.element, currPoint, "x");
			
			updateHolderLayout();
		}
		
		private var middleLeft:Point;
		private var middleRight:Point;
		private var oppsite:Boolean;
		private var oldPropertyObj:Object;
		
		private var align:Point;
		private var orign:Point;
		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
	}
}