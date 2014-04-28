package landray.kp.maps.main.elements
{
	import model.vo.LineVO;
	
	/**
	 * 单箭头线条
	 */	
	public class ArrowLine extends Line
	{
		public function ArrowLine($vo:LineVO)
		{
			super($vo);
		}
		
		/**
		 */		
		override public function render():void
		{
			if(!rendered)
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
}