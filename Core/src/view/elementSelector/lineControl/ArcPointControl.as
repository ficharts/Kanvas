package view.elementSelector.lineControl
{
	import com.kvs.utils.MathUtil;
	
	import flash.geom.Point;
	
	import mx.utils.ColorUtil;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 * 弧度控制点
	 */	
	public class ArcPointControl extends StartEndControlBase
	{
		public function ArcPointControl(selector:ElementSelector, ui:ControlPointBase)
		{
			super(selector, ui);
		}
		
		/**
		 * 获取起始点的全局相对坐标
		 */		
		override public function startMove():void
		{
			cacheOldProperty();
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			var cp:Point = LayoutUtil.elementPointToStagePoint(vo.x, vo.y, selector.coreMdt.canvas);
			
			//调整弧度控制点位置
			var r:Number = selector.curRDis / vo.scale / selector.layoutTransformer.canvasScale;
			var rad:Number = (selector.getRote(selector.stage.mouseY, selector.stage.mouseX, cp.y, cp.x) - vo.rotation) / 180 * Math.PI;
			vo.arc = Math.sin(rad) * r;
			
			//刷新，渲染
			selector.element.render();
			selector.update();
		}
		
		/**
		 */		
		protected var arcX:Number = 0;
		
		/**
		 */		
		protected var arcY:Number = 0;
	}
}