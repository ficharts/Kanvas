package util
{
	import model.vo.ElementVO;

	public class ElementUtil
	{
		public static function cloneVO(target:ElementVO, source:ElementVO):void
		{
			target.id = ElementCreator.id;
			target.styleType = source.styleType;
			target.styleID = source.styleID;
			
			target.color      = source.color;
			target.colorIndex = source.colorIndex;
			target.thickness  = source.thickness;
			
			StyleUtil.applyStyleToElement(source);  
			
			target.x        = source.x;
			target.y        = source.y;
			target.width    = source.width;
			target.height   = source.height;
			target.scale    = source.scale;
			target.rotation = source.rotation;
		}
	}
}