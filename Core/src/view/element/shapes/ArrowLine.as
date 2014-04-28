package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.events.Event;
	
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import view.element.ElementBase;
	
	/**
	 * 单箭头线条
	 */	
	public class ArrowLine extends LineElement
	{
		public function ArrowLine(vo:ElementVO)
		{
			super(vo);
			
			xmlData = <arrowLine/>
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new ArrowLine(cloneVO(new LineVO));
		}
		
		/**
		 * 效果绘制的范围需要从全局获取
		 */		
		override public function renderHoverEffect(style:Style):void
		{
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			var rad:Number = Math.PI - Math.atan2(lineVO.arc * 2, lineVO.width / 2);
			var r:uint = 5 * lineVO.thickness;
			
			graphics.moveTo(lineVO.width / 2, 0);
			graphics.lineTo(lineVO.width / 2 + Math.cos(rad + Math.PI / 4) * r, Math.sin(rad + Math.PI / 4) * r);
			
			graphics.moveTo(lineVO.width / 2, 0);
			graphics.lineTo(lineVO.width / 2 + Math.cos(rad - Math.PI / 4) * r, Math.sin(rad - Math.PI / 4) * r);
		}
	}
}