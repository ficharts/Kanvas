package view.element.shapes
{
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import view.element.ElementBase;
	
	/**
	 * 双箭头线条
	 */	
	public class DoubleArrowLine extends ArrowLine
	{
		public function DoubleArrowLine(vo:ElementVO)
		{
			super(vo);
			
			xmlData = <doubleArrowLine/>
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new DoubleArrowLine(cloneVO(new LineVO));
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			var rad:Number = Math.atan2(lineVO.arc * 2, lineVO.width / 2);
			var r:uint = 5 * lineVO.thickness;
			
			graphics.moveTo( - lineVO.width / 2, 0);
			graphics.lineTo( - lineVO.width / 2 + Math.cos(rad + Math.PI / 4) * r, Math.sin(rad + Math.PI / 4) * r);
			
			graphics.moveTo( - lineVO.width / 2, 0);
			graphics.lineTo( - lineVO.width / 2 + Math.cos(rad - Math.PI / 4) * r, Math.sin(rad - Math.PI / 4) * r);
			
		}
	}
}