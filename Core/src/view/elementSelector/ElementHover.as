package view.elementSelector
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.layout.ElementLayoutInfo;
	
	import view.element.ElementBase;
	
	/**
	 * 当鼠标划入图形后的效果, 这里仅是负责效果框外轮廓尺寸的计算及样式，具体渲染交给元件自己
	 */	
	public class ElementHover extends Shape
	{
		public function ElementHover(layoutInfo:ElementLayoutInfo, canvas:Sprite)
		{
			super();
			
			this.layoutInfo = layoutInfo;
			this.canvas = canvas;
			
			XMLVOMapper.fuck(styleXML, style);
		}
		
		/**
		 */		
		private var canvas:Sprite;
		
		/**
		 * 显示
		 */		
		public function show():void
		{
			if (element) 
			{
				layoutInfo.currentElementUI = element;
				layoutInfo.update();
				
				
				style.width  = (layoutInfo.width  + offSet * 2) / element.vo.scale / canvas.scaleX;
				style.height = (layoutInfo.height + offSet * 2) / element.vo.scale / canvas.scaleY;
				style.tx = - style.width  / 2;
				style.ty = - style.height / 2;
				//trace(layoutInfo.width, element.vo.scale, style.width, style.height, style.tx, style.ty);
				
				element.renderHoverEffect(style);
			}
		}
		
		/**
		 * 
		 */		
		public function getHoverHeight(h:Number, el:ElementBase):Number
		{
			return (h + offSet * 2) / el.scale / canvas.scaleY
		}
		
		/**
		 */		
		private var offSet:uint = 2;
		
		/**
		 * 隐藏型变框
		 */		
		public function hide():void
		{
			if (element) 
				element.clearHoverEffect();
		}
		
		/**
		 */		
		private var layoutInfo:ElementLayoutInfo;
		
		/**
		 */		
		private var _element:ElementBase;

		/**
		 */
		public function get element():ElementBase
		{
			return _element;
		}

		/**
		 * @private
		 */
		public function set element(value:ElementBase):void
		{
			_element = value;
		}
		
		/**
		 */		
		private var style:Style = new Style;
		
		/**
		 */		
		private var styleXML:XML = <style>
										<border color='#DDDDDD' thikness='1' alpha='1' scaleMode='none'/>
									</style>

	}
}