package view.interact
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	import com.kvs.utils.RectangleUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.shapes.LineElement;
	import view.element.text.TextEditField;

	/**
	 * 
	 * 智能镜头
	 * 
	 */	
	public final class ElementAutofitController
	{
		public function ElementAutofitController($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
		}
		
		/**
		 * 检测元素的坐标是否超出画布边界，是则移至画布中心
		 * 
		 */
		public function autofitElementPosition(element:ElementBase, xDir:int = 0, yDir:int = 0):Boolean
		{
			if (enabled && element && element.mouseEnabled)
			{
				//最后需要移动的相对位置
				var x:Number = 0;
				var y:Number = 0;
				//画布矩形范围
				var canvasBound:Rectangle = coreMdt.coreApp.bound;
				
				var toolBarWidth :Number = coreMdt.selector.toolBar.barWidth;
				var toolBarHeight:Number = coreMdt.selector.toolBar.barHeight;
				
				//-------------------------------------------------------------------------------
				
				//元素坐标的范围判断
				var centerPaddingLeft :Number = canvasBound.left  + toolBarWidth * .5;
				var centerPaddingRight:Number = canvasBound.right - toolBarWidth * .5;
				
				var point:Point = getToolBarPoint(element);
				point = LayoutUtil.elementPointToStagePoint(point.x, point.y, coreMdt.canvas);
				
				//元素的坐标
				var elementX:Number = point.x;
				//元素中心点需要偏移的坐标，元素顶部在Y方向上不可能超过工具条的位置，所以中心点不需要在Y方向进行判断
				var centerOffsetX:Number = 0;
				if (xDir == 0 || xDir ==-1)
					centerOffsetX = autofitLeft(elementX, centerPaddingLeft);
				if (xDir == 0 || xDir == 1)
					centerOffsetX = (centerOffsetX == 0) ? autofitRight(elementX, centerPaddingRight) : centerOffsetX;
				
				//-------------------------------------------------------------------------------
				
				//元素矩形的范围
				var rectPaddingLeft  :Number = canvasBound.left;
				var rectPaddingRight :Number = canvasBound.right;
				var rectPaddingTop   :Number = canvasBound.top + toolBarHeight;
				var rectPaddingBottom:Number = canvasBound.bottom;
				
				//element矩形范围判断
				var rect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element);
				var rectOffsetX:Number = 0;
				
				//检测
				if (xDir == 0 || xDir == -1)
					rectOffsetX = autofitLeft(rect.left, rectPaddingLeft);
				if (xDir == 0 || xDir == 1)
					rectOffsetX = (rectOffsetX == 0) ? autofitRight(rect.right, rectPaddingRight) : rectOffsetX;
				
				//元素矩形范围需要偏移的坐标
				if (yDir == 0 || yDir == -1)
					y = autofitTop(rect.top, rectPaddingTop);
				if (yDir == 0 || yDir == 1)
					y = (y == 0) ? autofitBottom(rect.bottom, rectPaddingBottom) : y;
				
				//X坐标根据情况取其中一种
				if (rect.left < rectPaddingLeft || elementX < centerPaddingLeft)
					x = Math.min(centerOffsetX, rectOffsetX);
				else if (rect.right > rectPaddingRight || elementX > centerPaddingRight)
					x = Math.max(centerOffsetX, rectOffsetX);
				
				if (x != 0 || y != 0)
					coreMdt.zoomMoveControl.zoomMoveOff(1, -x, -y, time);
				return true;
			}
			return false;
		}
		
		/**
		 * 自适应文本编辑器工具条的位置
		 * 
		 */
		public function autofitEditorInputText(xDir:int = 0, yDir:int = 0):Boolean
		{
			if (enabled)
			{
				var x:Number = 0;
				var y:Number = 0;
				//画布矩形范围
				var canvasBound:Rectangle = coreMdt.coreApp.bound;
				var editorBound:Rectangle = coreMdt.coreApp.textEditor.editorBound;
				
				if (xDir == 0 || xDir == 1)
					x = autofitRight(editorBound.right, canvasBound.right);
				if (xDir == 0 || xDir == -1)
					x = (x == 0) ? autofitLeft(editorBound.left, canvasBound.left) : x;
				
				if (yDir == 0 || yDir == 1)
					y = autofitBottom(editorBound.bottom, canvasBound.bottom);
				if (yDir == 0 || yDir == -1)
					y = (y == 0) ? autofitTop(editorBound.top, canvasBound.top) : y;
				
				if (x != 0 || y != 0)
					coreMdt.zoomMoveControl.zoomMoveOff(1, -x, -y, time);
				return true;

			}
			return false;
		}
		
		/**
		 * 检测文本进入编辑状态的scale，太小则放大一些
		 * 
		 */
		public function autofitEditorModifyText(element:ElementBase, xDir:int = 0, yDir:int = 0):Boolean
		{
			if (enabled && element && element is TextEditField)
			{
				var x:Number = 0;
				var y:Number = 0;
				//缩放前元素相对于stage所占矩形位置
				var eleBefBound:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element, true);
				var plsScale:Number = (eleBefBound.height < 20) ? 20 / eleBefBound.height : 1;
				var aimScale:Number = coreMdt.layoutTransformer.canvasScale * plsScale;
				
				//缩放前元素中心点
				var eleBefPoint:Point = new Point((eleBefBound.left + eleBefBound.right) * .5, (eleBefBound.top + eleBefBound.bottom) * .5);
				//缩放前元素中心点相对于画布原点的向量
				var eleBefVector:Point = eleBefPoint.clone();
				eleBefVector.offset(-coreMdt.canvas.x, -coreMdt.canvas.y);
				//缩放后元素中心点相对于画布原点的向量
				var eleAftVector:Point = eleBefVector.clone();
				PointUtil.multiply(eleAftVector, plsScale);
				//缩放后元素中心点
				var eleAftPoint:Point = eleAftVector.clone();
				eleAftPoint.offset(coreMdt.canvas.x, coreMdt.canvas.y);
				//缩放后元素相对于stage所占矩形位置
				var eleAftBound:Rectangle = eleBefBound.clone();
				eleAftBound.width *= plsScale;
				eleAftBound.height *= plsScale;
				eleAftBound.x = eleBefPoint.x - .5 * eleAftBound.width;
				eleAftBound.y = eleBefPoint.y - .5 * eleAftBound.height;
				
				//画布需要平移的向量
				var vector:Point = eleBefVector.subtract(eleAftVector);
				
				//editor缩放前所占矩形
				var edtBefBound:Rectangle = coreMdt.coreApp.textEditor.editorBound;
				//editor缩放后所占矩形
				var edtAftBound:Rectangle = edtBefBound.clone();
				edtAftBound.bottom -= coreMdt.coreApp.textEditor.fieldHeight * (1 - plsScale);
				edtAftBound.right = edtAftBound.left + Math.max(coreMdt.coreApp.textEditor.offSet * 2 + eleAftBound.width, coreMdt.coreApp.textEditor.panelWidth);
				edtAftBound.x = eleAftBound.x - coreMdt.coreApp.textEditor.offSet;
				edtAftBound.y = eleAftBound.y - coreMdt.coreApp.textEditor.offSet - coreMdt.coreApp.textEditor.panelHeight;
				
				//画布矩形范围
				var canvasBound:Rectangle = coreMdt.coreApp.bound;
				
				//检测编辑器范围是否超出画布范围
				if (xDir == 0 || xDir == 1)
					x = autofitRight(edtAftBound.right, canvasBound.right);
				if (xDir == 0 || xDir == -1)
					x = (x == 0) ? autofitLeft(edtAftBound.left, canvasBound.left) : x;
				
				if (yDir == 0 || yDir == 1)
					y = autofitBottom(edtAftBound.bottom, canvasBound.bottom);
				if (yDir == 0 || yDir == -1)
					y = (y == 0) ? autofitTop(edtAftBound.top, canvasBound.top) : y;
				
				vector.x -= x;
				vector.y -= y;
				
				coreMdt.zoomMoveControl.zoomMoveOff(plsScale, vector.x, vector.y, time);
				return true;
			}
			return false;
		}
		
		private function getToolBarPoint(element:ElementBase):Point
		{
			var rotation:Number = MathUtil.modRotation(element.rotation + coreMdt.canvas.rotation);
			var point:Point;
			if (element is LineElement)
			{
				if (element.rotation >= 0 && element.rotation < 180)
					point = element.topLeft;
				else
					point = element.topRight;
			}
			else
			{
				if (rotation >= 10 && rotation < 80)
					point = element.topLeft;
				else if (rotation >= 80 && rotation < 100)
					point = element.middleLeft;
				else if (rotation >= 100 && rotation < 170)
					point = element.bottomLeft;
				else if (rotation >= 170 || rotation < 190)
					point = element.bottomCenter;
				else if (rotation >= 190 && rotation < 260)
					point = element.bottomRight;
				else if (rotation >= 260 && rotation < 280)
					point = element.middleRight;
				else if (rotation >= 280 && rotation < 350)
					point = element.topRight;
				else
					point = element.topCenter;
			}
			return point;
		}
		
		private function autofitLeft(left:Number, paddingLeft:Number):Number
		{
			return (left < paddingLeft) ? left - paddingLeft : 0;
		}
		
		private function autofitRight(right:Number, paddingRight:Number):Number
		{
			return (right > paddingRight) ? right - paddingRight : 0;
		}
		
		private function autofitTop(top:Number, paddingTop:Number):Number
		{
			return (top < paddingTop) ? top - paddingTop : 0;
		}
		
		private function autofitBottom(bottom:Number, paddingBottom:Number):Number
		{
			return (bottom > paddingBottom) ? bottom - paddingBottom : 0;
		}
		
		public var enabled:Boolean = true;
		
		private var coreMdt:CoreMediator;
		
		private var time:Number = .7;
	}
}