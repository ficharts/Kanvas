package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 线条
	 */	
	public class LineElement extends ElementBase implements IAutoGroupElement
	{
		public function LineElement(vo:ElementVO)
		{
			super(vo);
			_elementPageConvertable = false;
			xmlData = <line/>;
		}
		
		/**
		 */		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["arc"];
		
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@thickness = vo.thickness;
			xmlData.@borderAlpha = vo.style.getBorder.alpha;
			xmlData.@arc = lineVO.arc;
			
			return xmlData;
		}
		
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new LineElement(cloneVO(new LineVO));
		}
		
		/**
		 */		
		override protected function cloneVO(newVO:ElementVO):ElementVO
		{
			super.cloneVO(newVO);
			
			newVO.type = vo.type;
			newVO.styleID = vo.styleID;
			(newVO as LineVO).arc = lineVO.arc;
			
			return newVO;
		}
		
		/**
		 */		
		override public function showHoverEffect():void { }
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			graphics.clear();
			StyleManager.setLineStyle(graphics, vo.style.getBorder, vo.style, vo);
			graphics.moveTo(- lineVO.width / 2, 0);
			graphics.curveTo(0, lineVO.arc * 2, lineVO.width / 2, 0);
		}
		
		override public function get topLeft():Point
		{
			tlPoint.x = vo.scale * - .5 * vo.width;
			tlPoint.y = vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
			return caculateTransform(tlPoint);
		}
		
		override public function get topCenter():Point
		{
			tcPoint.x = 0;
			tcPoint.y = vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
			return caculateTransform(tcPoint);
		}
		
		override public function get topRight():Point
		{
			trPoint.x = vo.scale *   .5 * vo.width;
			trPoint.y = vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
			return caculateTransform(trPoint);
		}
		
		override public function get middleLeft():Point
		{
			mlPoint.x = vo.scale * - .5 * vo.width;
			mlPoint.y = vo.scale *   .5 * lineVO.arc;
			return caculateTransform(mlPoint);
		}
		
		override public function get middleCenter():Point
		{
			mcPoint.x = 0;
			mcPoint.y = vo.scale * .5 * lineVO.arc;
			return caculateTransform(mlPoint);
		}
		
		override public function get middleRight():Point
		{
			mrPoint.x = vo.scale * .5 * vo.width;
			mrPoint.y = vo.scale * .5 * lineVO.arc;
			return caculateTransform(mrPoint);
		}
		
		override public function get bottomLeft():Point
		{
			blPoint.x = vo.scale * - .5 * vo.width;
			blPoint.y = vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
			return caculateTransform(blPoint);
		}
		
		override public function get bottomCenter():Point
		{
			bcPoint.x = 0;
			bcPoint.y = vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
			return caculateTransform(bcPoint);
		}
		
		override public function get bottomRight():Point
		{
			brPoint.x = vo.scale *   .5 * vo.width;
			brPoint.y = vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
			return caculateTransform(brPoint);
		}
		
		override public function get top():Number
		{
			return vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
		}
		
		override public function get bottom():Number
		{
			return vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
		}
		
		/*override public function get scaledHeight():Number
		{
			var h:Number = (vo.height + Math.abs(lineVO.arc * 2)) * vo.scale;
			
			if(vo.style && vo.style.getBorder)
				h = h + vo.thickness * vo.scale;
			
			return h;
		}
		
		override public function get tempScaledHeight():Number
		{
			var h:Number = (vo.height + Math.abs(lineVO.arc * 2)) * scale;
			if(vo.style && vo.style.getBorder)
				h = h + vo.thickness * scale;
			return h;
		}*/
		
		
		/**
		 * 图形处于选择状态并按下图形时调用
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			selector.frame.alpha = 0.5;
		}
		
		/**
		 * 图形移动结束后或者临时组合被按下并释放后调用此方法，显示型变框
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			selector.frame.alpha = 1;
		}
		
		/**
		 * 隐藏图形控制点，开启线条控制点
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			ViewUtil.show(selector.lineControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			ViewUtil.hide(selector.lineControl);
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.lineShape);
		}
		
		/**
		 */		
		override public function drawBG():void
		{
			var w:Number = Math.max(vo.width * .5, 10);
			var h:Number = Math.max(vo.height * .5, 10);
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xe0e0e0, 0);
			bg.graphics.drawRect(0, 0, w, h);
			bg.graphics.endFill();
		}
		
		/**
		 */		
		protected function get lineVO():LineVO
		{
			return vo as LineVO;
		}
		
	}
}