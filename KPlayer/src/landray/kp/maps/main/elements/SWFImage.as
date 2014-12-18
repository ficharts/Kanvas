package landray.kp.maps.main.elements
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	
	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public class SWFImage extends ImageBase
	{
		public function SWFImage($vo:ElementVO)
		{
			super($vo);
		}
		
		/**
		 */		
		override protected function initIMG(data:Object):void
		{
			swf = data;
			swf.x = - swf.width / 2;
			swf.y = - swf.height / 2;
			
			addChild(swf as DisplayObject);
		}
		
		/**
		 */		
		private var swf:Object;
	}
}