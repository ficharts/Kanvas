package model.vo
{
	/**
	 * 对话框的VO
	 */	
	public class DialogVO extends ShapeVO
	{
		public function DialogVO()
		{
			super();
		}
		
		override public function clone():ElementVO
		{
			var vo:DialogVO = super.clone() as DialogVO;
			vo.r = r;
			vo.rAngle = rAngle;
			return vo;
		}
		
		override public function exportData():XML
		{
			xml = super.exportData();
			xml.@r = r;
			xml.@rAngle = rAngle;
			return xml;
		}
		
		/**
		 */		
		public var r:Number = 100;
		
		/**
		 */		
		public var rAngle:Number = 73.8;
	}
}