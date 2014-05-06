package model.vo
{
	public class StarVO extends ShapeVO
	{
		public function StarVO()
		{
			super();
		}
		
		override public function clone():ElementVO
		{
			var vo:StarVO = super.clone() as StarVO;
			vo.innerRadius = innerRadius;
			return vo;
		}
		
		override public function exportData(template:XML):XML
		{
			template = super.exportData(template);
			template.@innerRadius = innerRadius;
			return template;
		}
		
		/**
		 */		
		public var innerRadius:Number = 0.5;
	}
}