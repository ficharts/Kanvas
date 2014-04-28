package view.elementSelector.lineControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.dec.NullPad;
	
	import commands.Command;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;

	/**
	 */	
	public class StartEndControlBase implements IClickMove
	{
		public function StartEndControlBase(selector:ElementSelector, ui:ControlPointBase)
		{
			this.selector = selector;
			
			moveControl = new ClickMoveControl(this, ui);
		}
		
		/**
		 */		
		private var moveControl:ClickMoveControl;
		
		/**
		 */		
		protected var selector:ElementSelector;
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			var xDis:Number = (endX - startX);
			var yDis:Number = (endY - startY);
			
			//线条中心点的全局坐标
			var x:Number = startX + xDis / 2;
			var y:Number = startY + yDis / 2;
			
            // 全局坐标转换为画布坐标
			var point:Point = LayoutUtil.stagePointToElementPoint(x, y, selector.coreMdt.canvas);
			vo.x = point.x;
			vo.y = point.y;
			
			var r:Number = Math.sqrt(xDis * xDis + yDis * yDis);
			
			vo.width = r / selector.layoutTransformer.canvasScale / vo.scale;
			vo.rotation = selector.getRote(endY, endX, startY, startX);
			
			//刷新，渲染
			selector.element.render();
			selector.update();
		}
		
		/**
		 * 获取起始点的全局相对坐标
		 */		
		public function startMove():void
		{
			//获取结束点的坐标
			var rad:Number = lineRad;// 全局相对角度
			var r:Number = vo.width / 2 * vo.scale * selector.layoutTransformer.canvasScale;
			
			endX = selector.x + r * Math.cos(rad);
			endY = selector.y + r * Math.sin(rad);
			
			var sRad:Number = rad - Math.PI;
			
			startX = selector.x + r * Math.cos(sRad);
			startY = selector.y + r * Math.sin(sRad);
			
			cacheOldProperty();
		}
		
		/**
		 * 结束控制点的移动
		 */		
		public function stopMove():void
		{
			selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldObj);
			
			var xDir:int = selector.coreMdt.coreApp.stage.mouseX - lastMouseX;
			xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
			var yDir:int = selector.coreMdt.coreApp.stage.mouseY - lastMouseY;
			yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
			
			selector.coreMdt.autofitController.autofitElementPosition(selector.coreMdt.currentElement, xDir, yDir);
		}
		
		/**
		 */		
		protected function cacheOldProperty():void
		{
			//记录历史属性，用于撤销
			oldObj = {};
			oldObj.x = vo.x;
			oldObj.y = vo.y;
			oldObj.width = vo.width;
			oldObj.rotation = vo.rotation;
			oldObj.arc = vo.arc;
			
			lastMouseX = selector.coreMdt.coreApp.stage.mouseX;
			lastMouseY = selector.coreMdt.coreApp.stage.mouseY;
		}
		
		/**
		 * 线条的相对角度
		 */		
		protected function get lineRad():Number
		{
			return (selector.element.rotation + selector.coreMdt.canvas.rotation) / 180 * Math.PI;
		}
		 
		/**
		 */		
		protected function get vo():LineVO
		{
			return selector.element.vo as LineVO;
		}
		
		/**
		 */		
		public function clicked():void
		{
		}
		
		/**
		 */		
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		
		/**
		 */		
		protected var startX:Number = 0;
		
		/**
		 */		
		protected var startY:Number = 0;
		
		/**
		 */		
		protected var endX:Number = 0;
		
		/**
		 */		
		protected var endY:Number = 0;
		
		/**
		 */		
		protected var oldObj:Object;
		
	}
}