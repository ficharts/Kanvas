package util.layout
{
	import flash.geom.Point;
	
	import model.vo.ElementVO;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.shapes.LineElement;

	/**
	 * 当前图形元件的布局信息获取器， 获取的尺寸
	 * 
	 * 位置信息是相对于整个stage的；
	 * 
	 * 用于定位型变框和状态感应框（鼠标滑入滑出效果）
	 */	
	public class ElementLayoutInfo
	{
		public function ElementLayoutInfo(transformer:LayoutTransformer)
		{
			this.transformer = transformer;
		}
		
		/**
		 */		
		public var transformer:LayoutTransformer;
		
		/**
		 * 重新获取位置尺寸信息
		 */		
		public function update(useVOProperty:Boolean = true):void
		{
			if (currentElementUI)
			{
				_scale  = ((useVOProperty) ? currentElementUI.vo.scale : currentElementUI.scale) * transformer.canvasScale;
				
				
				_height = ((useVOProperty) ? currentElementUI.scaledHeight : currentElementUI.tempScaledHeight) * transformer.canvasScale;
				
				
				_width  = ((useVOProperty) ? currentElementUI.scaledWidth  : currentElementUI.tempScaledWidth ) * transformer.canvasScale;
				
				
				//左上角坐标
				_tx = - _width  * .5;
				_ty = - _height * .5;
				
				updateXY();
			}
			
		}
		
		/**
		 */		
		private function updateXY():void
		{
			var point:Point = LayoutUtil.elementPointToStagePoint(currentElementUI.x, currentElementUI.y, transformer.canvas);
			_x = point.x;
			_y = point.y;
		}
		
		/**
		 * 左上角的x坐标
		 */		
		public function get tx():Number
		{
			return _tx;
		}
		
		/**
		 * 左上角的y坐标
		 */		
		public function get ty():Number
		{
			return _ty;
		}
		
		/**
		 */		
		private var _tx:Number;
		private var _ty:Number;
		
		/**
		 * 中心点x坐标
		 */		
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 */		
		public function get y():Number
		{
			return _y;
		}
		
		private var _x:Number;
		private var _y:Number;
		
		
		/**
		 */		
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 */		
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 */		
		private var _width:Number;
		private var _height:Number;
		
		/**
		 */		
		public function get angle():Number
		{
			return currentElementVo.rotation;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
		}
		private var _scale:Number = 1;
		
		/**
		 */		
		private function get currentElementVo():ElementVO
		{
			return currentElementUI.vo;
		}
		
		/**
		 */		
		public function get currentElementUI():ElementBase
		{
			return _curElement;
		}
		
		/**
		 */		
		public function set currentElementUI(value:ElementBase):void
		{
			if(value && value != _curElement)
			{
				_curElement = value;
			}
		}
		
		/**
		 */		
		private var _curElement:ElementBase;
		
	}
}