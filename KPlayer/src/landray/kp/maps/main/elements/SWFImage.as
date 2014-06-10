package landray.kp.maps.main.elements
{
	import flash.display.Sprite;
	
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
			swf = data as Sprite;
			swf.x = - swf.width / 2;
			swf.y = - swf.height / 2;
			
			addChild(swf);
		}
		
		/**
		 */		
		private var swf:Sprite;
	}
}