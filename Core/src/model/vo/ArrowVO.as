package model.vo
{
	/**
	 * 单箭头与双箭头的VO
	 */	
	public class ArrowVO extends ShapeVO
	{
		public function ArrowVO()
		{
			super();
		}
		
		override public function clone():ElementVO
		{
			var vo:ArrowVO = super.clone() as ArrowVO;
			vo.arrowWidth  = arrowWidth;
			vo.trailHeight = trailHeight;
			return vo;
		}
		
		override public function exportData():XML
		{
			xml = super.exportData();
			xml.@arrowWidth  = arrowWidth;
			xml.@trailHeight = trailHeight;
			return xml;
		}
		
		/**
		 * 箭头的宽度
		 */		
		public var arrowWidth:Number = 60;
		
		/**
		 * 箭头尾巴的高度
		 */		
		public var trailHeight:Number = 48;
	}
}